import 'package:flutter/material.dart';

class User {
    late String email;
}
var user = User();


class HomePage extends StatelessWidget {
  HomePage({super.key});  

  // final user = FirebaseAuth.instance.currentUser!;
  
  // sign user out method
  void signUserOut() {
    print("temporary function");
  }

  @override
  Widget build(BuildContext context) {
    user.email = 'gmail.com';
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
          child: Text(
        "LOGGED IN AS: " + user.email!,
        style: TextStyle(fontSize: 20),
      )),
    );
  }
}
