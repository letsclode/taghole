import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taghole/adminweb/providers/report/report_filter_type_provider.dart';

import '../models/report/report_model.dart';

part 'report_provider.g.dart';

@riverpod
class ReportProvider extends _$ReportProvider {
  Future<List<ReportModel>> _fetchReports() async {
    print('fetch reports');
    final filter = ref.watch(filterReportTypeProvider);
    final json = await FirebaseFirestore.instance.collection('reports').get();
    final reports = json.docs;

    switch (filter) {
      case ReportFilterType.verified:
        return reports
            .map((e) => ReportModel.fromJson(e.data()))
            .where((element) => element.isVerified)
            .toList();
      case ReportFilterType.unverified:
        return reports
            .map((e) => ReportModel.fromJson(e.data()))
            .where((element) => !element.isVerified)
            .toList();
      case ReportFilterType.complete:
        return reports
            .map((e) => ReportModel.fromJson(e.data()))
            .where((element) => element.status && element.isVerified)
            .toList();
      case ReportFilterType.ongoing:
        return reports
            .map((e) => ReportModel.fromJson(e.data()))
            .where((element) => !element.status && element.isVerified)
            .toList();
      case ReportFilterType.all:
        return reports.map((e) => ReportModel.fromJson(e.data())).toList();
    }
  }

  @override
  FutureOr<List<ReportModel>> build() async {
    // Load initial todo list from the remote repository
    return _fetchReports();
  }

  Future<List<ReportModel>> getVisibleReports() async {
    return _fetchReports();
  }

  Future<void> updateStatus(
      {required String reportId, required bool value}) async {
    print('reportid');
    print(reportId);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await FirebaseFirestore.instance
          .collection('reports')
          .doc(reportId)
          .update({'status': value});
      return _fetchReports();
    });
  }

  Future<void> verifyReport(bool isVisible, String uid) async {
    Map<Object, Object?> newData = {'isVerified': isVisible};
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      FirebaseFirestore.instance
          .collection('reports')
          .doc(uid)
          .update(newData)
          .then((value) => isVisible);
      return _fetchReports();
    });
  }

  Future<void> deleteReport(String uid) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await FirebaseFirestore.instance.collection('reports').doc(uid).delete();
      return _fetchReports();
    });
  }
}
