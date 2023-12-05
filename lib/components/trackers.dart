import 'dart:convert';

import 'package:final_fitness/api_service.dart';
import 'package:final_fitness/components/my_button.dart';
import 'package:final_fitness/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Trackers extends StatefulWidget {
  User user;
  Function callback;
  Trackers({super.key, required this.user, required this.callback});

  @override
  State<Trackers> createState() => _TrackersState();
}

class _TrackersState extends State<Trackers> {
  bool checkboxVal1 = false;
  bool checkboxVal2 = false;
  bool checkboxVal3 = false;
  bool checkboxVal4 = false;
  bool checkboxVal5 = false;
  bool checkboxVal6 = false;
  final calController = TextEditingController();
  final carbController = TextEditingController();
  final fatController = TextEditingController();
  final proteinController = TextEditingController();
  final stepController = TextEditingController();
  final waterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCheckboxValue();
  }

  void _loadCheckboxValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      checkboxVal1 = prefs.getBool('checkboxVal1') ?? false;
      checkboxVal2 = prefs.getBool('checkboxVal2') ?? false;
      checkboxVal3 = prefs.getBool('checkboxVal3') ?? false;
      checkboxVal4 = prefs.getBool('checkboxVal4') ?? false;
      checkboxVal5 = prefs.getBool('checkboxVal5') ?? false;
      checkboxVal6 = prefs.getBool('checkboxVal6') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var map = widget.user.info.tracked.toJson();
    if (map['calories'] == null) {
      map.remove('calories');
    } else {
      if (map['calories'] != "-1") {
        calController.text = map['calories'];
      }
    }
    if (map['carbs'] == null) {
      map.remove('carbs');
    } else {
      if (map['carbs'] != "-1") {
        carbController.text = map['carbs'];
      }
    }
    if (map['fat'] == null) {
      map.remove('fat');
    } else {
      if (map['fat'] != "-1") {
        fatController.text = map['fat'];
      }
    }
    if (map['protein'] == null) {
      map.remove('protein');
    } else {
      if (map['protein'] != "-1") {
        proteinController.text = map['protein'];
      }
    }
    if (map['steps'] == null) {
      map.remove('steps');
    } else {
      if (map['steps'] != "-1") {
        stepController.text = map['steps'];
      }
    }
    if (map['water'] == null) {
      map.remove('water');
    } else {
      if (map['water'] != "-1") {
        waterController.text = map['water'];
      }
    }

    return Container(
      height: 500,
      child: Column(
        children: <Widget>[
          Text(
            'Modify Trackers and Goals',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Select'),
              Text('Tracker'),
              Text('Goal'),
            ],
          ),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: checkboxVal1,
            onChanged: (bool? value) {
              setState(() {
                checkboxVal1 = value!;
              });
            },
            title: Text('Calories'),
            secondary: Container(
              width: 100,
              child: TextField(
                controller: calController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Add calorie goal'),
              ),
            ),
          ),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: checkboxVal2,
            onChanged: (bool? value) {
              setState(() {
                checkboxVal2 = value!;
              });
            },
            title: Text('Carbs (g)'),
            secondary: Container(
              width: 100,
              child: TextField(
                controller: carbController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Add carb goal',
                ),
              ),
            ),
          ),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: checkboxVal3,
            onChanged: (bool? value) {
              setState(() {
                checkboxVal3 = value!;
              });
            },
            title: Text('Fat (g)'),
            secondary: Container(
              width: 100,
              child: TextField(
                controller: fatController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Add fat goal',
                ),
              ),
            ),
          ),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: checkboxVal4,
            onChanged: (bool? value) {
              setState(() {
                checkboxVal4 = value!;
              });
            },
            title: Text('Protein (g)'),
            secondary: Container(
              width: 100,
              child: TextField(
                controller: proteinController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Add protein goal',
                ),
              ),
            ),
          ),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: checkboxVal5,
            onChanged: (bool? value) {
              setState(() {
                checkboxVal5 = value!;
              });
            },
            title: Text('Steps'),
            secondary: Container(
              width: 100,
              child: TextField(
                controller: stepController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Add step goal',
                ),
              ),
            ),
          ),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: checkboxVal6,
            onChanged: (bool? value) {
              setState(() {
                checkboxVal6 = value!;
              });
            },
            title: Text('Water (ml)'),
            secondary: Container(
              width: 100,
              child: TextField(
                controller: waterController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Add water goal',
                ),
              ),
            ),
          ),
          MyButton(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool("checkboxVal1", checkboxVal1);
                prefs.setBool("checkboxVal2", checkboxVal2);
                prefs.setBool("checkboxVal3", checkboxVal3);
                prefs.setBool("checkboxVal4", checkboxVal4);
                prefs.setBool("checkboxVal5", checkboxVal5);
                prefs.setBool("checkboxVal6", checkboxVal6);

                if (checkboxVal1 == true) {
                  if (calController.text == '') {
                    map['calories'] = "-1";
                  } else {
                    map['calories'] = calController.text;
                  }
                } else {
                  map.remove('calories');
                  calController.text = '';
                }
                if (checkboxVal2 == true) {
                  if (carbController.text == '') {
                    map['carbs'] = "-1";
                  } else {
                    map['carbs'] = carbController.text;
                  }
                } else {
                  map.remove('carbs');
                  carbController.text = '';
                }
                if (checkboxVal3 == true) {
                  if (fatController.text == '') {
                    map['fat'] = "-1";
                  } else {
                    map['fat'] = fatController.text;
                  }
                } else {
                  map.remove('fat');
                  fatController.text = '';
                }
                if (checkboxVal4 == true) {
                  if (proteinController.text == '') {
                    map['protein'] = "-1";
                  } else {
                    map['protein'] = proteinController.text;
                  }
                } else {
                  map.remove('protein');
                  proteinController.text = '';
                }
                if (checkboxVal5 == true) {
                  if (stepController.text == '') {
                    map['steps'] = "-1";
                  } else {
                    map['steps'] = stepController.text;
                  }
                } else {
                  map.remove('steps');
                  stepController.text = '';
                }
                if (checkboxVal6 == true) {
                  if (waterController.text == '') {
                    map['water'] = "-1";
                  } else {
                    map['water'] = waterController.text;
                  }
                } else {
                  map.remove('water');
                  waterController.text = '';
                }

                // Send tracked data to database
                try {
                  // Returns user with updated tracked data
                  var response = await ApiService().updateTracked(
                      widget.user.info.infoId, map, widget.user.token);
                  
                  // Update token and tracked
                  var json = jsonDecode(response);
                  var accessToken = json["token"]["accessToken"];
                  widget.user.token = accessToken;
                  widget.user.info.tracked = Tracked.fromJson(map);

                  // Update user object in home page
                  widget.callback(widget.user);
                } catch (e) {
                  print(e);
                }

                if (context.mounted) {
                  Navigator.pop(context, widget.user);
                }
              },
              text: 'Update'),
        ],
      ),
    );
  }
}
