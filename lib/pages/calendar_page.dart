import 'package:final_fitness/pages/home_page.dart';
import 'package:final_fitness/pages/nutrition_page.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  var iconSuccess = Icon(Icons.check_circle);
  var iconFail = Icon(Icons.cancel);

  // Sign user out method
  void signUserOut() {}

  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day; // update `_focusedDay` here as well
    });
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: <Widget>[
                Center(child: Text("Goals met: 0")),
                ListTile(
                  leading: const Icon(Icons.emoji_events),
                  title: Text('Calories'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NutritionPage(),
                      ),
                    );
                  },
                  trailing: iconFail,
                ),
                ListTile(
                  leading: const Icon(Icons.emoji_events),
                  title: Text('Carbs'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NutritionPage(),
                      ),
                    );
                  },
                  trailing: iconFail,
                ),
                ListTile(
                  leading: const Icon(Icons.emoji_events),
                  title: Text('Fat'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NutritionPage(),
                      ),
                    );
                  },
                  trailing: iconFail,
                ),
                ListTile(
                  leading: const Icon(Icons.emoji_events),
                  title: Text('Protein'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NutritionPage(),
                      ),
                    );
                  },
                  trailing: iconFail,
                ),
                ListTile(
                  leading: const Icon(Icons.emoji_events),
                  title: Text('Steps'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NutritionPage(),
                      ),
                    );
                  },
                  trailing: iconFail,
                ),
                ListTile(
                  leading: const Icon(Icons.emoji_events),
                  title: Text('Water'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NutritionPage(),
                      ),
                    );
                  },
                  trailing: iconFail,
                ),
              ],
            ),
          ),
        );
      },
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(100))),
    );
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
