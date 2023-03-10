
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openfoodfacts/model/LoginStatus.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:openfoodfacts/utils/OpenFoodAPIConfiguration.dart';

import 'home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  Color emailColor = Colors.white;
  Color passwordColor = Colors.white;
  bool obscurePassword = true;

  bool loading = false;
  final spinKit = const SpinKitDoubleBounce(
    color: Colors.white,
    size: 20.0,
  );

  Future<LoginStatus?> check() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      return null;
    }
    User offUser = User(
        userId: _emailController.text.trim(),
        password: _passwordController.text.trim());

    return OpenFoodAPIClient.login2(offUser).then((value) {
      OpenFoodAPIConfiguration.globalUser = offUser;
      return value;
    });
  }

  void openSignupScreen() {
    Navigator.of(context).pushReplacementNamed('signupScreen');
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF5F5F5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //images
                Image.asset(
                  'images/iconapppic.jpg',
                  height: 200,
                ),
                const SizedBox(
                  height: 20,
                ), //text
                Text(
                  " SIGN IN ",
                  style: GoogleFonts.robotoCondensed(
                      fontSize: 40, fontWeight: FontWeight.bold),
                ),
                Text(" Welecome to A Plus Foods  ",
                    style: GoogleFonts.robotoCondensed(
                      fontSize: 18,
                    )),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: emailColor, borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Username ',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: passwordColor, borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextField(
                          controller: _passwordController,
                          obscureText: obscurePassword,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Password',
                            suffixIcon: IconButton(
                                onPressed: (() {
                                  setState(() {
                                    obscurePassword = false;
                                  });
                                }),
                                icon: const Icon(Icons.remove_red_eye)),
                          )),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: (() {
                      check().then((value) {
                        setState(() {
                          loading = true;
                        });
                        if (value == null) {
                          throw Exception("Could not log in!");
                        }
                        if (!value.successful) {
                          throw Exception(
                              'Error, wrong credentials ${value.statusVerbose}');
                        }
                        firebase.FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim());
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (buildContext) => const HomeView()));
                      }).catchError((error) {
                        var msg = SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: 'On Snap!',
                            message: error.toString(),
                            contentType: ContentType.failure,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(msg);
                      }).whenComplete(() {
                        setState(() {
                          loading = false;
                        });
                      });
                    }),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 67, 179, 159),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: loading
                              ? spinKit
                              : Text(
                                  'Sign IN ',
                                  style: GoogleFonts.robotoFlex(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Not yet a nember ? ",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: openSignupScreen,
                      child: Text(
                        "Sign Up Now",
                        style: GoogleFonts.robotoMono(
                            color: const Color(0XFF0D47A1),
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    )
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
