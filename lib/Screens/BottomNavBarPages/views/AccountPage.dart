import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/constant/color.dart';

import '../../../controllers/auth_controller.dart';

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = ref.watch(authControllerProvider.notifier);
    final user = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Account",
          style: TextStyle(color: secondaryColor),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Image.asset('assets/Account/account.png'),
            const SizedBox(height: 100.0),
            Center(
              child: MaterialButton(
                color: secondaryColor,
                onPressed: () async {
                  try {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Signing Out"),
                            content: SizedBox(
                              height: MediaQuery.of(context).size.height / 6,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                      'Are you sure you want to logout?'),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel")),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Consumer(
                                        builder: (context, ref, child) {
                                          return MaterialButton(
                                            color: secondaryColor,
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              await authProvider.signOut();
                                            },
                                            child: const Text(
                                              "Logout",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  } catch (e) {
                    print(e);
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                    Text(
                      'Logout',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
