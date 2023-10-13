import 'package:hooks_riverpod/hooks_riverpod.dart';

final filterReportTypeProvider = StateProvider<ReportFilterType>(
  // We return the default sort type, here name.
  (ref) => ReportFilterType.visible,
);

enum ReportFilterType { ongoing, complete, all, visible }
