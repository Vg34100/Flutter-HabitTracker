
import 'package:flutter/material.dart';
import 'package:habit_tracker/controllers/habit_controller.dart';
import 'package:habit_tracker/models/habit_model.dart';
import 'package:habit_tracker/views/add_habit_view.dart';
import 'package:habit_tracker/widgets/habit_card.dart';
import 'package:intl/intl.dart';

class MainView extends StatefulWidget{
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
  
}

class _MainViewState extends State<MainView> {
  final HabitController _habitController = HabitController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
      String formattedDate = DateFormat('EEEE, MMM d').format(selectedDate);


    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Hello! Today is $formattedDate',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
        ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: FutureBuilder(
        future: _habitController.loadHabits(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _buildHabitList();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              onPressed: () async {
                var newHabit = await Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => AddHabitView()),
                );
                if (newHabit != null) {
                  setState(() {
                    _habitController.addHabit(newHabit);
                  });
                }
              }, 
              icon: const Icon(Icons.add))
          ],
        ),
      ),
    );
  }

  Widget _buildHabitList() {
    // Separate habits into active and completed
    List<Habit> activeHabits = [];

    List<Widget> habitListWidgets = [];

      habitListWidgets.addAll(
        _habitController.habits.map((habit) => HabitCard(
              habit: habit,
              isDone: false,
              onDone: () {
                setState(() {
                   // Mark as done
                });
              },
            )),
      );



    return ListView(
      children: habitListWidgets,
    );
  }
}