import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DetailsPage extends ConsumerWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        child: const Center(
          child: Text("Details Page"),
        ),
      ),
    );
  }
}
