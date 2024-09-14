import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit_model.dart';

class HabitCard extends StatelessWidget{
	final Habit habit;
	final bool isDone;
	final VoidCallback onDone;

	const HabitCard({
		super.key,
		required this.habit,
		required this.isDone,
		required this.onDone,
	});
	
	@override
	Widget build(BuildContext context) {
		String recurrenceText = '${habit.recurrence.amount} ${habit.recurrence.unit} ${habit.recurrence.period}';

    Icon habitIcon = Icon(
      IconData(
        habit.assignedIconCodePoint,
        fontFamily: habit.assignedIconFamily,
        fontPackage: null,
      ),
    );

		return Opacity(
			opacity: isDone ? 0.5 : 1.0,
			child: Card(
				child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: habitIcon,
          ),
					title: Text(habit.name),
					subtitle: Text(recurrenceText),
					trailing: ElevatedButton(
						onPressed: isDone ? null : onDone,
						child: const Text('Done'),
					),
				),
			),
		);
	}
}
