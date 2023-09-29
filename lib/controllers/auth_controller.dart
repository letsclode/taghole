import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../repositories/auth_repository.dart';

final authControllerProvider = StateNotifierProvider<AuthController, User?>(
  (ref) => AuthController(ref),
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

  Future userVisit() async {
    final user = ref.read(authRepositoryProvider).getCurrentUser();
    if (user == null) {
      await ref.read(authRepositoryProvider).signInAnonymously();
    }
  }

//TODO: try to initialize the visitor auth
  void appStarted() async {}

  void signOut() async {
    await ref.read(authRepositoryProvider).signOut();
  }

  Future<String?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    return await ref
        .read(authRepositoryProvider)
        .signInWithEmailAndPassword(email, password);
  }

  Future sendPasswordResetEmail({required String email}) async {
    await ref.read(authRepositoryProvider).sendPasswordResetEmail(email: email);
  }

  Future<String?> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    return await ref
        .read(authRepositoryProvider)
        .createUserWithEmailAndPassword(email: email, password: password);
  }
}
