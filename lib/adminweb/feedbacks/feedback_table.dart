import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/adminweb/models/feedback/feedback_model.dart';
import 'package:taghole/adminweb/providers/feedback/feedback_provider.dart';

class FeedbackTable extends ConsumerStatefulWidget {
  final String title;

  final List<String> headers;
  final List<FeedbackModel> data;

  const FeedbackTable(
      {super.key,
      required this.title,
      required this.headers,
      required this.data});

  @override
  ConsumerState<FeedbackTable> createState() => _FeedbackTableState();
}

class _FeedbackTableState extends ConsumerState<FeedbackTable> {
  @override
  Widget build(BuildContext context) {
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
      ),
      rowsPerPage: 10, // Adjust the number of rows per page
    );
  }
}

class MyDataTableSource extends DataTableSource {
  final List<FeedbackModel> data;
  final BuildContext context;
  MyDataTableSource({required this.data, required this.context});

  @override
  DataRow getRow(int index) {
    final FeedbackModel row = data[index];

    return DataRow(cells: [
      DataCell(Text(row.reportId)),
      DataCell(Text(row.userId)),
      DataCell(Text(row.description)),
      DataCell(Text(row.ratings.toString())),
      DataCell(Row(
        children: [
          Consumer(builder: (context, ref, child) {
            final feedbackProvider =
                ref.read(feedbackContollerProvider.notifier);
            return MaterialButton(
              onPressed: () async {
                await feedbackProvider.deleteFeedback(row.id);
              },
              child: const Row(
                children: [
                  Icon(Icons.delete),
                  Text('Delete'),
                ],
              ),
            );
          }),
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
