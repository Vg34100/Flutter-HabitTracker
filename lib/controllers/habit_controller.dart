import 'package:habit_tracker/models/habit_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class HabitController {
  List<Habit> habits = [];
  static const String habitsKey = 'habits_key';

  HabitController() {
    loadHabits();
  }

  Future<void> loadHabits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? habitsJson = prefs.getStringList(habitsKey);

    if (habitsJson != null) {
      habits = habitsJson.map((habitJson) => Habit.fromJson(habitJson)).toList();
    } else {
      // Initialize with default habits if no data is found
      habits = [
        Habit(
          id: const Uuid().v4(),
          name: 'Read Book',
          assignedIcon: 'book',
        ),
        Habit(
          id: const Uuid().v4(),
          name: 'Write in Journal',
          assignedIcon: 'edit',
        ),
      ];
      saveHabits();
    }
  }

  Future<void> saveHabits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> habitsJson = habits.map((habit) => habit.toJson()).toList();
    await prefs.setStringList(habitsKey, habitsJson);
  }

  Future<void> addHabit(Habit habit) async {
    habits.add(habit);
    await saveHabits();
  }


}