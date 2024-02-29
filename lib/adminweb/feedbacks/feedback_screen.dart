import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/adminweb/feedbacks/feedback_table.dart';
import 'package:taghole/adminweb/providers/feedback/feedback_stream_provider.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    final feedbackProvider = ref.watch(feedbacksProvider);
    return switch (feedbackProvider) {
      AsyncData(:final value) => FeedbackTable(
          title: 'Feedbacks',
          headers: const [
            'Report ID',
            'User ID',
            'Description',
            'Rating',
          ],
          data: value,
        ),
      AsyncError(:final error) => Text('Error: $error'),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
