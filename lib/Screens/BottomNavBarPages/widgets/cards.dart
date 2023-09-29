import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/Screens/BottomNavBarPages/widgets/status_button.dart';
import 'package:taghole/Screens/HomeMenuPages/views/ComplaintForm.dart';
import 'package:taghole/constant/color.dart';

class Cards extends ConsumerStatefulWidget {
  const Cards({super.key});

  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends ConsumerState<Cards> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ComplaintForm()),
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
                          text: "Tag a pothole",
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
                    child: Image.asset('assets/HomePage/report.png'),
                  ),
                ],
              ),
            ),
          ),
          // const SizedBox(
          //   height: 20,
          // ),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const FAQScreen()),
          //     );
          //   },
          //   child: SizedBox(
          //     height: 80,
          //     child: Stack(
          //       alignment: Alignment.bottomLeft,
          //       children: [
          //         Container(
          //           padding: const EdgeInsets.only(left: 160),
          //           height: 80,
          //           width: 350,
          //           decoration: BoxDecoration(
          //             gradient: const LinearGradient(
          //               colors: [Colors.red, secondaryColor],
          //             ),
          //             borderRadius: BorderRadius.circular(20),
          //           ),
          //           child: Center(
          //             child: RichText(
          //               text: const TextSpan(
          //                 text: "FAQ",
          //                 style: TextStyle(
          //                     color: Colors.white,
          //                     fontWeight: FontWeight.bold,
          //                     fontSize: 17.0),
          //               ),
          //             ),
          //           ),
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 15),
          //           child: Image.asset('assets/HomePage/FAQ.png'),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          const StatusButton(),
        ],
      ),
    );
  }
}
