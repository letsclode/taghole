import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                onTabTapped(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Receive Reports'),
              onTap: () {
                onTabTapped(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Ongoing'),
              onTap: () {
                // Handle ongoing option
              },
            ),
            ListTile(
              leading: const Icon(Icons.check),
              title: const Text('Completed'),
              onTap: () {
                // Handle completed option
              },
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.comment),
              title: const Text('User Feedback'),
              onTap: () {
                // Handle user feedback option
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Handle settings option
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                // Handle logout option
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: const Center(
          child: Text("homepage"),
        ),
      ),
    );
  }
}
