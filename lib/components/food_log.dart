import 'dart:convert';

import 'package:final_fitness/api_service.dart';
import 'package:final_fitness/components/my_button.dart';
import 'package:final_fitness/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../user_model.dart';
import 'my_textfield.dart';

class FoodLog extends StatefulWidget {
  FoodLog(
      {Key? key,
      required this.foodList,
      required this.user,
      required this.callback,
      required this.calController,
      required this.carbController,
      required this.fatController,
      required this.nameController,
      required this.proteinController,
      required this.waterController,
      required this.stepsController})
      : super(key: key);
  final List<Item> foodList;
  User user;
  Function callback;
  TextEditingController nameController;
  TextEditingController calController;
  TextEditingController carbController;
  TextEditingController fatController;
  TextEditingController proteinController;
  TextEditingController waterController;
  TextEditingController stepsController;

  @override
  State<FoodLog> createState() => _FoodLogState();
}

class _FoodLogState extends State<FoodLog> {
  @override
  Widget build(BuildContext context) {
    int len = widget.foodList.length;
    return (len == 0)
        ? SliverList(delegate: SliverChildListDelegate(<Widget>[const Text('empty')]))
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final item = widget.foodList[index];
                return ((index == 0) || (index == (len - 1)))
                    ? firstOrLastItem(item, index, context)
                    : allOtherItems(item, index, context); // Empty space for other indices
              },
              childCount: widget.foodList.length,
            ),
          );
  }

  dynamic deleteItem(item) async {
    DateTime now = DateTime.now();
    String formattedDate =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    try {
      var response = await ApiService()
          .deleteConsumedItem(widget.user.info.infoId, formattedDate, item, widget.user.token);
      var obj = json.decode(response);
      return obj;
    } catch (e) {
      print(e);
    }
  }

  Dismissible firstOrLastItem(Item item, int index, BuildContext context) {
    return Dismissible(
      key: Key(UniqueKey().toString()),
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Remove the item from the data source.
          var deletedItem;
          var newListOfFoodItems = [];
          setState(() {
            deletedItem = widget.foodList.removeAt(index);
          });

          for (item in widget.foodList) {
            var itemObj = item.toJson();
            if (itemObj['type'] == 'water' || itemObj['type'] == 'steps') {
              itemObj.remove('calories');
              itemObj.remove('carbs');
              itemObj.remove('fat');
              itemObj.remove('protein');
              itemObj.remove('name');
            } else {
              itemObj.remove('amount');
              if (itemObj['calories'] == "0") {
                itemObj['calories'] = "-1";
              }
              if (itemObj['carbs'] == "0") {
                itemObj['carbs'] = "-1";
              }
              if (itemObj['fat'] == "0") {
                itemObj['fat'] = "-1";
              }
              if (itemObj['protein'] == "0") {
                itemObj['protein'] = "-1";
              }
            }
            newListOfFoodItems.add(itemObj);
          }

          // Delete item from database
          var response = await deleteItem(newListOfFoodItems);

          // Update token
          widget.user.token = response['token']['accessToken'];
          widget.callback(widget.user);

          // Update metrics
          if (deletedItem.type == 'food') {
            if (deletedItem.calories != null) {
              if (context.mounted) {
                Provider.of<MetricData>(context, listen: false)
                    .decrementCalories(int.parse(deletedItem.calories!));
              }
            }
            if (deletedItem.carbs != null) {
              if (context.mounted) {
                Provider.of<MetricData>(context, listen: false)
                    .decrementCarbs(int.parse(deletedItem.carbs!));
              }
            }
            if (deletedItem.fat != null) {
              if (context.mounted) {
                Provider.of<MetricData>(context, listen: false)
                    .decrementFat(int.parse(deletedItem.fat!));
              }
            }
            if (deletedItem.protein != null) {
              if (context.mounted) {
                Provider.of<MetricData>(context, listen: false)
                    .decrementProtein(int.parse(deletedItem.protein!));
              }
            }
          }
          if (deletedItem.type == 'water') {
            if (deletedItem.amount != null) {
              if (context.mounted) {
                Provider.of<MetricData>(context, listen: false)
                    .decrementWater(int.parse(deletedItem.amount!));
              }
            }
          }
          if (deletedItem.type == 'steps') {
            if (deletedItem.amount != null) {
              if (context.mounted) {
                Provider.of<MetricData>(context, listen: false)
                    .decrementSteps(int.parse(deletedItem.amount!));
              }
            }
          }

          // Then show a snackbar.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$item dismissed")),
          );
        }
      },
      confirmDismiss: (DismissDirection direction) async {
        if (direction == DismissDirection.endToStart) {
          // Delete item
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirm"),
                content: const Text("Are you sure you wish to delete this item?"),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("DELETE")),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("CANCEL"),
                  ),
                ],
              );
            },
          );
        } else {
          // Update item
          if (item.type == 'food') {
            var nController = TextEditingController(text: item.name);
            var caloriesController = TextEditingController(text: item.calories);
            var carbsController = TextEditingController(text: item.carbs);
            var fatsController = TextEditingController(text: item.fat);
            var proteinsController = TextEditingController(text: item.protein);
            showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: 'Close',
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      height: 600,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Update Food Item',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                          ),
                          MyTextField(
                              controller: nController, hintText: 'Enter Name', obscureText: false),
                          MyTextField(
                              controller: caloriesController,
                              hintText: 'Enter Calories',
                              obscureText: false),
                          MyTextField(
                              controller: carbsController,
                              hintText: 'Enter Carbs',
                              obscureText: false),
                          MyTextField(
                              controller: fatsController,
                              hintText: 'Enter Fat',
                              obscureText: false),
                          MyTextField(
                              controller: proteinsController,
                              hintText: 'Enter Protein',
                              obscureText: false),
                          MyButton(
                              onTap: () {
                                // First check if name field was ommitted
                                if (nController.text == "") {
                                  showErrorMessage("Please enter a name for the food item");
                                  return;
                                }
                                DateTime now = DateTime.now();
                                String formattedTime =
                                    '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
                                int oldCals = int.parse(widget.foodList[index].calories!);
                                int oldCarbs = int.parse(widget.foodList[index].carbs!);
                                int oldFat = int.parse(widget.foodList[index].fat!);
                                int oldProtein = int.parse(widget.foodList[index].protein!);

                                var item = Item(
                                  time: formattedTime,
                                  type: 'food',
                                  name: nController.text,
                                  calories: (caloriesController.text == "")
                                      ? "0"
                                      : caloriesController.text,
                                  protein: (proteinsController.text == "")
                                      ? "0"
                                      : proteinsController.text,
                                  fat: (fatsController.text == "") ? "0" : fatsController.text,
                                  carbs: (carbsController.text == "") ? "0" : carbsController.text,
                                );

                                setState(() {
                                  // Update item in foodList
                                  widget.foodList[index] = item;
                                });

                                // Call API to update food to database
                                String formattedDate =
                                    '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
                                updateConsumedItem(widget.user.info.infoId, formattedDate,
                                    widget.foodList, widget.user.token);

                                // Update food macros in UI
                                if (caloriesController.text != "") {
                                  Provider.of<MetricData>(context, listen: false)
                                      .setCalories(oldCals, int.parse(caloriesController.text));
                                } else {
                                  Provider.of<MetricData>(context, listen: false)
                                      .setCalories(oldCals, 0);
                                }
                                if (carbsController.text != "") {
                                  Provider.of<MetricData>(context, listen: false)
                                      .setCarbs(oldCarbs, int.parse(carbsController.text));
                                } else {
                                  Provider.of<MetricData>(context, listen: false)
                                      .setCarbs(oldCarbs, 0);
                                }
                                if (fatsController.text != "") {
                                  Provider.of<MetricData>(context, listen: false)
                                      .setFat(oldFat, int.parse(fatsController.text));
                                } else {
                                  Provider.of<MetricData>(context, listen: false).setFat(oldFat, 0);
                                }
                                if (proteinsController.text != "") {
                                  Provider.of<MetricData>(context, listen: false)
                                      .setProtein(oldProtein, int.parse(proteinsController.text));
                                } else {
                                  Provider.of<MetricData>(context, listen: false)
                                      .setProtein(oldProtein, 0);
                                }

                                Navigator.pop(context);
                              },
                              text: 'Update Food'),
                        ],
                      ),
                    ),
                  );
                });
          } else if (item.type == 'water') {
            var wController = TextEditingController(text: item.amount);
            showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: 'Close',
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      height: 200,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Update Water',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                          ),
                          MyTextField(
                              controller: wController,
                              hintText: 'Enter amount',
                              obscureText: false),
                          MyButton(
                              onTap: () {
                                DateTime now = DateTime.now();
                                String formattedTime =
                                    '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
                                int oldAmount = int.parse(widget.foodList[index].amount!);
                                var item = Item(
                                  time: formattedTime,
                                  type: 'water',
                                  name: "Water",
                                  calories: "-",
                                  protein: "-",
                                  fat: "-",
                                  carbs: "-",
                                  amount: wController.text,
                                );

                                setState(() {
                                  // Update item in foodList
                                  widget.foodList[index] = item;
                                });

                                // Add water object to foodList
                                String formattedDate =
                                    '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
                                updateConsumedItem(widget.user.info.infoId, formattedDate,
                                    widget.foodList, widget.user.token);
                                // Update water amount
                                Provider.of<MetricData>(context, listen: false)
                                    .setWater(oldAmount, int.parse(wController.text));
                                Navigator.pop(context);
                              },
                              text: 'Update Water'),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            var sController = TextEditingController(text: item.amount);
            showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: 'Close',
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      height: 200,
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'Update Steps',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                          ),
                          MyTextField(
                              controller: sController,
                              hintText: 'Enter amount',
                              obscureText: false),
                          MyButton(
                              onTap: () {
                                DateTime now = DateTime.now();
                                String formattedTime =
                                    '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
                                int oldAmount = int.parse(widget.foodList[index].amount!);
                                var item = Item(
                                  time: formattedTime,
                                  type: 'steps',
                                  name: "Steps",
                                  calories: "-",
                                  protein: "-",
                                  fat: "-",
                                  carbs: "-",
                                  amount: sController.text,
                                );

                                setState(() {
                                  // Update item in foodList
                                  widget.foodList[index] = item;
                                });

                                String formattedDate =
                                    '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
                                addFoodItem(widget.user.info.infoId, formattedDate, widget.foodList,
                                    widget.user.token);

                                // Update steps amount
                                Provider.of<MetricData>(context, listen: false)
                                    .setSteps(oldAmount, int.parse(sController.text));
                                Navigator.pop(context);
                              },
                              text: 'Update Steps'),
                        ],
                      ),
                    ),
                  );
                });
          }
        }
      },
      background: Container(color: Colors.blue),
      secondaryBackground: Container(color: Colors.red),
      child: Container(
        height: (index == 0) ? 57 : 56,
        width: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Card(
          color: Colors.grey,
          shape: (index == 0)
              ? const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                )
              : const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                ),
          margin: EdgeInsets.only(bottom: 0, top: 0),
          elevation: 5,
          child: Column(
            children: [
              ListTile(
                shape: (index == 0)
                    ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                      )
                    : RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                      ),
                title: Text(item.name!),
                trailing: Text(item.calories!),
                tileColor: Colors.grey,
              ),
              (index == 0)
                  ? Divider(
                      height: 1,
                      color: Colors.black,
                      thickness: 1,
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  void updateConsumedItem(userId, date, item, accessToken) async {
    // Prepare data in foodlist to be sent to database
    var newListOfFoodItems = [];
    for (item in widget.foodList) {
      var itemObj = item.toJson();
      if (itemObj['type'] == 'water' || itemObj['type'] == 'steps') {
        itemObj.remove('calories');
        itemObj.remove('carbs');
        itemObj.remove('fat');
        itemObj.remove('protein');
        itemObj.remove('name');
      } else {
        if (itemObj['calories'] == "0") {
          itemObj['calories'] = "-1";
        }
        if (itemObj['carbs'] == "0") {
          itemObj['carbs'] = "-1";
        }
        if (itemObj['fat'] == "0") {
          itemObj['fat'] = "-1";
        }
        if (itemObj['protein'] == "0") {
          itemObj['protein'] = "-1";
        }
        itemObj.remove('amount');
      }
      newListOfFoodItems.add(itemObj);
    }

    try {
      var response =
          await ApiService().updateConsumedItem(userId, date, newListOfFoodItems, accessToken);
      // Replace user's token with incoming token in response
      var obj = json.decode(response);
      widget.user.token = obj['token']['accessToken'];
    } catch (e) {
      print(e);
    }
  }

  Dismissible allOtherItems(Item item, int index, BuildContext context) {
    return Dismissible(
      key: Key(UniqueKey().toString()),
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Remove the item from the data source.
          var deletedItem;
          var newListOfFoodItems = [];
          setState(() {
            deletedItem = widget.foodList.removeAt(index);
          });

          for (item in widget.foodList) {
            var itemObj = item.toJson();
            if (itemObj['type'] == 'water' || itemObj['type'] == 'steps') {
              itemObj.remove('calories');
              itemObj.remove('carbs');
              itemObj.remove('fat');
              itemObj.remove('protein');
              itemObj.remove('name');
            } else {
              itemObj.remove('amount');
              if (itemObj['calories'] == "0") {
                itemObj['calories'] = "-1";
              }
              if (itemObj['carbs'] == "0") {
                itemObj['carbs'] = "-1";
              }
              if (itemObj['fat'] == "0") {
                itemObj['fat'] = "-1";
              }
              if (itemObj['protein'] == "0") {
                itemObj['protein'] = "-1";
              }
            }
            newListOfFoodItems.add(itemObj);
          }

          // Delete item from database
          var response = await deleteItem(newListOfFoodItems);

          // Update token
          widget.user.token = response['token']['accessToken'];
          widget.callback(widget.user);

          // Update metrics
          if (deletedItem.type == 'food') {
            if (deletedItem.calories != null) {
              if (context.mounted) {
                Provider.of<MetricData>(context, listen: false)
                    .decrementCalories(int.parse(deletedItem.calories!));
              }
            }
            if (deletedItem.carbs != null) {
              if (context.mounted) {
                Provider.of<MetricData>(context, listen: false)
                    .decrementCarbs(int.parse(deletedItem.carbs!));
              }
            }
            if (deletedItem.fat != null) {
              if (context.mounted) {
                Provider.of<MetricData>(context, listen: false)
                    .decrementFat(int.parse(deletedItem.fat!));
              }
            }
            if (deletedItem.protein != null) {
              if (context.mounted) {
                Provider.of<MetricData>(context, listen: false)
                    .decrementProtein(int.parse(deletedItem.protein!));
              }
            }
          }
          if (deletedItem.type == 'water') {
            if (deletedItem.amount != null) {
              if (context.mounted) {
                Provider.of<MetricData>(context, listen: false)
                    .decrementWater(int.parse(deletedItem.amount!));
              }
            }
          }
          if (deletedItem.type == 'steps') {
            if (deletedItem.amount != null) {
              if (context.mounted) {
                Provider.of<MetricData>(context, listen: false)
                    .decrementSteps(int.parse(deletedItem.amount!));
              }
            }
          }

          // Then show a snackbar.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$item dismissed")),
          );
        }
      },
      confirmDismiss: (DismissDirection direction) async {
        if (direction == DismissDirection.endToStart) {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirm"),
                content: const Text("Are you sure you wish to delete this item?"),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("DELETE")),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("CANCEL"),
                  ),
                ],
              );
            },
          );
        } else {
          // Update item
          if (item.type == 'food') {
            var nController = TextEditingController(text: item.name);
            var caloriesController = TextEditingController(text: item.calories);
            var carbsController = TextEditingController(text: item.carbs);
            var fatsController = TextEditingController(text: item.fat);
            var proteinsController = TextEditingController(text: item.protein);
            showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: 'Close',
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      height: 600,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Update Food Item',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                          ),
                          MyTextField(
                              controller: nController, hintText: 'Enter Name', obscureText: false),
                          MyTextField(
                              controller: caloriesController,
                              hintText: 'Enter Calories',
                              obscureText: false),
                          MyTextField(
                              controller: carbsController,
                              hintText: 'Enter Carbs',
                              obscureText: false),
                          MyTextField(
                              controller: fatsController,
                              hintText: 'Enter Fat',
                              obscureText: false),
                          MyTextField(
                              controller: proteinsController,
                              hintText: 'Enter Protein',
                              obscureText: false),
                          MyButton(
                              onTap: () {
                                // First check if name field was ommitted
                                if (nController.text == "") {
                                  showErrorMessage("Please enter a name for the food item");
                                  return;
                                }
                                DateTime now = DateTime.now();
                                String formattedTime =
                                    '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
                                int oldCals = int.parse(widget.foodList[index].calories!);
                                int oldCarbs = int.parse(widget.foodList[index].carbs!);
                                int oldFat = int.parse(widget.foodList[index].fat!);
                                int oldProtein = int.parse(widget.foodList[index].protein!);

                                var item = Item(
                                  time: formattedTime,
                                  type: 'food',
                                  name: nController.text,
                                  calories: (caloriesController.text == "")
                                      ? "0"
                                      : caloriesController.text,
                                  protein: (proteinsController.text == "")
                                      ? "0"
                                      : proteinsController.text,
                                  fat: (fatsController.text == "") ? "0" : fatsController.text,
                                  carbs: (carbsController.text == "") ? "0" : carbsController.text,
                                );

                                setState(() {
                                  // Update item in foodList
                                  widget.foodList[index] = item;
                                });

                                // Call API to update food to database
                                String formattedDate =
                                    '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
                                updateConsumedItem(widget.user.info.infoId, formattedDate,
                                    widget.foodList, widget.user.token);

                                // Update food macros in UI
                                if (caloriesController.text != "") {
                                  Provider.of<MetricData>(context, listen: false)
                                      .setCalories(oldCals, int.parse(caloriesController.text));
                                } else {
                                  Provider.of<MetricData>(context, listen: false)
                                      .setCalories(oldCals, 0);
                                }
                                if (carbsController.text != "") {
                                  Provider.of<MetricData>(context, listen: false)
                                      .setCarbs(oldCarbs, int.parse(carbsController.text));
                                } else {
                                  Provider.of<MetricData>(context, listen: false)
                                      .setCarbs(oldCarbs, 0);
                                }
                                if (fatsController.text != "") {
                                  Provider.of<MetricData>(context, listen: false)
                                      .setFat(oldFat, int.parse(fatsController.text));
                                } else {
                                  Provider.of<MetricData>(context, listen: false).setFat(oldFat, 0);
                                }
                                if (proteinsController.text != "") {
                                  Provider.of<MetricData>(context, listen: false)
                                      .setProtein(oldProtein, int.parse(proteinsController.text));
                                } else {
                                  Provider.of<MetricData>(context, listen: false)
                                      .setProtein(oldProtein, 0);
                                }

                                Navigator.pop(context);
                              },
                              text: 'Update Food'),
                        ],
                      ),
                    ),
                  );
                });
          } else if (item.type == 'water') {
            var wController = TextEditingController(text: item.amount);
            showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: 'Close',
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      height: 200,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Update Water',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                          ),
                          MyTextField(
                              controller: wController,
                              hintText: 'Enter amount',
                              obscureText: false),
                          MyButton(
                              onTap: () {
                                DateTime now = DateTime.now();
                                String formattedTime =
                                    '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
                                int oldAmount = int.parse(widget.foodList[index].amount!);
                                var item = Item(
                                  time: formattedTime,
                                  type: 'water',
                                  name: "Water",
                                  calories: "-",
                                  protein: "-",
                                  fat: "-",
                                  carbs: "-",
                                  amount: wController.text,
                                );

                                setState(() {
                                  // Update item in foodList
                                  widget.foodList[index] = item;
                                });

                                // Add water object to foodList
                                String formattedDate =
                                    '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
                                updateConsumedItem(widget.user.info.infoId, formattedDate,
                                    widget.foodList, widget.user.token);
                                // Update water amount
                                Provider.of<MetricData>(context, listen: false)
                                    .setWater(oldAmount, int.parse(wController.text));
                                Navigator.pop(context);
                              },
                              text: 'Update Water'),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            var sController = TextEditingController(text: item.amount);
            showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: 'Close',
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      height: 200,
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'Update Steps',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                          ),
                          MyTextField(
                              controller: sController,
                              hintText: 'Enter amount',
                              obscureText: false),
                          MyButton(
                              onTap: () {
                                DateTime now = DateTime.now();
                                String formattedTime =
                                    '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
                                int oldAmount = int.parse(widget.foodList[index].amount!);
                                var item = Item(
                                  time: formattedTime,
                                  type: 'steps',
                                  name: "Steps",
                                  calories: "-",
                                  protein: "-",
                                  fat: "-",
                                  carbs: "-",
                                  amount: sController.text,
                                );

                                setState(() {
                                  // Update item in foodList
                                  widget.foodList[index] = item;
                                });

                                String formattedDate =
                                    '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
                                addFoodItem(widget.user.info.infoId, formattedDate, widget.foodList,
                                    widget.user.token);

                                // Update steps amount
                                Provider.of<MetricData>(context, listen: false)
                                    .setSteps(oldAmount, int.parse(sController.text));
                                Navigator.pop(context);
                              },
                              text: 'Update Steps'),
                        ],
                      ),
                    ),
                  );
                });
          }
        }
      },
      background: Container(color: Colors.blue),
      secondaryBackground: Container(color: Colors.red),
      child: Container(
        height: 57,
        width: 400,
        decoration: BoxDecoration(),
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Card(
          color: Colors.grey,
          margin: EdgeInsets.only(bottom: 0, top: 0),
          elevation: 5,
          child: Column(
            children: [
              ListTile(
                shape: ContinuousRectangleBorder(),
                title: Text(item.name!),
                trailing: Text(item.calories!),
                tileColor: Colors.grey,
              ),
              Divider(
                height: 1,
                color: Colors.black,
                thickness: 1,
              )
            ],
          ),
        ),
      ),
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

  void addFoodItem(userId, date, item, accessToken) async {
    try {
      var response = await ApiService().addConsumedItem(userId, date, item, accessToken);
      // Replace user's token with incoming token in response
      var obj = json.decode(response);
      widget.user.token = obj['token']['accessToken'];
    } catch (e) {
      print(e);
    }
  }
}
