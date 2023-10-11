import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/adminweb/drawer/drawer.dart';
import 'package:taghole/adminweb/home/home_screen.dart';
import 'package:taghole/adminweb/reports/reports_screen.dart';
import 'package:taghole/adminweb/settings/settings_screen.dart';
import 'package:taghole/responsive.dart';

import 'drawer/drawer_index_provider.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final pages = [
    const HomeScreen(),
    const ReportsScreen(),
    const SettingsScreen()
  ];
  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(drawerIndexProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: Responsive.isDesktop(context) ? false : true,
      ),
      drawer: const KDrawer(),
      body: Container(
        child: Row(
          children: [
            Visibility(
                visible: Responsive.isDesktop(context),
                child: const Expanded(child: KDrawer())),
            Expanded(flex: 4, child: pages[currentIndex])
          ],
        ),
      ),
    );
  }
}
