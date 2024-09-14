// lib/views/add_habit_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import '../models/habit_model.dart';
import 'package:uuid/uuid.dart';

class AddHabitView extends StatefulWidget {
  const AddHabitView({Key? key}) : super(key: key);

  @override
  _AddHabitViewState createState() => _AddHabitViewState();
}

class _AddHabitViewState extends State<AddHabitView> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  int amount = 1;
  String unit = 'times';
  String period = 'per day';
  IconData? selectedIcon = Icons.check_box;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // To make sure content is scrollable if needed
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          // Add Material widget to ensure proper theming
          color: Colors.transparent,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Wrap content vertically
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Add New Habit',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ),
                Row(
                  children: [
                    // Icon Picker
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                      child: IconButton(
                        icon: Icon(selectedIcon),
                        onPressed: _pickIcon,
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Habit Name
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'Habit Name'),
                        validator: (value) => value!.isEmpty ? 'Enter a habit name' : null,
                        onSaved: (value) => name = value!,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Divider(),
                // Amount
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter amount' : null,
                  onSaved: (value) => amount = int.parse(value!),
                ),
                const SizedBox(height: 10),
                // Unit
                DropdownButtonFormField<String>(
                  value: unit,
                  items: ['times', 'minutes'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      unit = newValue!;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Unit'),
                ),
                const SizedBox(height: 10),
                // Period
                DropdownButtonFormField<String>(
                  value: period,
                  items: ['per day', 'per week', 'per month'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      period = newValue!;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Period'),
                ),
                const Divider(),
                const SizedBox(height: 30),
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      child: const Text('Add'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (selectedIcon == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please select an icon')),
                            );
                            return;
                          }
                          _formKey.currentState!.save();
                          Habit newHabit = Habit(
                            id: const Uuid().v4(),
                            name: name,
                            assignedIconFamily: selectedIcon!.fontFamily ?? '',
                            assignedIconCodePoint: selectedIcon!.codePoint,
                            recurrence: Recurrence(amount: amount, unit: unit, period: period),
                          );
                          Navigator.of(context).pop(newHabit); // Return the new habit
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickIcon() async {
    IconData? icon = await showIconPicker(
      context,
      iconPackModes: [IconPack.material],
    );

    if (icon != null) {
      setState(() {
        selectedIcon = icon;
      });
    }
  }
}
