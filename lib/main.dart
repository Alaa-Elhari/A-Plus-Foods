import 'package:a_plus_foods/Screen/login_view.dart';
import 'package:a_plus_foods/Screen/search_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Screen/authentication.dart';
import 'Screen/home_view.dart';
import 'Screen/signup_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Screen());
}

class Screen extends StatelessWidget {
  const Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "A Plus Foods",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.white,
          primarySwatch: Colors.grey,
          textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black))),
      routes: {
        '/': (context) => const Auth(),
        'HomeScreen': (context) => const HomeView(),
        'signupScreen': (context) => const SignupScreen(),
        'loginScreen': (context) => const LoginView(),
        'SearchScreen': (context) => const SearchView(),
      },
    );
  }
}
