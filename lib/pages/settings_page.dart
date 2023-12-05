// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:final_fitness/api_service.dart';
import 'package:final_fitness/components/my_button.dart';
import 'package:final_fitness/components/my_textfield.dart';
import 'package:final_fitness/user_model.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  User usr;
  SettingsPage({Key? key, required this.usr}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isVisible = false;

  // Sign user out method
  void signUserOut() {}

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final prevPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPassController = TextEditingController();

  // sign user up method
  void updateUserInfo() async {
    // check if all fields are filled
    if (isVisible) {
      if (firstNameController.text.isEmpty ||
          lastNameController.text.isEmpty ||
          emailController.text.isEmpty ||
          prevPasswordController.text.isEmpty ||
          newPasswordController.text.isEmpty ||
          confirmNewPassController.text.isEmpty) {
        showErrorMessage("Please fill all fields");
        return;
      }
    } else {
      if (firstNameController.text.isEmpty ||
          lastNameController.text.isEmpty ||
          emailController.text.isEmpty) {
        showErrorMessage("Please fill all fields");
        return;
      }
    }

    if (newPasswordController.text == confirmNewPassController.text &&
        isVisible) {
      showErrorMessage("New Password fields do not match");
      return;
    }

    // if password is less than 8 characters
    if (newPasswordController.text.length < 8) {
      showErrorMessage("Password must be at least 8 characters");
      return;
    }

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
        newPasswordController.text,
      );

      if (context.mounted) {
        if (registerUsr != null) {
          // Obtain json from registerUsr string
          var jsonResponse = jsonDecode(registerUsr);

          if (jsonResponse["inserted"] != -1) {
            Navigator.pop(context);
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
      appBar: AppBar(
        title: Text('Settings'),
        actions: [
          TextButton(
            onPressed: () {
              signUserOut();
            },
            child: Text(
              'Sign Out',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),

                    // create account
                    const Text(
                      'Update Account Information:',
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

                    const SizedBox(height: 20),

                    // password textfield
                    TextButton(
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        child: isVisible
                            ? Text("Hide Password Options")
                            : Text("Change Password")),

                    const SizedBox(height: 10),

                    Visibility(
                      visible: isVisible,
                      child: Column(children: [
                        MyTextField(
                          controller: prevPasswordController,
                          hintText: 'Previous Password',
                          obscureText: true,
                        ),
                        const SizedBox(height: 10),
                        MyTextField(
                          controller: newPasswordController,
                          hintText: 'New Password',
                          obscureText: true,
                        ),
                        const SizedBox(height: 10),
                        MyTextField(
                          controller: confirmNewPassController,
                          hintText: 'Confirm New Password',
                          obscureText: true,
                        ),
                        const SizedBox(height: 10),
                      ]),
                    ),

                    const SizedBox(height: 25),

                    // sign in button
                    MyButton(
                      text: "Save Changes",
                      onTap: updateUserInfo,
                    ),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
