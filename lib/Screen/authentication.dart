import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

<<<<<<< HEAD:lib/Screen/Auth.dart
import 'Home_view.dart';
import 'Login_view.dart';
=======
import 'home_view.dart';
import 'login_view.dart';

>>>>>>> 09f85fbfd79904e0b2932790d9cbcc591fd8c867:lib/Screen/authentication.dart

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          print("HAS DATA: ${snapshot.hasData}");
          return snapshot.hasData ? const HomeView() : const LoginView();
        }),
      ),
    );
  }
}
