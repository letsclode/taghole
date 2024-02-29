import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/controllers/page/page_controller.dart';

import '../../BottomNavBarPages/views/AccountPage.dart';
import '../../BottomNavBarPages/views/ComplaintPage.dart';
import '../../BottomNavBarPages/views/MapPage.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final List<Widget> _children = [
    const ComplaintPage(),
    const MapPage(),
    const AccountPage()
  ];

  void onTabTapped(int index) {
    final pageController = ref.read(pageIndexProvider.notifier);
    setState(() {
      pageController.setPage(newValue: index);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(pageIndexProvider);
    return Scaffold(
      body: _children[index],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: index,
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
