import 'package:final_fitness/user_model.dart'; // delete after development of home page
import 'package:flutter/material.dart';
import 'package:final_fitness/pages/auth_page.dart';
import 'package:final_fitness/pages/home_page.dart';
import 'package:final_fitness/api_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => MetricData(),
      child: const MyApp(),
    )
  );
}

class MetricData with ChangeNotifier {
  int _waterAmount = 0;
  int _stepsAmount = 0;
  dynamic _waterGoal = "-";
  dynamic _stepsGoal = "-";

  int get waterAmount => _waterAmount;
  int get stepsAmount => _stepsAmount;
  dynamic get waterGoal => _waterGoal;
  dynamic get stepsGoal => _stepsGoal;

  void incrementWater(int amount) {
    _waterAmount += amount;
    notifyListeners();
  }

  void incrementSteps(int amount) {
    _stepsAmount += amount;
    notifyListeners();
  }

  void setWaterGoal(int goal) {
    _waterGoal = goal;
    notifyListeners();
  }

  void setStepsGoal(int goal) {
    _stepsGoal = goal;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        // colorScheme: ColorScheme.light(
        //   primary: Colors.blue,
        //   secondary: Colors.blue,
        // ),!
      ),
      debugShowCheckedModeBanner: false,
      // replace all of this with just AuthPage() to home property to see the login and register pages // mocking a user for development
      home: FutureBuilder<User?>(
        future: usr(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show loading spinner while waiting
          } else if (snapshot.hasError) {
            return Text(
                'Error: ${snapshot.error}'); // Show error message if something went wrong
          } else if (snapshot.hasData) {
            return HomePage(
                usr: snapshot.data!); // Pass User object to HomePage
          } else {
            return Text('No data'); // Show message if no data
          }
        },
      ),
    );
  }
}

// Delete this after development of home page
Future<User?> usr() async {
  try {
    var user =
        await ApiService().login("christian.vqz3@gmail.com", "christian");
    return user;
  } catch (e) {
    print(e);
  }
  return null;
}
