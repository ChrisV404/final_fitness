import 'package:flutter/material.dart';

class NutritionPage extends StatefulWidget {
  NutritionPage({Key? key}) : super(key: key);

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrition'),
      ),
      body: Center(
        child: Text('Nutrition Page'),
      ),
    );
  }
}