import 'package:flutter/material.dart';

import '../../BottomNavBarPages/views/AccountPage.dart';
import '../../BottomNavBarPages/views/ComplaintPage.dart';
import '../../BottomNavBarPages/views/MapPage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _children = [ComplaintPage(), MapPage(), AccountPage()];

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
              activeIcon: new Tab(
                icon: new Image.asset(
                  "assets/Navbar/home.png",
                  height: 32,
                ),
              ),
              icon: new Tab(
                icon: new Image.asset(
                  "assets/Navbar/home.png",
                  height: 22,
                ),
              ),
              label: 'Home'),
          BottomNavigationBarItem(
            activeIcon: new Tab(
              icon: new Image.asset(
                "assets/Navbar/map.png",
                height: 32,
              ),
            ),
            icon: new Tab(
              icon: new Image.asset(
                "assets/Navbar/map.png",
                height: 22,
              ),
            ),
            label: 'Map',
          ),
          BottomNavigationBarItem(
              activeIcon: new Tab(
                icon: new Image.asset(
                  "assets/Navbar/user.png",
                  height: 32,
                ),
              ),
              icon: new Tab(
                icon: new Image.asset(
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
