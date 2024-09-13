
import 'package:flutter/material.dart';

class MainView extends StatefulWidget{
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
  
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(Object context) {
      return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Scaffold(
            
          );
        }
      );
  }

}