import 'package:flutter/material.dart';
import 'package:habit_tracker/models/habit_model.dart';
import 'package:uuid/uuid.dart';

class AddHabitView extends StatefulWidget{
    @override
  _AddHabitViewState createState() => _AddHabitViewState();
}

class _AddHabitViewState extends State<AddHabitView> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String assignedIcon = 'check';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Habit'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Habit Name
              TextFormField(
                decoration: InputDecoration(labelText: 'Habit Name'),
                validator: (value) => value!.isEmpty ? 'Enter a habit name' : null,
                onSaved: (value) => name = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Add Habit'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pop(
                      context,
                      Habit(
                        id: Uuid().v4(),
                        name: name,
                        assignedIcon: assignedIcon,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
