import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:taghole/constant/color.dart';

import '../widgets/customDialog.dart';

class First extends StatelessWidget {
  const First({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox(
        width: width,
        height: height,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: height / 3,
                  child: Image.asset(
                    'assets/images/map.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const AutoSizeText(
                        "Tag a pothole",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: height * 0.03),
                      const AutoSizeText(
                        "Upload a picture and send your location for a pothole you encountered.",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: grayColor),
                      ),
                      SizedBox(height: height * 0.05),
                      MaterialButton(
                        height: 45,
                        minWidth: width,
                        color: secondaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: const Padding(
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 30.0, right: 30.0),
                          child: Text(
                            "Get Started",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                const CustomDialog(
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
                        color: secondaryColor,
                      ),
                      MaterialButton(
                        color: secondaryColor,
                        height: 45,
                        minWidth: width,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: const Padding(
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 30.0, right: 30.0),
                          child: Text(
                            "Login as Admin",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/signin');
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
