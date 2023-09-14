import 'package:flutter/material.dart';

import '../../FAQScreen/views/FAQScreen.dart';
import '../../HomeMenuPages/views/SelectionPage.dart';
import '../../StatusAllScreen/views/StatusScreen.dart';

class Cards extends StatefulWidget {
  const Cards({super.key});

  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SelectionPage()),
              );
            },
            child: SizedBox(
              height: 120,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 160),
                    height: 120,
                    width: 350,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.amber[200]!, Colors.amber],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: RichText(
                        text: const TextSpan(
                          text: "Report New Complaint",
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
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatusScreen()),
              );
            },
            child: SizedBox(
              height: 120,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 160),
                    height: 120,
                    width: 350,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.amber[200]!, Colors.amber],
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
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FAQScreen()),
              );
            },
            child: SizedBox(
              height: 120,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 160),
                    height: 120,
                    width: 350,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.amber[200]!, Colors.amber],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: RichText(
                        text: const TextSpan(
                          text: "FAQ",
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
                    child: Image.asset('assets/HomePage/FAQ.png'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
