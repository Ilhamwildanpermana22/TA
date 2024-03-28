import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RxBool isLoading = false.obs;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Control Home'),
        backgroundColor: Colors.orange,
      ),
      drawer: Drawer(
        backgroundColor: Colors.greenAccent,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Control'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Log Out'),
              onTap: () async {
                if (isLoading.isFalse) {
                  isLoading.value = true;
                  await FirebaseAuth.instance.signOut();
                  isLoading.value = false;
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => MyApp(),
                  ));
                }
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFAE8F6), // Light Pink
              Color(0xFFF0CEE1), // Melon
            ],
          ),
        ),
        child: Center(
          child: Text(
            'Welcome to Plant Control!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}
