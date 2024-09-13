
import 'package:flutter/material.dart';
import 'package:habit_tracker/controllers/habit_controller.dart';
import 'package:habit_tracker/models/habit_model.dart';
import 'package:habit_tracker/views/add_habit_view.dart';
import 'package:habit_tracker/widgets/habit_card.dart';
import 'package:intl/intl.dart';

class MainView extends StatefulWidget{
	const MainView({super.key});

	@override
	State<MainView> createState() => _MainViewState();
	
}

class _MainViewState extends State<MainView> {
	final HabitController _habitController = HabitController();
	DateTime selectedDate = DateTime.now();

	@override
	Widget build(BuildContext context) {
			String formattedDate = DateFormat('EEEE, MMM d').format(selectedDate);


		return Scaffold(
			appBar: AppBar(
				title: Padding(
					padding: const EdgeInsets.all(8.0),
					child: Text(
						'Hello! Today is $formattedDate',
						style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.primary),
						),
				),
					backgroundColor: Theme.of(context).colorScheme.primaryContainer,
			),
			body: FutureBuilder(
				future: _habitController.loadHabits(),
				builder: (context, snapshot) {
					if (snapshot.connectionState == ConnectionState.done) {
						return _buildHabitList();
					} else {
						return const Center(child: CircularProgressIndicator());
					}
				},
			),
			bottomNavigationBar: BottomAppBar(
				child: Row(
					children: [
						IconButton(
							onPressed: () async {
								var newHabit = await Navigator.push(
									context, 
									MaterialPageRoute(builder: (context) => const AddHabitView()),
								);
								if (newHabit != null) {
									setState(() {
										_habitController.addHabit(newHabit);
									});
								}
							}, 
							icon: const Icon(Icons.add))
					],
				),
			),
		);
	}

	Widget _buildHabitList() {
		// Separate habits into active and completed
		List<Habit> activeHabits = [];
		List<Habit> completedHabits = [];

		for (var habit in _habitController.habits) {
			bool isDone = _habitController.isHabitDone(habit, selectedDate);
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
								habit: habit,
								isDone: false,
								onDone: () {
									setState(() {
										_habitController.markHabitDone(habit, selectedDate);
									});
								},
							)),
				);
			}
		});



		return ListView(
			children: habitListWidgets,
		);
	}
}