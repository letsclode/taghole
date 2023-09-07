import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

//TODO : convert to river pod
class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // To check if the user is logged in or not - Checking the state
  Stream<String> get onAuthStateChanged => _firebaseAuth.authStateChanges().map(
        (User? user) => user!.uid,
      );

  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    await updateUserName(authResult.user!, name);
    return authResult.user!.uid;
  }

  Future updateUserName(User user, String name) async {
    await user.updateDisplayName(name);
    await user.reload();
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user!
        .uid;
  }

  signOut() {
    return _firebaseAuth.signOut();
  }

  Future sendPasswordResetEmail(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}

class UserManagement {
  storeNewUser(String email, String uid, String role, context) {
    FirebaseFirestore.instance.collection('users').add({
      'email': email,
      'uid': uid,
      'role': role,
    }).catchError((e) {
      print(e);
    });
  }
}

Future<int?> authorizeAccess(BuildContext context) async {
  dynamic user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: user!.uid)
        .get()
        .then((docs) {
      if (docs.docs[0].exists) {
        if (docs.docs[0]['role'] == 'municipal') {
          return 0;
        } else {
          return 1;
        }
      }
    });
  }
  return null;
}

class EmailValidator {
  static String? validate(String? value) {
    if (value == null) {
      return 'Email can\'t be empty';
    }
    return null;
  }
}

class PasswordValidator {
  static String? validate(String? value) {
    if (value == null) {
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
