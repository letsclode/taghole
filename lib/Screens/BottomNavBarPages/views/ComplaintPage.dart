import 'package:flutter/material.dart';

import '../widgets/cards.dart';

class ComplaintPage extends StatefulWidget {
  const ComplaintPage({super.key});

  @override
  _ComplaintPageState createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "HomePage",
            style: TextStyle(color: Colors.amber),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 200,
                child: Image.asset('assets/HomePage/home.png'),
              ),
            ),
            const Expanded(
              child: Cards(),
            )
          ],
        ),
      ),
    );
  }
}
