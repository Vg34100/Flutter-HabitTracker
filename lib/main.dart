import 'package:flutter/material.dart';
import 'views/main_view.dart';

void main() {
	runApp(const MainApp());
}

class MainApp extends StatelessWidget {
	const MainApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Habit Tracker',
			theme: ThemeData(
				colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 234, 13, 13)),
			),
			home: const MainView(),
		);
	}
}
