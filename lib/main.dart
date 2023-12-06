import 'package:final_fitness/user_model.dart'; // delete after development of home page
import 'package:flutter/material.dart';
import 'package:final_fitness/pages/auth_page.dart';
import 'package:final_fitness/pages/home_page.dart';
import 'package:final_fitness/api_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
    create: (context) => MetricData(),
    child: const MyApp(),
  ));
}

// Export class to another file for better organization
class MetricData with ChangeNotifier {
  int _calories = 0;
  int _carbs = 0;
  int _fat = 0;
  int _protein = 0;
  int _waterAmount = 0;
  int _stepsAmount = 0;

  dynamic _caloriesGoal = "-";
  dynamic _carbsGoal = "-";
  dynamic _fatGoal = "-";
  dynamic _proteinGoal = "-";
  dynamic _waterGoal = "-";
  dynamic _stepsGoal = "-";

  int get calories => _calories;
  int get carbs => _carbs;
  int get fat => _fat;
  int get protein => _protein;
  int get waterAmount => _waterAmount;
  int get stepsAmount => _stepsAmount;

  dynamic get caloriesGoal => _caloriesGoal;
  dynamic get carbsGoal => _carbsGoal;
  dynamic get fatGoal => _fatGoal;
  dynamic get proteinGoal => _proteinGoal;
  dynamic get waterGoal => _waterGoal;
  dynamic get stepsGoal => _stepsGoal;

  void setCalories(int curAmount, int newAmount) {
    _calories = (_calories - curAmount) + newAmount;
    notifyListeners();
  }

  void setCarbs(int curAmount, int newAmount) {
    _carbs = (_carbs - curAmount) + newAmount;
    notifyListeners();
  }

  void setFat(int curAmount, int newAmount) {
    _fat = (_fat - curAmount) + newAmount;
    notifyListeners();
  }

  void setProtein(int curAmount, int newAmount) {
    _protein = (_protein - curAmount) + newAmount;
    notifyListeners();
  }

  void setWater(int curAmount, int newAmount) {
    _waterAmount = (_waterAmount - curAmount) + newAmount;
    notifyListeners();
  }

  void setSteps(int curAmount, int newAmount) {
    _stepsAmount = (_stepsAmount - curAmount) + newAmount;
    notifyListeners();
  }

  void incrementCalories(int amount) {
    _calories += amount;
    notifyListeners();
  }

  void incrementCarbs(int amount) {
    _carbs += amount;
    notifyListeners();
  }

  void incrementFat(int amount) {
    _fat += amount;
    notifyListeners();
  }

  void incrementProtein(int amount) {
    _protein += amount;
    notifyListeners();
  }

  void incrementWater(int amount) {
    _waterAmount += amount;
    notifyListeners();
  }

  void incrementSteps(int amount) {
    _stepsAmount += amount;
    notifyListeners();
  }

  void decrementCalories(int amount) {
    _calories -= amount;
    notifyListeners();
  }

  void decrementCarbs(int amount) {
    _carbs -= amount;
    notifyListeners();
  }

  void decrementFat(int amount) {
    _fat -= amount;
    notifyListeners();
  }

  void decrementProtein(int amount) {
    _protein -= amount;
    notifyListeners();
  }

  void decrementWater(int amount) {
    _waterAmount -= amount;
    notifyListeners();
  }

  void decrementSteps(int amount) {
    _stepsAmount -= amount;
    notifyListeners();
  }

  // void initCalories(int amount) {
  //   _calories -= amount;
  //   notifyListeners();
  // }

  // void initCarbs(int amount) {
  //   _carbs -= amount;
  //   notifyListeners();
  // }

  // void initFat(int amount) {
  //   _fat -= amount;
  //   notifyListeners();
  // }

  // void initProtein(int amount) {
  //   _protein -= amount;
  //   notifyListeners();
  // }

  // void initWater(int amount) {
  //   _waterAmount -= amount;
  //   notifyListeners();
  // }

  // void initSteps(int amount) {
  //   _stepsAmount -= amount;
  //   notifyListeners();
  // }

  void fetchCalories(int amount) {
    _calories = amount;
    notifyListeners();
  }

  void fetchCarbs(int amount) {
    _carbs = amount;
    notifyListeners();
  }

  void fetchFat(int amount) {
    _fat = amount;
    notifyListeners();
  }

  void fetchProtein(int amount) {
    _protein = amount;
    notifyListeners();
  }

  void fetchWater(int amount) {
    _waterAmount = amount;
    notifyListeners();
  }

  void fetchSteps(int amount) {
    _stepsAmount = amount;
    notifyListeners();
  }

  void setCaloriesGoal(int goal) {
    _caloriesGoal = goal;
    notifyListeners();
  }

  void setCarbsGoal(int goal) {
    _carbsGoal = goal;
    notifyListeners();
  }

  void setFatGoal(int goal) {
    _fatGoal = goal;
    notifyListeners();
  }

  void setProteinGoal(int goal) {
    _proteinGoal = goal;
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
