
import 'package:flutter/material.dart';
import 'package:habit_tracker/controllers/habit_controller.dart';
import 'package:habit_tracker/models/habit_model.dart';
import 'package:habit_tracker/views/add_habit_view.dart';
import 'package:habit_tracker/widgets/date_slider.dart';
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
	void initState() {
		super.initState();
		_habitController.addListener(_onControllerUpdate);
	}

	@override
	void dispose() {
		_habitController.removeListener(_onControllerUpdate);
		super.dispose();
	}

	void _onControllerUpdate() {
		setState(() {}); // Update the UI when the controller notifies changes
	}


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
			body: Padding(
				padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0),
				child: FutureBuilder(
					future: _habitController.loadHabits(),
					builder: (context, snapshot) {
						if (snapshot.connectionState == ConnectionState.done) {
							return _habitController.buildHabitList(selectedDate);
						} else {
							return const Center(child: CircularProgressIndicator());
						}
					},
				),
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
								var newHabit = await Navigator.push(
									context, 
									MaterialPageRoute(builder: (context) => const AddHabitView()),
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

}