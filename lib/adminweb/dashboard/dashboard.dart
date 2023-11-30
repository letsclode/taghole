import 'package:flutter/material.dart';

import '../../Screens/BottomNavBarPages/views/MapPage.dart';
import 'widgets/myfile.dart';

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
    return const SafeArea(
      child: Expanded(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              MyFiles(),
              SizedBox(
                height: 10,
              ),
              Expanded(child: SizedBox(height: 300, child: MapPage()))
            ],
          ),
        ),
      ),
    );
  }
}
