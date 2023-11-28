import 'package:flutter/material.dart';
import 'nutrition_page.dart';
import 'workout_page.dart';
import 'calendar_page.dart';
import 'settings_page.dart';
import 'package:final_fitness/components/metrics.dart';
import 'package:final_fitness/components/small_metric.dart';
import 'package:final_fitness/components/food_log.dart';

class HomePage extends StatefulWidget {
  final String data;
  HomePage({super.key, required this.data});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 2;
  List<String> foodList = [];

  // Sign user out method
  void signUserOut() {}

  @override
  Widget build(BuildContext context) {
    foodList.add('Apple');
    foodList.add('Banana');
    foodList.add('Orange');
    return Scaffold(
      bottomNavigationBar: createNavigationBar(),
      backgroundColor: Colors.grey[300],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show menu
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 200,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.fastfood),
                      title: const Text('Food'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NutritionPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.fitness_center),
                      title: const Text('Workout'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkoutPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: const Color.fromARGB(255, 240, 81, 57),
        child: const Icon(Icons.add),
      ),
      body: <Widget>[
        NutritionPage(),
        WorkoutPage(),
        // Home Page
        CustomScrollView(
          slivers: <Widget>[
            const SliverAppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                'Final Fitness',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                  child: Text(
                    "Hi, ${widget.data}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                Center(
                  child: Text(
                    "TODAY",
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
            ),
            Metrics(),
            smallerMetrics(),
            FoodLog(foodList: foodList),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                Container(
                  height: 100,
                ),
              ])
            )
          ],
        ),
        CalendarPage(),
        SettingsPage(),
      ][currentPageIndex],
    );
  }

  NavigationBarTheme createNavigationBar() {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      child: NavigationBar(
        indicatorColor: const Color.fromARGB(0, 255, 255, 255),
        animationDuration: const Duration(milliseconds: 200),
        backgroundColor: const Color.fromARGB(255, 214, 213, 213),
        destinations: const [
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
    );
  }

  SliverList smallerMetrics() {
    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [SmallMetric(), const SizedBox(width: 50), SmallMetric()],
        )
      ]),
    );
  }
}
