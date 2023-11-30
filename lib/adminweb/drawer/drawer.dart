import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/adminweb/drawer/drawer_index_provider.dart';
import 'package:taghole/adminweb/providers/report/report_filter_type_provider.dart';
import 'package:taghole/constant/color.dart';
import 'package:taghole/responsive.dart';

import '../../controllers/auth_controller.dart';
import '../constants.dart';

class KDrawer extends ConsumerStatefulWidget {
  const KDrawer({super.key});

  @override
  ConsumerState<KDrawer> createState() => _KDrawerState();
}

class _KDrawerState extends ConsumerState<KDrawer> {
  void onTabTapped(int index) {
    ref.read(drawerIndexProvider.notifier).state = index;
    if (index == 0) {
      ref.read(filterReportTypeProvider.notifier).state = ReportFilterType.all;
    }
    if (index == 1) {
      ref.read(filterReportTypeProvider.notifier).state =
          ReportFilterType.unverified;
    }
    if (index == 2) {
      ref.read(filterReportTypeProvider.notifier).state =
          ReportFilterType.ongoing;
    }
    if (index == 3) {
      ref.read(filterReportTypeProvider.notifier).state =
          ReportFilterType.complete;
    }
    if (Responsive.isMobile(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = ref.watch(authControllerProvider.notifier);
    final currentIndex = ref.watch(drawerIndexProvider);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Taghole',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            selected: currentIndex == 0,
            selectedTileColor: Colors.grey[100],
            leading: const Icon(Icons.home),
            title: const Text('Dashboard'),
            onTap: () {
              onTabTapped(0);
            },
          ),
          ListTile(
            selected: currentIndex == 1,
            selectedTileColor: Colors.grey[100],
            leading: const Icon(Icons.assignment),
            title: const Text(KString.reportsTitle),
            onTap: () {
              onTabTapped(1);
            },
          ),
          ListTile(
            selected: currentIndex == 2,
            selectedTileColor: Colors.grey[100],
            leading: const Icon(Icons.assignment),
            title: const Text(KString.reportsOngoingTitle),
            onTap: () {
              onTabTapped(2);
            },
          ),
          ListTile(
            selected: currentIndex == 3,
            selectedTileColor: Colors.grey[100],
            leading: const Icon(Icons.assignment),
            title: const Text(KString.reportsCompletedTitle),
            onTap: () {
              onTabTapped(3);
            },
          ),
          ListTile(
            selected: currentIndex == 4,
            selectedTileColor: Colors.grey[100],
            leading: const Icon(Icons.feedback),
            title: const Text('Feedbacks'),
            onTap: () {
              onTabTapped(4);
            },
          ),
          ListTile(
            selected: currentIndex == 5,
            selectedTileColor: Colors.grey[100],
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              onTabTapped(5);
            },
          ),
          ListTile(
            selected: currentIndex == 6,
            selectedTileColor: Colors.grey[100],
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              // Handle logout option
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Your going to log out!"),
                      content: SizedBox(
                        height: MediaQuery.of(context).size.height / 15,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MaterialButton(
                                  color: secondaryColor,
                                  onPressed: () async {
                                    print('signout');
                                    try {
                                      Navigator.pop(context);
                                      await authProvider.signOut();
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  child: const Text(
                                    "Confirm",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel"))
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}
