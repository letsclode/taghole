import 'package:flutter/material.dart';
import 'package:taghole/constant/color.dart';

import '../widgets/Faqlist.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: secondaryColor,
        ),
        title: const Text(
          "Frequently Asked Questions",
          style: TextStyle(color: secondaryColor),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: const Faqlist(),
    );
  }
}
