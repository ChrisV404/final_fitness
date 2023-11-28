import 'package:flutter/material.dart';
import 'package:final_fitness/pages/auth_page.dart';
import 'package:final_fitness/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
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
        // ),
      ),
      debugShowCheckedModeBanner: false,
      home: AuthPage(), // replace with AuthPage() to see the login and register pages
    );
  }
}
