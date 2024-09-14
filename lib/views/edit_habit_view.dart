// lib/views/edit_habit_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import '../models/habit_model.dart';

class EditHabitView extends StatefulWidget {
  final Habit habit;

  const EditHabitView({Key? key, required this.habit}) : super(key: key);

  @override
  _EditHabitViewState createState() => _EditHabitViewState();
}

class _EditHabitViewState extends State<EditHabitView> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late int amount;
  late String unit;
  late String period;
  IconData? selectedIcon;

  @override
  void initState() {
    super.initState();
    // Pre-fill the form fields with the existing habit data
    name = widget.habit.name;
    amount = widget.habit.recurrence.amount;
    unit = widget.habit.recurrence.unit;
    period = widget.habit.recurrence.period;
    selectedIcon = IconData(
      widget.habit.assignedIconCodePoint,
      fontFamily: widget.habit.assignedIconFamily,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          color: Colors.transparent,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Edit Habit',
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
                        initialValue: name,
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
                  initialValue: amount.toString(),
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
                      child: const Text('Save'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (selectedIcon == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please select an icon')),
                            );
                            return;
                          }
                          _formKey.currentState!.save();
                          Habit updatedHabit = Habit(
                            id: widget.habit.id,
                            name: name,
                            assignedIconFamily: selectedIcon!.fontFamily ?? '',
                            assignedIconCodePoint: selectedIcon!.codePoint,
                            recurrence: Recurrence(amount: amount, unit: unit, period: period),
                            completion: widget.habit.completion,
                          );
                          Navigator.of(context).pop(updatedHabit); // Return the updated habit
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
