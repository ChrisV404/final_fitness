import 'package:flutter/material.dart';
import 'nutrition_page.dart';
import 'workout_page.dart';
import 'calendar_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  final String data;
  HomePage({super.key, required this.data});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 2;

  // Sign user out method
  void signUserOut() {}

  Widget nutritionPage() {
    return NutritionPage();
  }

  Widget workoutPage() {
    return WorkoutPage();
  }

  Widget calendarPage() {
    return CalendarPage();
  }

  Widget settingsPage() {
    return SettingsPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        child: NavigationBar(
          indicatorColor: const Color.fromARGB(0, 255, 255, 255),
          animationDuration: Duration(milliseconds: 200),
          backgroundColor: Color.fromARGB(255, 214, 213, 213),
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.fastfood, size: 30),
              selectedIcon: Icon(Icons.fastfood,
                  size: 30, color: Color.fromARGB(255, 240, 81, 57)),
              label: 'Nutrition',
            ),
            NavigationDestination(
              icon: Icon(Icons.fitness_center, size: 30),
              selectedIcon: Icon(Icons.fitness_center,
                  size: 30, color: Color.fromARGB(255, 240, 81, 57)),
              label: 'Workout',
            ),
            NavigationDestination(
              icon: Icon(Icons.home, size: 30),
              selectedIcon: Icon(Icons.home,
                  size: 30, color: Color.fromARGB(255, 240, 81, 57)),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month, size: 30),
              selectedIcon: Icon(Icons.calendar_month,
                  size: 30, color: Color.fromARGB(255, 240, 81, 57)),
              label: 'Calendar',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings, size: 30),
              selectedIcon: Icon(Icons.settings,
                  size: 30, color: Color.fromARGB(255, 240, 81, 57)),
              label: 'Settings',
            ),
          ],
          selectedIndex: currentPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
        ),
      ),
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: <Widget>[
        nutritionPage(),
        workoutPage(),
        Container(
          child: Center(
            child: Text(
              "Hi,: ${widget.data}",
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
        calendarPage(),
        settingsPage(),
      ][currentPageIndex],
    );
  }
}
// Center(
      //     child: Text(
      //   "LOGGED IN AS: ${widget.data}",
      //   style: const TextStyle(fontSize: 20),
      // )),