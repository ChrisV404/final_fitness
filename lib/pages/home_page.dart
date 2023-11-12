import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String data;
  HomePage({super.key, required this.data});
  // sign user out method
  void signUserOut() {
    // FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
          child: Text(
        "LOGGED IN AS: $data",
        style: const TextStyle(fontSize: 20),
      )),
    );
  }
}
