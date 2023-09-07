import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class Provider extends InheritedWidget {
  final AuthService auth;
  Provider({Key? key, Widget? child, required this.auth})
      : super(key: key, child: child!);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static Provider of(BuildContext context) =>
      (context.getInheritedWidgetOfExactType()!);
  //  static Provider of(BuildContext context) => (context.dependOnInheritedWidgetOfExactType(aspect: Provider));
}
