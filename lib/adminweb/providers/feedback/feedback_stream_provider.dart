import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taghole/adminweb/models/feedback/feedback_model.dart';

part 'feedback_stream_provider.g.dart';

@riverpod
Stream<List<FeedbackModel>> feedbacks(FeedbacksRef ref) async* {
  final stream = FirebaseFirestore.instance
      .collection('feedbacks')
      .snapshots()
      .map((querySnapshot) {
    return querySnapshot.docs
        .map((doc) => FeedbackModel.fromJson(doc.data()))
        .toList();
  });

  await for (final event in stream) {
    yield event;
  }
}
