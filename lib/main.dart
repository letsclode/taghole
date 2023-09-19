import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/Screens/VisitorsPage/visitors_screen.dart';
import 'package:taghole/firebase_options.dart';

import 'Screens/Authentication/Auth.dart';
import 'Screens/Authentication/views/citizenSignup.dart';
import 'Screens/Authentication/views/home.dart';
import 'Screens/Authentication/views/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  return runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taghole',
      home: const WelcomeScreen(),
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) =>
            Signup(authFormType: AuthFormType.signup),
        '/signin': (BuildContext context) =>
            Signup(authFormType: AuthFormType.signin),
        '/home': (BuildContext context) => const Home(),
        '/citizenSignup': (BuildContext context) =>
            CitizenSignup(authFormType: AuthForm.signup),
        '/anonymousSignIn': (BuildContext context) => const VisitorsScreen(),
      },
    );
  }
}
