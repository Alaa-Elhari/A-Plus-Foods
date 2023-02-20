import 'package:a_plus_foods/Screen/Login_view.dart';
import 'package:a_plus_foods/Screen/Search_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Screen/Auth.dart';
import 'Screen/Home_view.dart';
import 'Screen/SignUp_view.dart';

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
          textTheme: TextTheme(bodyText2: TextStyle(color: Colors.black))),
      routes: {
        '/': (context) => const Auth(),
        'HomeScreen': (context) => const HomeScreen(),
        'signupScreen': (context) => const LoginUpScreen(),
        'loginScreen': (context) => const LogininScreen(),
        'SearchScreen': (context) => SearchScreen(),
      },
    );
  }
}
