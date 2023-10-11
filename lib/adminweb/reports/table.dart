import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/adminweb/providers/report/report_filter_type_provider.dart';

import '../../controllers/user_controller.dart';
import '../models/report/report_model.dart';
import '../widgets/switcher_widget.dart';

class TableScreen extends ConsumerStatefulWidget {
  final String title;
  final List<String> headers;
  final List<ReportModel> data;

  const TableScreen(
      {super.key,
      required this.title,
      required this.headers,
      required this.data});

  @override
  ConsumerState<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends ConsumerState<TableScreen> {
  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      header: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title),
          Row(
            children: [
              const Icon(Icons.filter_alt),
              DropdownButton<ReportFilterType>(
                value: ref.watch(filterReportTypeProvider),
                onChanged: (value) =>
                    ref.read(filterReportTypeProvider.notifier).state = value!,
                items: ReportFilterType.values.map((type) {
                  return DropdownMenuItem<ReportFilterType>(
                    value: type,
                    child: Text(type.name.toString()),
                  );
                }).toList(),
              ),
            ],
          )
        ],
      ),
      columns: widget.headers
          .map((value) => DataColumn(
                  label: Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )))
          .toList(),
      source: MyDataTableSource(data: widget.data),
      rowsPerPage: 10, // Adjust the number of rows per page
    );
  }
}

class MyDataTableSource extends DataTableSource {
  final List<ReportModel> data;
  MyDataTableSource({required this.data});

  @override
  DataRow getRow(int index) {
    final ReportModel row = data[index];
    final id = data[index].id;
    return DataRow(cells: [
      DataCell(row.status
          ? const Text(
              'complete',
              style: TextStyle(color: Colors.green),
            )
          : const Text(
              'ongoing',
              style: TextStyle(color: Colors.orange),
            )),
      DataCell(Text(row.type)),
      DataCell(Text(row.address)),
      DataCell(Row(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final userProvider = ref.watch(userControllerProvider.notifier);
              return IconButton(
                  onPressed: () async {
                    await userProvider.deleteReport(id);
                  },
                  icon: const Icon(Icons.delete));
            },
          ),
          Switcher(data: row, uid: id),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
