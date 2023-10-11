// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:taghole/adminweb/models/report/report_model.dart';

// import '../report_provider.dart';

// @riverpod
// List<ReportModel> completedReports(CompletedReportsRef ref) {
//   final AsyncValue<List<ReportModel>> reports =
//       ref.watch(reportProviderProvider);

//   // we return only the completed todos
//   final data = reports.whenData((value) => value.toList()).value;
//   return data ?? [];
// }
