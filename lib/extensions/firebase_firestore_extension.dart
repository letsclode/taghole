import 'package:cloud_firestore/cloud_firestore.dart';

extension FirebaseFirestoreX on FirebaseFirestore {
  DocumentReference users(String userId) => collection('users').doc(userId);
}
