import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit_model.dart';

import 'package:habit_tracker/widgets/habit_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class HabitController extends ChangeNotifier {
	List<Habit> habits = [];
	static const String habitsKey = 'habits_key';

	// HabitController() {
	// 	loadHabits();
	// }

	Future<void> loadHabits() async {
    if (habits.isNotEmpty) {
    // Habits are already loaded
      return;
    }
		SharedPreferences prefs = await SharedPreferences.getInstance();
		List<String>? habitsJson = prefs.getStringList(habitsKey);

		if (habitsJson != null) {
			habits = habitsJson.map((habitJson) => Habit.fromJson(habitJson)).toList();
		} else {
			// Initialize with default habits if no data is found
			habits = [
				Habit(
          id: const Uuid().v4(),
          name: 'Read Book',
          recurrence: Recurrence(amount: 15, unit: 'minutes', period: 'per day'),
          assignedIconFamily: Icons.book.fontFamily ?? '',
          assignedIconCodePoint: Icons.book.codePoint,				
        ),
				Habit(
          id: const Uuid().v4(),
          name: 'Write in Journal',
          recurrence: Recurrence(amount: 1, unit: 'times', period: 'per week'),
          assignedIconFamily: Icons.edit.fontFamily ?? '',
          assignedIconCodePoint: Icons.edit.codePoint,				
        ),
			];
			await saveHabits();
		}
    notifyListeners();
	}

	Future<void> saveHabits() async {
		SharedPreferences prefs = await SharedPreferences.getInstance();
		List<String> habitsJson = habits.map((habit) => habit.toJson()).toList();
		await prefs.setStringList(habitsKey, habitsJson);
	}

  Future<void> addHabit(Habit habit) async {
    habits.add(habit);
    await saveHabits();
    notifyListeners(); 
  }

	Future<void> markHabitDone(Habit habit, DateTime date) async {
		// For weekly/monthly habits, mark all days in the period as complete
		List<String> datesToMark = _getDatesForPeriod(habit, date);
		for (var dateStr in datesToMark) {
			habit.completion[dateStr] = true;
		}

		await saveHabits();
    notifyListeners(); 
	}

	List<String> _getDatesForPeriod(Habit habit, DateTime date) {
		List<String> dates = [];
		if (habit.recurrence.period == 'per day') {
			dates.add(_formatDate(date));
		} else if (habit.recurrence.period == 'per week') {
			DateTime startOfWeek = date.subtract(Duration(days: date.weekday - 1));
			for (int i = 0; i < 7; i++) {
				dates.add(_formatDate(startOfWeek.add(Duration(days: i))));
			}
		} else if (habit.recurrence.period == 'per month') {
			DateTime startOfMonth = DateTime(date.year, date.month, 1);
			int daysInMonth = DateTime(date.year, date.month + 1, 0).day;
			for (int i = 0; i < daysInMonth; i++) {
				dates.add(_formatDate(startOfMonth.add(Duration(days: i))));
			}
		}
		return dates;
	}

	String _formatDate(DateTime date) {
		return '${date.year}-${date.month}-${date.day}';
	}

	bool isHabitDone(Habit habit, DateTime date) {
		String dateKey = _formatDate(date);
		return habit.completion[dateKey] ?? false;
	}

  Widget buildHabitList(DateTime selectedDate) {
		// Separate habits into active and completed
		List<Habit> activeHabits = [];
		List<Habit> completedHabits = [];

		for (var habit in habits) {
			bool isDone = isHabitDone(habit, selectedDate);
			if (isDone) {
				completedHabits.add(habit);
			} else {
				activeHabits.add(habit);
			}
		}

		// Group active habits by recurrence period
		Map<String, List<Habit>> habitsByPeriod = {
			'per day': [],
			'per week': [],
			'per month': [],
		};

	 for (var habit in activeHabits) {
			habitsByPeriod[habit.recurrence.period]?.add(habit);
		}

		List<Widget> habitListWidgets = [];

	 // Build widgets for active habits grouped by period
		habitsByPeriod.forEach((period, habits) {
			if (habits.isNotEmpty) {
				String title = '';
				switch (period) {
					case 'per day':
						title = 'Daily Habits';
						break;
					case 'per week':
						title = 'Weekly Habits';
						break;
					case 'per month':
						title = 'Monthly Habits';
						break;
				}

				habitListWidgets.add(
					Padding(
						padding: const EdgeInsets.all(8.0),
						child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
					),
				);

				habitListWidgets.addAll(
					habits.map((habit) => HabitCard(
                key: ValueKey(habit.id),
								habit: habit,
								isDone: false,
                onDone: () {
                  markHabitDone(habit, selectedDate);
                  notifyListeners();
                },
							)),
				);
			}
		});

		// Add a divider before the completed habits
		if (completedHabits.isNotEmpty) {
			habitListWidgets.add(const Divider());
			habitListWidgets.add(
				const Padding(
					padding: EdgeInsets.all(8.0),
					child: Text('Completed Habits', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
				),
			);

			habitListWidgets.addAll(
				completedHabits.map((habit) => HabitCard(
              key: ValueKey(habit.id),
							habit: habit,
							isDone: true,
							onDone: () {},
						)),
			);
		}


    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: ListView(
        key: ValueKey<String>('habitList_${selectedDate.toString()}'),
        children: habitListWidgets,
      ),
    );
	}

}