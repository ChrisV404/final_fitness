import 'dart:convert';

import 'package:final_fitness/api_service.dart';
import 'package:final_fitness/components/my_button.dart';
import 'package:final_fitness/components/my_textfield.dart';
import 'package:final_fitness/components/trackers.dart';
import 'package:final_fitness/main.dart';
import 'package:final_fitness/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'nutrition_page.dart';
import 'workout_page.dart';
import 'calendar_page.dart';
import 'settings_page.dart';
import 'package:final_fitness/components/metrics.dart';
import 'package:final_fitness/components/small_metric.dart';
import 'package:final_fitness/components/food_log.dart';

class Item {
  // extract this class to a separate file (like user_model.dart)
  String? time;
  String? type;
  String? name;
  String? calories;
  String? protein;
  String? fat;
  String? carbs;

  Item({
    this.time,
    this.type,
    this.name,
    this.calories,
    this.protein,
    this.fat,
    this.carbs,
  });

  Map<String, dynamic> toJson() => {
        "time": time,
        "type": type,
        "name": name,
        "calories": calories,
        "fat": fat,
        "protein": protein,
        "carbs": carbs,
      };
}

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  User usr;
  HomePage({super.key, required this.usr});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 2;
  List<Item> foodList = [];
  final nameController = TextEditingController();
  final calController = TextEditingController();
  final carbController = TextEditingController();
  final fatController = TextEditingController();
  final proteinController = TextEditingController();
  final waterController = TextEditingController();
  final stepsController = TextEditingController();

  // Sign user out method
  void signUserOut() {}

  void callback(User user) {
    widget.usr = user;
  }

  @override
  Widget build(BuildContext context) {
    // Get today's date
    DateTime now = DateTime.now();
    String formattedDate =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';

    return Scaffold(
      bottomNavigationBar: createNavigationBar(),
      backgroundColor: Colors.grey[300],
      floatingActionButton: (currentPageIndex != 2)
          ? null
          : FloatingActionButton(
              onPressed: () {
                // Show menu
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 300,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.fastfood),
                            title: const Text('Add Food'),
                            onTap: () {
                              showGeneralDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  barrierLabel: 'Close',
                                  pageBuilder: (BuildContext context, Animation<double> animation,
                                      Animation<double> secondaryAnimation) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20)),
                                      child: Container(
                                        height: 600,
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              'Add Food Item',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Poppins'),
                                            ),
                                            MyTextField(
                                                controller: nameController,
                                                hintText: 'Enter Name',
                                                obscureText: false),
                                            MyTextField(
                                                controller: calController,
                                                hintText: 'Enter Calories',
                                                obscureText: false),
                                            MyTextField(
                                                controller: carbController,
                                                hintText: 'Enter Carbs',
                                                obscureText: false),
                                            MyTextField(
                                                controller: fatController,
                                                hintText: 'Enter Fat',
                                                obscureText: false),
                                            MyTextField(
                                                controller: proteinController,
                                                hintText: 'Enter Protein',
                                                obscureText: false),
                                            MyButton(
                                                onTap: () {
                                                  // First check if name field was ommitted
                                                  if (nameController.text == "") {
                                                    showErrorMessage(
                                                        "Please enter a name for the food item");
                                                    return;
                                                  }
                                                  DateTime now = DateTime.now();
                                                  String formattedTime =
                                                      '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
                                                  var item = Item(
                                                    time: formattedTime,
                                                    type: 'food',
                                                    name: nameController.text,
                                                    calories: (calController.text == "")
                                                        ? "-1"
                                                        : calController.text,
                                                    protein: (proteinController.text == "")
                                                        ? "-1"
                                                        : proteinController.text,
                                                    fat: (fatController.text == "")
                                                        ? "-1"
                                                        : fatController.text,
                                                    carbs: (carbController.text == "")
                                                        ? "-1"
                                                        : carbController.text,
                                                  );

                                                  setState(() {
                                                    foodList.add(item);
                                                  });

                                                  // Call API to add food to database
                                                  String formattedDate =
                                                      '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
                                                  addFoodItem(widget.usr.info.infoId, formattedDate,
                                                      item.toJson(), widget.usr.token);

                                                  // Update food macros in UI
                                                  if (calController.text != "") {
                                                    Provider.of<MetricData>(context, listen: false)
                                                        .incrementCalories(
                                                            int.parse(calController.text));
                                                  }
                                                  if (carbController.text != "") {
                                                    Provider.of<MetricData>(context, listen: false)
                                                        .incrementCarbs(
                                                            int.parse(carbController.text));
                                                  }
                                                  if (fatController.text != "") {
                                                    Provider.of<MetricData>(context, listen: false)
                                                        .incrementFat(
                                                            int.parse(fatController.text));
                                                  }
                                                  if (proteinController.text != "") {
                                                    Provider.of<MetricData>(context, listen: false)
                                                        .incrementProtein(
                                                            int.parse(proteinController.text));
                                                  }

                                                  Navigator.pop(context);
                                                },
                                                text: 'Add Food'),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.water_drop),
                            title: const Text('Add Water'),
                            onTap: () {
                              showGeneralDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  barrierLabel: 'Close',
                                  pageBuilder: (BuildContext context, Animation<double> animation,
                                      Animation<double> secondaryAnimation) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20)),
                                      child: Container(
                                        height: 200,
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              'Add Water',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Poppins'),
                                            ),
                                            MyTextField(
                                                controller: waterController,
                                                hintText: 'Enter amount',
                                                obscureText: false),
                                            MyButton(
                                                onTap: () {
                                                  DateTime now = DateTime.now();
                                                  String formattedTime =
                                                      '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';

                                                  var waterObj = {
                                                    "time": formattedTime,
                                                    "type": "water",
                                                    "amount": waterController.text
                                                  };

                                                  // Add water object to foodList
                                                  String formattedDate =
                                                      '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
                                                  addFoodItem(widget.usr.info.infoId, formattedDate,
                                                      waterObj, widget.usr.token);
                                                  // Update water amount
                                                  Provider.of<MetricData>(context, listen: false)
                                                      .incrementWater(
                                                          int.parse(waterController.text));
                                                  Navigator.pop(context);
                                                },
                                                text: 'Add Water'),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.directions_walk),
                            title: const Text('Add Steps'),
                            onTap: () {
                              showGeneralDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  barrierLabel: 'Close',
                                  pageBuilder: (BuildContext context, Animation<double> animation,
                                      Animation<double> secondaryAnimation) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20)),
                                      child: Container(
                                        height: 200,
                                        child: Column(
                                          children: <Widget>[
                                            const Text(
                                              'Add Steps',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Poppins'),
                                            ),
                                            MyTextField(
                                                controller: stepsController,
                                                hintText: 'Enter amount',
                                                obscureText: false),
                                            MyButton(
                                                onTap: () {
                                                  DateTime now = DateTime.now();
                                                  String formattedTime =
                                                      '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';

                                                  var stepObj = {
                                                    "time": formattedTime,
                                                    "type": "steps",
                                                    "amount": stepsController.text
                                                  };

                                                  String formattedDate =
                                                      '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
                                                  addFoodItem(widget.usr.info.infoId, formattedDate,
                                                      stepObj, widget.usr.token);

                                                  // Update steps amount
                                                  Provider.of<MetricData>(context, listen: false)
                                                      .incrementSteps(
                                                          int.parse(stepsController.text));
                                                  Navigator.pop(context);
                                                },
                                                text: 'Add Steps'),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.update),
                            title: const Text('Modify Trackers and Goals'),
                            onTap: () {
                              showGeneralDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  barrierLabel: 'Close',
                                  pageBuilder: (BuildContext context, Animation<double> animation,
                                      Animation<double> secondaryAnimation) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20)),
                                      child: Trackers(user: widget.usr, callback: callback),
                                    );
                                  });
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
        RefreshIndicator(
          onRefresh: () async {
            try {
              var response = await ApiService()
                  .fetchConsumed(widget.usr.info.infoId, formattedDate, widget.usr.token);
              var obj = json.decode(response);
              // Update foodlist
              setState(() {
                for (var item in obj['info']['dates'][formattedDate]) {
                  var type = item['type'];
                  var name = item['name'];

                  // Create item object
                  Item foodItem = Item(
                    time: item['time'],
                    type: type,
                    name: name,
                    calories: item['calories'],
                    protein: item['protein'],
                    fat: item['fat'],
                    carbs: item['carbs'],
                  );

                  if (type == 'water') {
                    foodItem.name = 'Water';
                    foodItem.calories = '-';
                    foodItem.protein = '-';
                    foodItem.fat = '-';
                    foodItem.carbs = '-';
                  }
                  if (type == 'steps') {
                    foodItem.name = 'Steps';
                    foodItem.calories = '-';
                    foodItem.protein = '-';
                    foodItem.fat = '-';
                    foodItem.carbs = '-';
                  }

                  foodList.add(foodItem);
                }
              });
            } catch (e) {
              print(e);
            }

            // Refresh metrics
            // await Provider.of<MetricData>(context, listen: false).refreshMetrics();
            // setState(() {});
          },
          child: CustomScrollView(
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
                      "Hi, ${widget.usr.info.firstName}",
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  Center(
                    child: Text(
                      "TODAY",
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
              ]))
            ],
          ),
        ),
        CalendarPage(usr: widget.usr),
        SettingsPage(usr: widget.usr),
      ][currentPageIndex],
    );
  }

  // Might need to extract info value from response (which contains all consumed items from a specific date/dates)
  void addFoodItem(userId, date, item, accessToken) async {
    try {
      var response = await ApiService().addConsumedItem(userId, date, item, accessToken);
      // Replace user's token with incoming token in response
      var obj = json.decode(response);
      widget.usr.token = obj['token']['accessToken'];
    } catch (e) {
      print(e);
    }
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
            selectedIcon: Icon(Icons.fastfood, size: 30, color: Color.fromARGB(255, 240, 81, 57)),
            label: 'Nutrition',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center, size: 30),
            selectedIcon:
                Icon(Icons.fitness_center, size: 30, color: Color.fromARGB(255, 240, 81, 57)),
            label: 'Workout',
          ),
          NavigationDestination(
            icon: Icon(Icons.home, size: 30),
            selectedIcon: Icon(Icons.home, size: 30, color: Color.fromARGB(255, 240, 81, 57)),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month, size: 30),
            selectedIcon:
                Icon(Icons.calendar_month, size: 30, color: Color.fromARGB(255, 240, 81, 57)),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings, size: 30),
            selectedIcon: Icon(Icons.settings, size: 30, color: Color.fromARGB(255, 240, 81, 57)),
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
          children: [
            SmallMetric(
              metricName: 'Steps',
              metricAmount: Provider.of<MetricData>(context, listen: true).stepsAmount,
              goal:
                  Provider.of<MetricData>(context, listen: true).stepsGoal, // supposed to be an int
            ),
            const SizedBox(width: 50),
            SmallMetric(
                metricName: 'Water',
                metricAmount: Provider.of<MetricData>(context, listen: true).waterAmount,
                goal: Provider.of<MetricData>(context, listen: true)
                    .waterGoal // supposed to be an int
                ),
          ],
        )
      ]),
    );
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
