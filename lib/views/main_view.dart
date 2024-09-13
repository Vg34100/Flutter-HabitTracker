
import 'package:flutter/material.dart';
import 'package:habit_tracker/controllers/habit_controller.dart';
import 'package:habit_tracker/widgets/habit_card.dart';

class MainView extends StatefulWidget{
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
  
}

class _MainViewState extends State<MainView> {
  final HabitController _habitController = HabitController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _habitController.loadHabits(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return HabitCard(
              habit: _habitController.habits[0],
              isDone: false,
              onDone: () {
                // Implement your onDone logic here
                setState(() {
                  // Update the state if needed
                });
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}