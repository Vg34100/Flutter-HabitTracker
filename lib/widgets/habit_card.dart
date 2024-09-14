import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit_model.dart';

class HabitCard extends StatelessWidget{
	final Habit habit;
	final bool isDone;
	final VoidCallback onDone;
  final VoidCallback onEdit;    // New callback for edit
  final VoidCallback onDelete;  // New callback for delete

	const HabitCard({
		super.key,
		required this.habit,
		required this.isDone,
		required this.onDone,
    required this.onEdit,
    required this.onDelete,
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

		return GestureDetector(
          onLongPress: () {
            _showOptionsDialog(context);
          },

          child: Opacity(
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
          ),
        );
  }
  
  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Options'),
          children: [
            SimpleDialogOption(
              child: const Text('Edit'),
              onPressed: () {
                Navigator.of(context).pop();
                onEdit();
              },
            ),
            SimpleDialogOption(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                onDelete();
              },
            ),
          ],
        );
      },
    );
  }
}