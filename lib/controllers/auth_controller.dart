import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
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

  void userVisit() async {
    final user = ref.read(authRepositoryProvider).getCurrentUser();
    if (user == null) {
      await ref.read(authRepositoryProvider).signInAnonymously();
    }
  }

//TODO:
  void appStarted() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else {
      throw Exception('Error');
    }
  }

  void signOut() async {
    await ref.read(authRepositoryProvider).signOut();
  }

  Future signInWithEmailAndPassword(
      {required String email, required String password}) async {
    await ref
        .read(authRepositoryProvider)
        .signInWithEmailAndPassword(email, password);
  }

  Future sendPasswordResetEmail({required String email}) async {
    await ref.read(authRepositoryProvider).sendPasswordResetEmail(email: email);
  }

  Future createUserWithEmailAndPassword(
      {required String email,
      required String name,
      required String password}) async {
    await ref.read(authRepositoryProvider).createUserWithEmailAndPassword(
        email: email, password: password, name: name);
  }
}
