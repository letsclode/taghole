import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/adminweb/reports/table.dart';
import 'package:taghole/responsive.dart';

import '../providers/report/report_provider.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  final int pageIndex;
  final String title;
  const ReportsScreen(
      {super.key, required this.pageIndex, required this.title});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    final reportProvider = ref.watch(reportProviderProvider);
    return switch (reportProvider) {
      AsyncData(:final value) => Responsive.isMobile(context)
          ? Expanded(
              child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(value[index].address),
                          trailing: MaterialButton(
                            color: value[index].isVerified
                                ? value[index].status == 'completed'
                                    ? Colors.green
                                    : Colors.orange
                                : Colors.grey,
                            onPressed: () {
                              // Add button press logic here
                              ref
                                  .watch(reportProviderProvider.notifier)
                                  .showReportDetails(
                                      context: context, row: value[index]);
                            },
                            child: const Text(
                              'Details',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ))
          : TableScreen(
              title: widget.title,
              headers: const ['Status', 'Type', 'Address', 'Actions'],
              data: value,
            ),
      AsyncError(:final error) => Text('Error: $error'),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
