import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/adminweb/signup.dart';

import '../../controllers/auth_controller.dart';
import 'mainScreen.dart';

class WebWelcomeScreen extends HookConsumerWidget {
  const WebWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider);
    print(user);
    return user == null
        ? Signup(authFormType: AuthFormType.signin)
        : const MainScreen();
  }
}
