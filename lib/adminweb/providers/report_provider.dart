import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taghole/adminweb/providers/report/report_filter_type_provider.dart';

import '../models/report/report_model.dart';

part 'report_provider.g.dart';

@riverpod
class ReportProvider extends _$ReportProvider {
  Future<List<ReportModel>> _fetchTodo() async {
    final filter = ref.watch(filterReportTypeProvider);
    final json = await FirebaseFirestore.instance.collection('reports').get();
    final reports = json.docs;

    switch (filter) {
      case ReportFilterType.complete:
        return reports
            .map((e) => ReportModel.fromJson(e.data()))
            .where((element) => element.status)
            .toList();
      case ReportFilterType.ongoing:
        return reports
            .map((e) => ReportModel.fromJson(e.data()))
            .where((element) => !element.status)
            .toList();
      case ReportFilterType.all:
        return reports.map((e) => ReportModel.fromJson(e.data())).toList();
    }
  }

  @override
  FutureOr<List<ReportModel>> build() async {
    // Load initial todo list from the remote repository
    return _fetchTodo();
  }

  Future<void> addTodo(ReportModel report) async {
    // Set the state to loading
    // state = const AsyncValue.loading();
    // // Add the new todo and reload the todo list from the remote repository
    // state = await AsyncValue.guard(() async {
    //   await http.post('api/todos', todo.toJson());
    //   return _fetchTodo();
    // });
  }

  // Let's allow removing todos
  Future<void> removeTodo(String todoId) async {
    // state = const AsyncValue.loading();
    // state = await AsyncValue.guard(() async {
    //   await http.delete('api/todos/$todoId');
    //   return _fetchTodo();
    // });
  }

  // Let's mark a todo as completed
  Future<void> updateStatus(
      {required String reportId, required bool value}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await FirebaseFirestore.instance
          .collection('reports')
          .doc(reportId)
          .update({'status': value});
      return _fetchTodo();
    });
  }
}
