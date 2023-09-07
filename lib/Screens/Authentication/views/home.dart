import 'package:flutter/material.dart';

import '../../BottomNavBarPages/views/AccountPage.dart';
import '../../BottomNavBarPages/views/ComplaintPage.dart';
import '../../BottomNavBarPages/views/MapPage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    ComplaintPage(),
    MapPage(),
    const AccountPage()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              activeIcon: Tab(
                icon: Image.asset(
                  "assets/Navbar/home.png",
                  height: 32,
                ),
              ),
              icon: Tab(
                icon: Image.asset(
                  "assets/Navbar/home.png",
                  height: 22,
                ),
              ),
              label: 'Home'),
          BottomNavigationBarItem(
            activeIcon: Tab(
              icon: Image.asset(
                "assets/Navbar/map.png",
                height: 32,
              ),
            ),
            icon: Tab(
              icon: Image.asset(
                "assets/Navbar/map.png",
                height: 22,
              ),
            ),
            label: 'Map',
          ),
          BottomNavigationBarItem(
              activeIcon: Tab(
                icon: Image.asset(
                  "assets/Navbar/user.png",
                  height: 32,
                ),
              ),
              icon: Tab(
                icon: Image.asset(
                  "assets/Navbar/user.png",
                  height: 22,
                ),
              ),
              label: 'Account')
        ],
      ),
    );
  }
}
