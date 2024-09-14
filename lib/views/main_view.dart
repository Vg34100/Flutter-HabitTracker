
import 'package:habit_tracker/controllers/habit_controller.dart';
import 'package:habit_tracker/controllers/theme_controller.dart';
import 'package:habit_tracker/models/habit_model.dart';

import 'package:habit_tracker/views/add_habit_view.dart';
import 'package:habit_tracker/widgets/date_slider.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MainView extends StatefulWidget{
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final HabitController _habitController = HabitController();
  DateTime selectedDate = DateTime.now();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _habitController.addListener(_onControllerUpdate);
    _loadHabits();
  }

  @override
  void dispose() {
    _habitController.removeListener(_onControllerUpdate);
    super.dispose();
  }

  void _onControllerUpdate() {
    setState(() {}); // Update the UI when the controller notifies changes
  }

  Future<void> _loadHabits() async {
    await _habitController.loadHabits();
    setState(() {
      isLoading = false; // Update loading state
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE, MMM d').format(selectedDate);
    final themeController = Provider.of<ThemeController>(context);


    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Column(
          children: [
            Text(
              'Hello!',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              'Today is $formattedDate',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        // Add the toggle button to the AppBar actions
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: IconButton(
            icon: Icon(themeController.themeMode == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () {
              themeController.toggleTheme();
            },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : _habitController.buildHabitList(selectedDate, context),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: DateSlider(
                selectedDate: selectedDate,
                onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
                },
              ),
            ),
            IconButton(
            onPressed: () async {
              var newHabit = await showDialog<Habit>(
              context: context,
              builder: (context) => Dialog(
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                ),
                child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400, // To not extend the modal across the whole width
                  minWidth: 300,
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: const AddHabitView(),
                ),
              ),
              );

              if (newHabit != null) {
              await _habitController.addHabit(newHabit);
              }
            },
            icon: const Icon(Icons.add),
            ),

          ],
        ),
      ),
    );
  }

}