import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/adminweb/providers/report/report_provider.dart';
import 'package:taghole/controllers/user_controller.dart';
import 'package:taghole/extensions/utils.dart';

import '../models/report/report_model.dart';

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
    final userService = ref.watch(userControllerProvider.notifier);
    final reportProvider = ref.read(reportProviderProvider.notifier);
    return PaginatedDataTable(
      onPageChanged: (value) {},
      header: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title),
        ],
      ),
      columns: widget.headers
          .map((value) => DataColumn(
                  label: Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )))
          .toList(),
      source: MyDataTableSource(
          context: context,
          data: widget.data,
          reportProvider: reportProvider,
          userController: userService),
      rowsPerPage: 10, // Adjust the number of rows per page
    );
  }
}

class MyDataTableSource extends DataTableSource {
  final List<ReportModel> data;
  final BuildContext context;
  final ReportProvider reportProvider;
  final UserController userController;
  MyDataTableSource({
    required this.data,
    required this.context,
    required this.reportProvider,
    required this.userController,
  });

  @override
  DataRow getRow(int index) {
    final ReportModel row = data[index];
    return DataRow(cells: [
      DataCell(FutureBuilder(
          future: userController.getUserById(id: row.userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator.adaptive();
            }
            return Text(snapshot.data == null
                ? ""
                : snapshot.data!.firstName != null
                    ? "${snapshot.data!.firstName!} ${snapshot.data!.lastName!}"
                    : snapshot.data!.email!);
          })),
      DataCell(Text(row.title)),
      DataCell(!row.isVerified
          ? row.status == 'pending'
              ? const Text(
                  'Unverified',
                  style: TextStyle(color: Colors.grey),
                )
              : const Text(
                  'Rejected',
                  style: TextStyle(color: Colors.red),
                )
          : row.status == 'completed'
              ? const Text(
                  'Completed',
                  style: TextStyle(color: Colors.green),
                )
              : const Text(
                  'Ongoing',
                  style: TextStyle(color: Colors.orange),
                )),
      DataCell(Text(row.type)),
      DataCell(Text(row.address)),
      DataCell(Text(formatDate(row.createdAt))),
      DataCell(Row(
        children: [
          OutlinedButton(
              onPressed: () {
                reportProvider.showReportDetails(context: context, row: row);
              },
              child: const Text("Details")),
          const SizedBox(
            width: 10,
          ),
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
