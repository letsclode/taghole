import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/adminweb/homePage.dart';

import '../Screens/Authentication/views/signup.dart';
import '../controllers/auth_controller.dart';
import '../firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: WebApp()));
}

class WebApp extends ConsumerWidget {
  const WebApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider);
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => user == null
            ? Signup(authFormType: AuthFormType.signin)
            : const HomePage(),
        '/signin': (BuildContext context) =>
            Signup(authFormType: AuthFormType.signin),
      },
    );
  }
}
