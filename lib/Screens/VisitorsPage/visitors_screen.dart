import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VisitorsScreen extends ConsumerStatefulWidget {
  const VisitorsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VisitorsScreenState();
}

class _VisitorsScreenState extends ConsumerState<VisitorsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text("Visitors"),
      ),
    );
  }
}
