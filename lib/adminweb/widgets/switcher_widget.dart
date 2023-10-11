import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/report/report_model.dart';

class Switcher extends StatefulWidget {
  const Switcher({super.key, required this.data, required this.uid});
  final ReportModel data;
  final String uid;

  @override
  State<Switcher> createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {
  final _firestore = FirebaseFirestore.instance;

  Future<bool> updateReport(bool isValidate, String uid) async {
    Map<Object, Object?> newData = {'isValidate': isValidate};
    final data = await _firestore
        .collection('reports')
        .doc(uid)
        .update(newData)
        .then((value) => isValidate);
    return data;
  }

  bool isValidate = false;
  late String uid;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      isValidate = widget.data.status;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: updateReport(
          isValidate, widget.uid), // This is the Future you want to listen to
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return Switch(
            value: snapshot.data ?? false,
            onChanged: (value) {
              setState(() {
                isValidate = value;
              });
            });
      },
    );
  }
}
