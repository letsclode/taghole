import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constant/color.dart';
import '../../StatusAllScreen/views/StatusScreen.dart';

class StatusButton extends StatelessWidget {
  const StatusButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer(
        builder: (context, ref, child) {
          return Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StatusScreen()),
                  );
                },
                child: SizedBox(
                  height: 80,
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 160),
                        height: 80,
                        width: 350,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.red, secondaryColor],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: RichText(
                            text: const TextSpan(
                              text: "Status of all reports",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Image.asset('assets/HomePage/status.png'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
