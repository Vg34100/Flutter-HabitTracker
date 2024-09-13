import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit_model.dart';
import 'package:uuid/uuid.dart';

class AddHabitView extends StatefulWidget{
    @override
  _AddHabitViewState createState() => _AddHabitViewState();
}

class _AddHabitViewState extends State<AddHabitView> {
  String name = '';
  String assignedIcon = 'check';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
                child: const Text('Add Habit'),
                onPressed: () {
                    Navigator.pop(
                      context,
                      null
                    );
                },
              ),
    );
  }


}