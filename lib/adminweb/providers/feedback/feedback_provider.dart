import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/adminweb/models/feedback/feedback_model.dart';

class FeedbackNotifier extends StateNotifier<List<FeedbackModel>> {
  // We initialize the list of todos to an empty list
  FeedbackNotifier() : super([]);

  // Let's allow the UI to add todos.
  Future<void> addFeedback(FeedbackModel feedbackModel) async {
    try {
      final json = await FirebaseFirestore.instance
          .collection('feedbacks')
          .doc(feedbackModel.id)
          .set(feedbackModel.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteFeedback(String feedbackId) async {
    print(feedbackId);
    try {
      await FirebaseFirestore.instance
          .collection('feedbacks')
          .doc(feedbackId)
          .delete();
      print('deleted');
    } catch (e) {
      print(e);
    }
  }
}

// Finally, we are using StateNotifierProvider to allow the UI to interact with
// our FeedbackNotifier class.
final feedbackContollerProvider =
    StateNotifierProvider<FeedbackNotifier, List<FeedbackModel>>((ref) {
  return FeedbackNotifier();
});
