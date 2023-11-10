import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taghole/adminweb/models/report/report_model.dart';

part 'report_stream_provider.g.dart';

@riverpod
Stream<List<ReportModel>> reports(ReportsRef ref) async* {
  try {
    print('streaming reports');
    final stream = FirebaseFirestore.instance
        .collection('reports')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => ReportModel.fromJson(doc.data()))
          .toList();
    });

    await for (final event in stream) {
      yield event;
    }
  } catch (e) {
    print(e);
  }
}
