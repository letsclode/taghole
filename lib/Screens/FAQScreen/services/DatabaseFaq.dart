import 'package:cloud_firestore/cloud_firestore.dart';

getFaqList() async {
  return await FirebaseFirestore.instance.collection('FAQ').get();
}
