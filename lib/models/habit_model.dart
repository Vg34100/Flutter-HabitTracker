import 'dart:convert';

class Recurrence {
	int amount;          // e.g., 15
	String unit;         // 'times' or 'minutes'
	String period;       // 'per day', 'per week', 'per month'

	Recurrence({
	required this.amount,
	required this.unit,
	required this.period,
	});

	Map<String, dynamic> toMap() {
	return {
		'amount': amount,
		'unit': unit,
		'period': period,
	};
	}

	factory Recurrence.fromMap(Map<String, dynamic> map) {
	return Recurrence(
		amount: map['amount'],
		unit: map['unit'],
		period: map['period'],
	);
	}
}

class Habit {
	String id; // Identifier
	String name;
	String assignedIcon;

	Recurrence recurrence;        // Structured recurrence
	Map<String, bool> completion; // Date strings mapped to completion status

	Habit({
		required this.id,
		required this.name,
		required this.recurrence,
		required this.assignedIcon,
		Map<String, bool>? completion,
	}) : completion = completion ?? {};

	Map<String, dynamic> toMap() {
	return {
		'id': id,
		'name': name,
		'recurrence': recurrence.toMap(),
		'assignedIcon': assignedIcon,
		'completion': completion,
	};
	}

	factory Habit.fromMap(Map<String, dynamic> map) {
	return Habit(
		id: map['id'],
		name: map['name'],
		recurrence: Recurrence.fromMap(Map<String, dynamic>.from(map['recurrence'])),
		assignedIcon: map['assignedIcon'],
		completion: Map<String, bool>.from(map['completion']),
	);
	}

	String toJson() => json.encode(toMap());

	factory Habit.fromJson(String source) => Habit.fromMap(json.decode(source));
}

