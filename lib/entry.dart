import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:r_place_clone/grid_state.dart';
import 'package:r_place_clone/home.dart';
import 'package:r_place_clone/sign_in_page.dart';

class Entry extends StatelessWidget {
  const Entry({super.key});
  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      rethrow; // Re-throw the error to handle it in FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GridState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'r/place Clone',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
            future: _initializeFirebase(),
            builder: (context, snapshot) {
              // Check for initialization errors
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child:
                    Text('Error initializing Firebase: ${snapshot.error}'),
                  ),
                );
              }

              // Show a loading indicator while Firebase initializes
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return FirebaseAuth.instance.currentUser == null
                  ? const SignIn()
                  : HomePage();
            }),
      ),
    );
  }
}
