import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/adminweb/drawer/drawer.dart';
import 'package:taghole/adminweb/feedbacks/feedback_screen.dart';
import 'package:taghole/adminweb/reports/reports_screen.dart';
import 'package:taghole/adminweb/settings/settings_screen.dart';
import 'package:taghole/responsive.dart';

import 'constants.dart';
import 'dashboard/dashboard.dart';
import 'drawer/drawer_index_provider.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final pages = [
    const DashboardScreen(),
    const ReportsScreen(
      pageIndex: 1,
      title: KString.reportsTitle,
    ),
    const ReportsScreen(pageIndex: 2, title: KString.reportsOngoingTitle),
    const ReportsScreen(pageIndex: 3, title: KString.reportsCompletedTitle),
    const ReportsScreen(pageIndex: 4, title: KString.reportsRejectedTitle),
    const FeedbackScreen(),
    const SettingsScreen()
  ];
  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(drawerIndexProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text([
          'Dashboard',
          'Latest Reports',
          'Ongoing Reports',
          'Completed Reports',
          'Rejected Reports',
          'Feedbacks',
          'Settings'
        ][currentIndex]),
        automaticallyImplyLeading: Responsive.isDesktop(context) ? false : true,
      ),
      drawer: const KDrawer(),
      body: Row(
        children: [
          Visibility(
              visible: Responsive.isDesktop(context),
              child: const Expanded(child: KDrawer())),
          Expanded(flex: 4, child: pages[currentIndex])
        ],
      ),
    );
  }
}
