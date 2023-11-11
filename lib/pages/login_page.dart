import 'package:flutter/material.dart';
import 'package:final_fitness/components/my_button.dart';
import 'package:final_fitness/components/my_textfield.dart';
import 'package:final_fitness/components/square_tile.dart';

import 'package:realm/realm.dart'; // maybe we'll use this package in this file?

part 'login_page.g.dart';

// NOTE: These Realm models are private and therefore should be copied into the same .dart file.
@RealmModel()
@MapTo('user')
class _User {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  late String firstName;
  late String lastName;
  late String email;
  // late int
  //     userid; // changed variable name from 'id' to 'userid' to avoid conflict with 'id' above
  late String password;
  late _UserTracked? tracked;
}

// NOTE: These Realm models are private and therefore should be copied into the same .dart file.
@RealmModel(ObjectType.embeddedObject)
@MapTo('user_tracked')
class _UserTracked {
  String? calories;

  String? carbs;

  String? fat;

  String? protein;

  String? steps;

  String? water;
}

// final config = Configuration.local([Car.schema]);
// final realm = Realm(config);
void callMe() async {
  final app = App(AppConfiguration("flutter-hfpbn"));
  final loggedInUser = await app.logIn(Credentials.anonymous());
  final config = Configuration.flexibleSync(
      loggedInUser, [User.schema, UserTracked.schema]);
  final realm = Realm(
    config,
  );

  print("Created local realm db at: ${realm.config.path}");

  // This query reads all the users from the local realm db
  final query = realm.all<User>();

  realm.subscriptions.update((MutableSubscriptionSet mutableSubscriptions) {
    mutableSubscriptions.add(query);
  });

  await realm.subscriptions.waitForSynchronization();

  final newTracked = UserTracked(
    calories: "100",
    carbs: "100",
    fat: "100",
    protein: "100",
    steps: "100",
    water: "100",
  );

  realm.write(() {
    final newUser = User(ObjectId(), "hotmail", "o", "k", "ok", tracked: newTracked);
    realm.add(newUser);
    newUser.tracked!.water = "200";
  });

  
  // This block of code iterates over each user and prints a property
  // var it = query.iterator;
  // while (it.moveNext()) {
  //   print(it.current.tracked!.water);
  // }
}

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    callMe();
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try sign in
    // try {
    //   await FirebaseAuth.instance.signInWithEmailAndPassword(
    //     email: emailController.text,
    //     password: passwordController.text,
    //   );
    //   // pop the loading circle
    //   Navigator.pop(context);
    // } on FirebaseAuthException catch (e) {
    //   // pop the loading circle
    //   Navigator.pop(context);
    //   // show error message
    //   showErrorMessage(e.code);
    // }
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
      backgroundColor: Color.fromARGB(210, 223, 83, 71),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),

                // // logo
                // const Icon(
                //   Icons.lock,
                //   size: 100,
                // ),
                Text(
                  'Final Fitness',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 50),

                // welcome back, you've been missed!
                Text(
                  'Welcome',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

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

                const SizedBox(height: 10),

                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  text: "Sign In",
                  onTap: signUserIn,
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
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
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
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
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
    );
  }
}
