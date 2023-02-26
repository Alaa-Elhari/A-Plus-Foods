import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Home_view.dart';
import 'Login_view.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          print("HAS DATA: ${snapshot.hasData}");
          return snapshot.hasData ? const HomeScreen() : const LogininScreen();
        }),
      ),
    );
  }
}
