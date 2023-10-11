import 'package:hooks_riverpod/hooks_riverpod.dart';

final drawerIndexProvider = StateProvider<int>(
  // We return the default sort type, here name.
  (ref) => 0,
);
