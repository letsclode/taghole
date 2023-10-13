import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/constant/color.dart';
import 'package:taghole/controllers/auth_controller.dart';

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
          child: Column(
            children: <Widget>[
              SizedBox(
                height: height / 3,
                child: Image.asset(
                  'assets/images/taghole.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const AutoSizeText(
                      "Welcome to Taghole",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: height * 0.03),
                    const AutoSizeText(
                      "You now have the option to engage in exploration or assume the role of a responsible citizen to utilize our pothole tagging application for reporting road deficiencies within the city.",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: grayColor),
                    ),
                    SizedBox(height: height * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Consumer(
                          builder: (context, ref, child) {
                            final authProvider =
                                ref.watch(authControllerProvider.notifier);
                            return OutlinedButton(
                              child: const Text('Skip'),
                              onPressed: () async {
                                await authProvider.userVisit();
                              },
                            );
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/citizenSignup');
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: height * 0.05),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
