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
  String? amount;

  Item({
    this.time,
    this.type,
    this.name,
    this.calories,
    this.protein,
    this.fat,
    this.carbs,
    this.amount,
  });

  Map<String, dynamic> toJson() => {
        "time": time,
        "type": type,
        "name": name,
        "calories": calories,
        "fat": fat,
        "protein": protein,
        "carbs": carbs,
        "amount": amount,
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

  dynamic initResponse(formattedDate) async {
    try {
      var response =
          await ApiService().fetchConsumed(widget.usr.info.infoId, formattedDate, widget.usr.token);
      var obj = json.decode(response);
      return obj;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch data from server
    DateTime now = DateTime.now();
    String formattedDate =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    initResponse(formattedDate).then((obj) {
      setState(() {
        // Check if there's no consumed items for today
        // If not, clear foodList
        if (obj['info']['dates'][formattedDate].length == 0) {
          // foodList.clear();
          return;
        }

        // // Had to clear foodList here because it was duplicating items
        // foodList.clear();

        // There is consumed items for today
        int cals = 0;
        int carbs = 0;
        int fat = 0;
        int protein = 0;
        int water = 0;
        int steps = 0;

        for (var item in obj['info']['dates'][formattedDate]) {
          var type = item['type'];
          var name = item['name'];

          // Create item object
          Item foodItem = Item(
            time: item['time'],
            type: type,
            name: name,
            calories: (item['calories'] == "-1") ? "0" : item['calories'],
            protein: (item['protein'] == "-1") ? "0" : item['protein'],
            fat: (item['fat'] == "-1") ? "0" : item['fat'],
            carbs: (item['carbs'] == "-1") ? "0" : item['carbs'],
            amount: item['amount'],
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

          if (foodItem.type == "food") {
            cals += int.parse(foodItem.calories!);

            carbs += int.parse(foodItem.carbs!);

            fat += int.parse(foodItem.fat!);

            protein += int.parse(foodItem.protein!);
          }
          if (foodItem.type == 'water') {
            water += int.parse(foodItem.amount!);
          }
          if (foodItem.type == 'steps') {
            steps += int.parse(foodItem.amount!);
          }
        }
        // Update metrics
        Provider.of<MetricData>(context, listen: false).fetchCalories(cals);
        Provider.of<MetricData>(context, listen: false).fetchCarbs(carbs);
        Provider.of<MetricData>(context, listen: false).fetchFat(fat);
        Provider.of<MetricData>(context, listen: false).fetchProtein(protein);
        Provider.of<MetricData>(context, listen: false).fetchWater(water);
        Provider.of<MetricData>(context, listen: false).fetchSteps(steps);
      });

      // Assign user new token
      widget.usr.token = obj['token']['accessToken'];
    });
    // fetchConsumed();
  }

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
                                                        ? "0"
                                                        : calController.text,
                                                    protein: (proteinController.text == "")
                                                        ? "0"
                                                        : proteinController.text,
                                                    fat: (fatController.text == "")
                                                        ? "0"
                                                        : fatController.text,
                                                    carbs: (carbController.text == "")
                                                        ? "0"
                                                        : carbController.text,
                                                  );

                                                  setState(() {
                                                    foodList.add(item);
                                                  });

                                                  var food = item.toJson();
                                                  if (food['calories'] == "0") {
                                                    food['calories'] = "-1";
                                                  }
                                                  if (food['protein'] == "0") {
                                                    food['protein'] = "-1";
                                                  }
                                                  if (food['fat'] == "0") {
                                                    food['fat'] = "-1";
                                                  }
                                                  if (food['carbs'] == "0") {
                                                    food['carbs'] = "-1";
                                                  }
                                                  food.remove('amount');

                                                  // Call API to add food to database
                                                  String formattedDate =
                                                      '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
                                                  addFoodItem(widget.usr.info.infoId, formattedDate,
                                                      food, widget.usr.token);

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

                                                  // Clear text fields
                                                  nameController.clear();
                                                  calController.clear();
                                                  carbController.clear();
                                                  fatController.clear();
                                                  proteinController.clear();
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

                                                  // Create water item
                                                  var waterObj = Item(
                                                    time: formattedTime,
                                                    type: "water",
                                                    name: "Water",
                                                    calories: "-",
                                                    protein: "-",
                                                    fat: "-",
                                                    carbs: "-",
                                                    amount: waterController.text,
                                                  );

                                                  setState(() {
                                                    foodList.add(waterObj);
                                                  });

                                                  var water = waterObj.toJson();
                                                  water.remove('calories');
                                                  water.remove('protein');
                                                  water.remove('fat');
                                                  water.remove('carbs');
                                                  water.remove('name');

                                                  // Add water object to foodList
                                                  String formattedDate =
                                                      '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
                                                  addFoodItem(widget.usr.info.infoId, formattedDate,
                                                      water, widget.usr.token);
                                                  // Update water amount
                                                  Provider.of<MetricData>(context, listen: false)
                                                      .incrementWater(
                                                          int.parse(waterController.text));

                                                  waterController.clear();
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

                                                  var stepObj = Item(
                                                    time: formattedTime,
                                                    type: "steps",
                                                    name: "Steps",
                                                    calories: "-",
                                                    protein: "-",
                                                    fat: "-",
                                                    carbs: "-",
                                                    amount: stepsController.text,
                                                  );

                                                  setState(() {
                                                    foodList.add(stepObj);
                                                  });

                                                  var step = stepObj.toJson();
                                                  step.remove('calories');
                                                  step.remove('protein');
                                                  step.remove('fat');
                                                  step.remove('carbs');
                                                  step.remove('name');

                                                  String formattedDate =
                                                      '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
                                                  addFoodItem(widget.usr.info.infoId, formattedDate,
                                                      step, widget.usr.token);

                                                  // Update steps amount
                                                  Provider.of<MetricData>(context, listen: false)
                                                      .incrementSteps(
                                                          int.parse(stepsController.text));

                                                  stepsController.clear();
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
            // Fetch data from server
            try {
              var response = await ApiService()
                  .fetchConsumed(widget.usr.info.infoId, formattedDate, widget.usr.token);
              var obj = json.decode(response);
              // Update foodlist
              setState(() {
                // Check if there's no consumed items for today
                // If not, clear foodList
                if (obj['info']['dates'][formattedDate].length == 0) {
                  foodList.clear();
                  Provider.of<MetricData>(context, listen: false).fetchCalories(0);
                  Provider.of<MetricData>(context, listen: false).fetchCarbs(0);
                  Provider.of<MetricData>(context, listen: false).fetchFat(0);
                  Provider.of<MetricData>(context, listen: false).fetchProtein(0);
                  Provider.of<MetricData>(context, listen: false).fetchWater(0);
                  Provider.of<MetricData>(context, listen: false).fetchSteps(0);
                  return;
                }

                // Had to clear foodList here because it was duplicating items
                foodList.clear();

                // There is consumed items for today
                int cals = 0;
                int carbs = 0;
                int fat = 0;
                int protein = 0;
                int water = 0;
                int steps = 0;

                for (var item in obj['info']['dates'][formattedDate]) {
                  var type = item['type'];
                  var name = item['name'];

                  // Create item object
                  Item foodItem = Item(
                    time: item['time'],
                    type: type,
                    name: name,
                    calories: (item['calories'] == "-1") ? "0" : item['calories'],
                    protein: (item['protein'] == "-1") ? "0" : item['protein'],
                    fat: (item['fat'] == "-1") ? "0" : item['fat'],
                    carbs: (item['carbs'] == "-1") ? "0" : item['carbs'],
                    amount: item['amount'],
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

                  if (foodItem.calories != "-1") {
                    cals += int.parse(foodItem.calories!);
                  }
                  if (foodItem.carbs != "-1") {
                    carbs += int.parse(foodItem.carbs!);
                  }
                  if (foodItem.fat != "-1") {
                    fat += int.parse(foodItem.fat!);
                  }
                  if (foodItem.protein != "-1") {
                    protein += int.parse(foodItem.protein!);
                  }
                  if (foodItem.type == 'water') {
                    water += int.parse(foodItem.amount!);
                  }
                  if (foodItem.type == 'steps') {
                    steps += int.parse(foodItem.amount!);
                  }
                }
                // Update metrics
                Provider.of<MetricData>(context, listen: false).fetchCalories(cals);
                Provider.of<MetricData>(context, listen: false).fetchCarbs(carbs);
                Provider.of<MetricData>(context, listen: false).fetchFat(fat);
                Provider.of<MetricData>(context, listen: false).fetchProtein(protein);
                Provider.of<MetricData>(context, listen: false).fetchWater(water);
                Provider.of<MetricData>(context, listen: false).fetchSteps(steps);
              });

              // Assign user new token
              widget.usr.token = obj['token']['accessToken'];
            } catch (e) {
              print(e);
            }
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
              FoodLog(
                  foodList: foodList,
                  user: widget.usr,
                  callback: callback,
                  nameController: nameController,
                  calController: calController,
                  carbController: carbController,
                  fatController: fatController,
                  proteinController: proteinController,
                  waterController: waterController,
                  stepsController: stepsController),
              SliverList(
                  delegate: SliverChildListDelegate(<Widget>[
                Container(
                  height: 100,
                ),
              ]))
            ],
          ),
        ),
        CalendarPage(),
        SettingsPage(),
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
