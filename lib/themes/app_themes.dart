import 'package:flutter/material.dart';

class MyAppThemes {
	static final lightTheme = ThemeData(
		colorScheme: ColorScheme.fromSeed(
			seedColor: Colors.deepPurple,
			brightness: Brightness.light,
		),
		useMaterial3: true,
		brightness: Brightness.light,
	);

	static final darkTheme = ThemeData(
		colorScheme: ColorScheme.fromSeed(
			seedColor: Colors.deepPurple,
			brightness: Brightness.dark,
		),
		useMaterial3: true,
		brightness: Brightness.dark,
	);
}