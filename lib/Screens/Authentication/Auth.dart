import 'views/home.dart';
import 'views/first.dart';
import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/Screens/VisitorsPage/visitors_screen.dart';

class WelcomeScreen extends HookConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider);
    return user != null
        ? user.isAnonymous
            ? const VisitorsScreen()
            : const Home()
        : const First();
  }
}
