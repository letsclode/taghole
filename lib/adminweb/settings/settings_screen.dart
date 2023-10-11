import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/adminweb/settings/update_password_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width / 2,
            height: 400,
            child: const UpdatePasswordForm(),
          ),
        )
      ],
    );
  }
}
