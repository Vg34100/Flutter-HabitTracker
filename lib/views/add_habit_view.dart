import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:habit_tracker/models/habit_model.dart';
import 'package:uuid/uuid.dart';

class AddHabitView extends StatefulWidget{
	const AddHabitView({super.key});

	@override
	AddHabitViewState createState() => AddHabitViewState();
}

class AddHabitViewState extends State<AddHabitView> {
	final _formKey = GlobalKey<FormState>();
	String name = '';
	String assignedIcon = 'check';

	int amount = 1;
	String unit = 'times';
	String period = 'per day';
	

  IconData? selectedIcon = Icons.check_box;



	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Add New Habit'),
			),
			body: Padding(
				padding: const EdgeInsets.all(16.0),
				child: Form(
					key: _formKey,
					child: Column(
						children: [
							// Habit Name
							TextFormField(
								decoration: const InputDecoration(labelText: 'Habit Name'),
								validator: (value) => value!.isEmpty ? 'Enter a habit name' : null,
								onSaved: (value) => name = value!,
							),
														// Amount
							TextFormField(
								decoration: const InputDecoration(labelText: 'Amount'),
								keyboardType: TextInputType.number,
								validator: (value) => value!.isEmpty ? 'Enter amount' : null,
								onSaved: (value) => amount = int.parse(value!),
							),
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
							const SizedBox(height: 20),
                // Icon Picker
                Row(
                  children: [
                    selectedIcon != null
                        ? Icon(selectedIcon)
                        : const Text('No icon selected'),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _pickIcon,
                      child: const Text('Select Icon'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),



							ElevatedButton(
								child: const Text('Add Habit'),
								onPressed: () {
									if (_formKey.currentState!.validate()) {
										_formKey.currentState!.save();
										Navigator.pop(
											context,
											Habit(
												id: const Uuid().v4(),
												name: name,
												recurrence: Recurrence(amount: amount, unit: unit, period: period),
                        assignedIconFamily: selectedIcon!.fontFamily ?? '',
                        assignedIconCodePoint: selectedIcon!.codePoint,
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

  Future<void> _pickIcon() async {
    IconData? icon = await showIconPicker(context,
        iconPackModes: [IconPack.material]);

    if (icon != null) {
      setState(() {
        selectedIcon = icon;
      });
    }
  }
}
