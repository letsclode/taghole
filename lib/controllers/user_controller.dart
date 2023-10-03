import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../repositories/auth_repository.dart';

final userControllerProvider = StateNotifierProvider<UserController, User?>(
  (ref) => UserController(ref),
);

class UserController extends StateNotifier<User?> {
  final Ref ref;

  UserController(this.ref) : super(null);

  void appStarted() async {
    final user = ref.read(authRepositoryProvider).getCurrentUser();
    if (user == null) {
      await ref.read(authRepositoryProvider).signInAnonymously();
    }
  }

  Future updateUserName(User user, String name) async {
    await user.updateDisplayName(name);
    await user.reload();
  }

//TODO: finish this
  Future storeNewUser(
      {String? name,
      String? email,
      required String uid,
      required String role}) async {
    FirebaseFirestore.instance.collection('users').add({
      'name': name ?? '',
      'email': email ?? '',
      'uid': uid,
      'role': role,
    }).catchError((e) {
      print(e);
    });
  }

//TODO: finish this
  Future<bool> isAdmin() async {
    User? user = FirebaseAuth.instance.currentUser;
    print("USER");
    print(user);
    if (user != null) {
      final docs = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user.uid)
          .get();
      if (docs.docs[0].exists) {
        print(docs.docs[0]['role'] == 'admin');
        return docs.docs[0]['role'] == 'admin';
      }
    }

    return false;
  }
}

class EmailValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email can\'t be empty';
    }
    return null;
  }
}

class PasswordValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password can\'t be empty';
    }
    return null;
  }
}

class NameValidator {
  static String? validate(String? value) {
    if (value != null) {
      if (value.length < 4) {
        return 'Name must be at least 4 characters long';
      }
      if (value.length > 30) {
        return 'Name must maximum 30 characters long';
      }
    } else {
      return 'Name can\'t be empty';
    }

    return null;
  }
}
