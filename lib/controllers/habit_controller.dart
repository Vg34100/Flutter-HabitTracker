import 'package:habit_tracker/models/habit_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class HabitController {
	List<Habit> habits = [];
	static const String habitsKey = 'habits_key';

	HabitController() {
		loadHabits();
	}

	Future<void> loadHabits() async {
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
				assignedIcon: 'book',
				),
				Habit(
				id: const Uuid().v4(),
				name: 'Write in Journal',
				recurrence: Recurrence(amount: 1, unit: 'times', period: 'per week'),
				assignedIcon: 'edit',
				),
			];
			saveHabits();
		}
	}

	Future<void> saveHabits() async {
		SharedPreferences prefs = await SharedPreferences.getInstance();
		List<String> habitsJson = habits.map((habit) => habit.toJson()).toList();
		await prefs.setStringList(habitsKey, habitsJson);
	}

	Future<void> addHabit(Habit habit) async {
		habits.add(habit);
		await saveHabits();
	}

	Future<void> markHabitDone(Habit habit, DateTime date) async {
		// For weekly/monthly habits, mark all days in the period as complete
		List<String> datesToMark = _getDatesForPeriod(habit, date);
		for (var dateStr in datesToMark) {
			habit.completion[dateStr] = true;
		}

		await saveHabits();
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
}