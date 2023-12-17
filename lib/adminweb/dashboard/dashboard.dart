import 'package:flutter/material.dart';
import 'package:taghole/adminweb/chart/barchart.dart';
import '../../Screens/BottomNavBarPages/views/MapPage.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    debugPrint("Initialize DashBoard");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
             SizedBox(
              height: 300,
              child: Expanded(child: BarChartSample2())
             ),
              SizedBox(
                height: 10,
              ),
              Expanded(child: MapPage())
            ],
          ),
        ),
      ),
    );
  }
}
