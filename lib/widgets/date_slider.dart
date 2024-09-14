import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSlider extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DateSlider({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  DateSliderState createState() => DateSliderState();
}

class DateSliderState extends State<DateSlider> {
  late DateTime currentDate;

  @override
  void initState() {
    super.initState();
    currentDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 31, // Show a month of dates
        itemBuilder: (context, index) {
          DateTime date = currentDate.add(Duration(days: index - 3));
          bool isSelected = DateFormat('yyyy-MM-dd').format(date) ==
            DateFormat('yyyy-MM-dd').format(widget.selectedDate);
          return GestureDetector(
            onTap: () {
              widget.onDateSelected(date);
            },
            child: Container(
              width: 80,
              alignment: Alignment.center,
              decoration: isSelected
                  ? const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 2, color: Colors.blue),
                      ),
                    )
                  : null,
              child: Text(
                DateFormat('E d').format(date),
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
