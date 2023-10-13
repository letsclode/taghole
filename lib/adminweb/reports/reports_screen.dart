import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/adminweb/constants.dart';
import 'package:taghole/adminweb/providers/report_provider.dart';
import 'package:taghole/adminweb/reports/table.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    final reportProvider = ref.watch(reportProviderProvider);
    return switch (reportProvider) {
      AsyncData(:final value) => TableScreen(
          title: KString.reportsTitle,
          headers: const ['Status', 'Type', 'Address', 'Controls'],
          data: value,
        ),
      AsyncError(:final error) => Text('Error: $error'),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
