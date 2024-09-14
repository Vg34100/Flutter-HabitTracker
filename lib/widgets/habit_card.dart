import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit_model.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final bool isDone;
  final VoidCallback onDone;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const HabitCard({
    Key? key,
    required this.habit,
    required this.isDone,
    required this.onDone,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

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
        child: InkWell(
          onTap: () {
            // You can add a specific action for tap if needed
          },
          onLongPress: () {
            _showOptionsDialog(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: habitIcon,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        recurrenceText,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: isDone ? null : onDone,
                  child: const Text('Done'),
                ),
              ],
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