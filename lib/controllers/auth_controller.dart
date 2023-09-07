import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../repositories/auth_repository.dart';

final authControllerProvider = StateNotifierProvider<AuthController, User?>(
  (ref) => AuthController(ref)..appStarted(),
);

class AuthController extends StateNotifier<User?> {
  final Ref ref;

  StreamSubscription<User?>? _authStateChangesSubscription;

  AuthController(this.ref) : super(null) {
    _authStateChangesSubscription?.cancel();
    _authStateChangesSubscription = ref
        .read(authRepositoryProvider)
        .authStateChanges
        .listen((user) => state = user);
  }

  @override
  void dispose() {
    _authStateChangesSubscription?.cancel();
    super.dispose();
  }

  void appStarted() async {
    final user = ref.read(authRepositoryProvider).getCurrentUser();
    if (user == null) {
      await ref.read(authRepositoryProvider).signInAnonymously();
    }
  }

  void signOut() async {
    await ref.read(authRepositoryProvider).signOut();
  }
}
