import 'package:flutter/material.dart';
import 'package:taghole/adminweb/chart/barchart.dart';
import 'package:taghole/responsive.dart';

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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Responsive(
                mobile: Column(
                  children: [
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Rejected reports"),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              color: Colors.yellow,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Ongoing reports"),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Completed reports"),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Pending reports")
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: const BarChartSample2()),
                  ],
                ),
                desktop: Row(
                  children: [
                    SizedBox(
                        height: 300,
                        width: MediaQuery.of(context).size.width - 500,
                        child: const BarChartSample2()),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Rejected reports"),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              color: Colors.yellow,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Ongoing reports"),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Completed reports"),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Pending reports")
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Expanded(child: MapPage())
            ],
          ),
        ),
      ),
    );
  }
}
