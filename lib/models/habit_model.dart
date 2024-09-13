import 'dart:convert';

class Habit {
  String id; // Identifier
  String name;
  String assignedIcon;
  
  Habit({
    required this.id,
    required this.name,
    required this.assignedIcon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'assignedIcon': assignedIcon,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      assignedIcon: map['assignedIcon'],
    );
  }

    String toJson() => json.encode(toMap());

  factory Habit.fromJson(String source) => Habit.fromMap(json.decode(source));
}

