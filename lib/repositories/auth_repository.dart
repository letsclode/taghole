import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../general_providers.dart';
import 'custom_exception.dart';

abstract class BaseAuthRepository {
  Stream<User?> get authStateChanges;
  Future<void> signInAnonymously();
  User? getCurrentUser();
  Future<void> signOut();
  Future<void> sendPasswordResetEmail({required String email});
  Future<void> upgradeUserAccount(String email, String password);
  Future<String?> signInWithEmailAndPassword(String email, String password);
  Future<String?> createUserWithEmailAndPassword(
      {required String email, required String password});
}

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository(ref));

class AuthRepository implements BaseAuthRepository {
  final Ref ref;

  const AuthRepository(this.ref);

  @override
  Stream<User?> get authStateChanges =>
      ref.read(firebaseAuthProvider).authStateChanges();

  @override
  Future<void> signInAnonymously() async {
    try {
      await ref.read(firebaseAuthProvider).signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  User? getCurrentUser() {
    try {
      return ref.read(firebaseAuthProvider).currentUser;
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await ref.read(firebaseAuthProvider).signOut();
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<String?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final authResult = await ref
        .read(firebaseAuthProvider)
        .createUserWithEmailAndPassword(email: email, password: password);
    // await updateUserName(authResult.user!, name);
    return authResult.user!.uid;
  }

  @override
  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    return (await ref
            .read(firebaseAuthProvider)
            .signInWithEmailAndPassword(email: email, password: password))
        .user!
        .uid;
  }

  @override
  Future sendPasswordResetEmail({required String email}) async {
    return await ref
        .read(firebaseAuthProvider)
        .sendPasswordResetEmail(email: email);
  }

  @override
  Future upgradeUserAccount(String email, String password) async {
    AuthCredential? credential =
        EmailAuthProvider.credential(email: email, password: password);
    await ref
        .read(firebaseAuthProvider)
        .currentUser!
        .linkWithCredential(credential); //TODO: create account in firestore
  }
}
