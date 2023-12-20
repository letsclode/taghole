import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/Screens/HomeMenuPages/views/ComplaintForm.dart';
import 'package:taghole/adminweb/models/feedback/feedback_model.dart';
import 'package:taghole/adminweb/models/report/report_model.dart';
import 'package:taghole/adminweb/providers/feedback/feedback_provider.dart';
import 'package:taghole/adminweb/providers/report/report_stream_provider.dart';
import 'package:taghole/constant/color.dart';
import 'package:taghole/controllers/auth_controller.dart';
import 'package:uuid/uuid.dart';

import '../../../adminweb/providers/report/report_provider.dart';
import '../../../extensions/utils.dart';

class StatusList extends ConsumerStatefulWidget {
  const StatusList({super.key});

  @override
  _StatusListState createState() => _StatusListState();
}

class _StatusListState extends ConsumerState<StatusList> {
  TextEditingController feedbackDescription = TextEditingController();
  double ratings = 5;

  @override
  Widget build(BuildContext context) {
    final reportProvider = ref.watch(reportsProvider);
    final feedbackProvider = ref.watch(feedbackContollerProvider.notifier);
    final userProvider = ref.watch(authControllerProvider);
    return switch (reportProvider) {
      AsyncData<List<ReportModel>>(:final value) => value.isEmpty
          ? const Center(
              child: Text(
                "No reports yet!",
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GroupedListView<dynamic, String>(
                elements: value,
                groupBy: (element) => element.status,
                groupSeparatorBuilder: (String groupByValue) => Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    children: [
                      Icon(Icons.circle,
                          size: 10,
                          color: groupByValue == 'pending'
                              ? Colors.grey
                              : groupByValue == 'ongoing'
                                  ? Colors.orange
                                  : groupByValue == 'rejected'
                                      ? Colors.red
                                      : Colors.green),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        groupByValue.toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                itemBuilder: (context, dynamic element) => Card(
                  elevation: 4, // Adjust the elevation as needed
                  margin:
                      const EdgeInsets.all(8.0), // Adjust the margin as needed
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8.0), // Adjust the border radius as needed
                  ),
                  child: ExpansionTile(
                    textColor: secondaryColor,
                    title: Text(element.title),
                    children: <Widget>[
                      const Divider(
                        thickness: 1.0,
                        height: 1.0,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 200,
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: FadeInImage(
                                      placeholder: const AssetImage(
                                          'assets/images/map.png'), // Placeholder image
                                      image: NetworkImage(element.imageUrl!),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                element.status != 'pending'
                                    ? element.status == 'completed'
                                        ? const Text(
                                            "Status : Completed",
                                            style:
                                                TextStyle(color: Colors.green),
                                          )
                                        : element.status == 'rejected'
                                            ? const Text(
                                                "Status : Rejected",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              )
                                            : const Text(
                                                "Status : Ongoing",
                                                style: TextStyle(
                                                    color: Colors.orange),
                                              )
                                    : const Text(
                                        "Status : Not Verified",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                if (element.status == 'rejected')
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                          "Reason of rejection: ${element.reason ?? ''}"),
                                    ],
                                  ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                    "Reported : ${formatDate(element.createdAt)}"),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                    "Last update : ${formatDate(element.updatedAt)}"),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text("Type : ${element.type}"),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text("Address : ${element.address}"),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text("Landmark : ${element.landmark}"),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                const Text("Description :"),
                                Text(
                                  element.description,
                                  maxLines: 4,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                element.updates.isNotEmpty
                                    ? Column(
                                        children: [
                                          const Text(
                                            'Ongoing Updates',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          for (var data in element.updates) ...[
                                            Card(
                                              child: ListTile(
                                                title:
                                                    Image.network(data.image),
                                                subtitle: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(data.description),
                                                    Text(formatDate(
                                                        data.createdAt)),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ]
                                        ],
                                      )
                                    : const SizedBox(),
                                if (!element.isVerified)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      MaterialButton(
                                        color: Colors.black,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ComplaintForm(
                                                        report: element)),
                                          );
                                        },
                                        child: const Text(
                                          "Repost",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                element.status == 'completed' &&
                                        element.ratings == null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          MaterialButton(
                                            color: secondaryColor,
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Center(
                                                        child: Text("Feedback"),
                                                      ),
                                                      content: SizedBox(
                                                        height: 250,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            const Text(
                                                              "Report ratings",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 13),
                                                            ),
                                                            RatingBar.builder(
                                                              itemSize: 30,
                                                              initialRating:
                                                                  ratings,
                                                              minRating: 1,
                                                              direction: Axis
                                                                  .horizontal,
                                                              allowHalfRating:
                                                                  true,
                                                              itemCount: 5,
                                                              itemPadding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          4.0),
                                                              itemBuilder:
                                                                  (context,
                                                                          _) =>
                                                                      const Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .amber,
                                                              ),
                                                              onRatingUpdate:
                                                                  (rating) {
                                                                setState(() {
                                                                  ratings =
                                                                      rating;
                                                                });

                                                                print(
                                                                    'ratings : $ratings');
                                                              },
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            TextField(
                                                              controller:
                                                                  feedbackDescription,
                                                              maxLines:
                                                                  3, // This allows for multiple lines of text
                                                              keyboardType:
                                                                  TextInputType
                                                                      .multiline, // This enables the Enter key
                                                              decoration:
                                                                  const InputDecoration(
                                                                hintText:
                                                                    'Description (optional)',
                                                                border:
                                                                    OutlineInputBorder(),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 30,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                OutlinedButton(
                                                                    onPressed:
                                                                        () {
                                                                      feedbackDescription
                                                                          .clear();
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: const Text(
                                                                        "Cancel")),
                                                                const SizedBox(
                                                                  width: 20,
                                                                ),
                                                                MaterialButton(
                                                                  color:
                                                                      secondaryColor,
                                                                  onPressed:
                                                                      () async {
                                                                    var uuid =
                                                                        const Uuid();
                                                                    final generatedId =
                                                                        uuid.v1();

                                                                    final reportControllerProvider =
                                                                        ref.read(
                                                                            reportProviderProvider.notifier);

                                                                    await feedbackProvider.addFeedback(FeedbackModel(
                                                                        createdAt:
                                                                            DateTime
                                                                                .now(),
                                                                        updatedAt:
                                                                            DateTime
                                                                                .now(),
                                                                        id:
                                                                            generatedId,
                                                                        userId: userProvider!
                                                                            .uid,
                                                                        reportId:
                                                                            element
                                                                                .id,
                                                                        description:
                                                                            feedbackDescription
                                                                                .text,
                                                                        ratings:
                                                                            ratings));

                                                                    await reportControllerProvider.rateReport(
                                                                        ratings,
                                                                        element
                                                                            .id);

                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    "Send",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            child: const Text(
                                              'Send Feedback',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox()
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      AsyncLoading(:final isLoading) => const Center(
          child: CircularProgressIndicator(),
        ),
      AsyncError(:final error) => Center(
          child: Text("$error"),
        ),
      _ => const Center(child: Text("No reports yet!")),
    };
  }
}
