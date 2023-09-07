import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../widgets/customDialog.dart';

class First extends StatelessWidget {
  final primaryColor = const Color(0xFFffbf00);

  const First({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        color: primaryColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const Text(
                    "Welcome",
                    style: TextStyle(fontSize: 44, color: Colors.white),
                  ),
                  Image.asset(
                    'assets/Auth/auth.png',
                    height: height * 0.40,
                  ),
                  const AutoSizeText(
                    "Let’s start scouting potholes",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                  MaterialButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, bottom: 10.0, left: 30.0, right: 30.0),
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => const CustomDialog(
                          title: "Would you like to create a free account?",
                          description:
                              "With an account, your scouting will be rewarded and allow you to access from multiple devices.",
                          primaryButtonText: "Register",
                          primaryButtonRoute: "/citizenSignup",
                          secondaryButtonText: "Skip",
                          secondaryButtonRoute: "/anonymousSignIn",
                        ),
                      );
                    },
                  ),
                  const Divider(
                    thickness: 0.8,
                    color: Colors.white,
                  ),
                  MaterialButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, bottom: 10.0, left: 30.0, right: 30.0),
                      child: Text(
                        "Admin Auth",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/signin');
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
