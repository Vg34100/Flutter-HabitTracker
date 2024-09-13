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

    return Opacity(
      opacity: isDone ? 0.5 : 1.0,
      child: Card(
        child: ListTile(
          leading: Icon(_getIconData(habit.assignedIcon)),
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

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'book':
        return Icons.book;
      case 'edit':
        return Icons.edit;
      default:
        return Icons.check_circle;
    }
  }
}
