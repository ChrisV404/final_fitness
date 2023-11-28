import 'package:flutter/material.dart';
import 'package:final_fitness/components/my_button.dart';
import 'package:final_fitness/components/my_textfield.dart';
import 'package:final_fitness/components/square_tile.dart';
import 'package:final_fitness/api_service.dart';
import 'package:final_fitness/pages/home_page.dart';
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user up method
  void signUserUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try creating user
    try {
      String? registerUsr = await ApiService().register(
        firstNameController.text,
        lastNameController.text,
        emailController.text,
        passwordController.text,
      );

      if (context.mounted) {
        if (registerUsr != null) {
          // Obtain json from registerUsr string
          var jsonResponse = jsonDecode(registerUsr);
          
          if (jsonResponse["inserted"] != -1) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(data: firstNameController.text),
              ),
            );
          } else {
            Navigator.pop(context);
            showErrorMessage("Email already exists");
          }
        } else {
          Navigator.pop(context);
          showErrorMessage("Request failed...");
        }
      }
    } catch (e) {
      // pop the loading circle
      if (context.mounted) {
        Navigator.pop(context);
      }
      // show error message
      showErrorMessage(e.toString());
    }
  }

  // error message to user
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 240, 81, 57),
              Color.fromARGB(255, 236, 97, 76),
              Color.fromARGB(255, 235, 118, 100),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  const SizedBox(height: 50),

                  // create account
                  Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // first name textfield
                  MyTextField(
                    controller: firstNameController,
                    hintText: 'First Name',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // last name textfield
                  MyTextField(
                    controller: lastNameController,
                    hintText: 'Last Name',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // email textfield
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 25),

                  // sign in button
                  MyButton(
                    text: "Sign Up",
                    onTap: signUserUp,
                  ),

                  const SizedBox(height: 50),

                  // or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Or continue with',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                              )),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // google + apple sign in buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      // google button
                      SquareTile(imagePath: 'lib/images/google.png'),

                      SizedBox(width: 25),

                      // apple button
                      SquareTile(imagePath: 'lib/images/apple.png')
                    ],
                  ),

                  const SizedBox(height: 50),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Login now',
                          style: TextStyle(
                            color: Color.fromARGB(255, 27, 20, 162),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
