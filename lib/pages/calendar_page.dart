import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // Sign user out method
  void signUserOut() {}

  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day; // update `_focusedDay` here as well
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        actions: [
          TextButton(
            onPressed: () {
              signUserOut();
            },
            child: Text(
              'Sign Out',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Selected day: ${today.toString().split(" ")[0]}"),
            TableCalendar(
              locale: "en_US",
              headerStyle:
                  HeaderStyle(formatButtonVisible: false, titleCentered: true),
              selectedDayPredicate: (day) => isSameDay(day, today),
              focusedDay: today,
              firstDay: DateTime.utc(2020, 01, 01),
              lastDay: DateTime.utc(2025, 12, 31),
              onDaySelected: _onDaySelected,
            ),
          ],
        ),
      ),
    );
  }
}
