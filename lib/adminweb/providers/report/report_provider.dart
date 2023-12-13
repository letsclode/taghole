import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taghole/adminweb/providers/report/report_filter_type_provider.dart';
import 'package:taghole/adminweb/widgets/update_form.dart';
import 'package:taghole/constant/color.dart';
import 'package:taghole/controllers/user_controller.dart';
import 'package:taghole/models/user/user_model.dart';
import 'package:uuid/uuid.dart';

import '../../drawer/drawer_index_provider.dart';
import '../../models/report/report_model.dart';

part 'report_provider.g.dart';

@riverpod
class ReportProvider extends _$ReportProvider {
  Future<List<ReportModel>> _fetchReports() async {
    final filter = ref.watch(filterReportTypeProvider);
    final json = await FirebaseFirestore.instance
        .collection('reports')
        .orderBy('updatedAt', descending: true)
        .get();

    List<ReportModel> reports =
        json.docs.map((e) => ReportModel.fromJson(e.data())).toList();

    print('reports: $reports');

    switch (filter) {
      case ReportFilterType.verified:
        return reports.where((element) => element.isVerified).toList();
      case ReportFilterType.unverified:
        return reports
            .where((element) =>
                !element.isVerified && element.status != 'rejected')
            .toList();
      case ReportFilterType.complete:
        return reports
            .where((element) =>
                element.status == 'completed' && element.isVerified)
            .toList();
      case ReportFilterType.ongoing:
        return reports
            .where(
                (element) => element.status == 'ongoing' && element.isVerified)
            .toList();
      case ReportFilterType.all:
        return reports;

      case ReportFilterType.rejected:
        return reports
            .where((element) =>
                element.status == 'rejected' && !element.isVerified)
            .toList();
    }
  }

  @override
  FutureOr<List<ReportModel>> build() async {
    // Load initial todo list from the remote repository
    return _fetchReports();
  }

  Future<List<ReportModel>> getVisibleReports() async {
    return _fetchReports();
  }

  Future<void> updateStatus(
      {required String reportId, required String value}) async {
    print('reportid');
    print(reportId);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await FirebaseFirestore.instance
          .collection('reports')
          .doc(reportId)
          .update({'status': value});
      return _fetchReports();
    });
  }

  Future<void> verifyReport(String uid) async {
    Map<Object, Object?> newData = {'isVerified': true, 'status': 'ongoing'};
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      FirebaseFirestore.instance.collection('reports').doc(uid).update(newData);
      return _fetchReports();
    });
  }

  Future<void> rejectReport(String uid) async {
    Map<Object, Object?> newData = {'status': 'rejected'};
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      FirebaseFirestore.instance.collection('reports').doc(uid).update(newData);
      return _fetchReports();
    });
  }

  Future<int> monthlyReport() async {
    try {
      // Get the current date
      DateTime now = DateTime.now();

      // Calculate the first day of the current month
      DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);

      // Calculate the last day of the current month
      DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

      // Query the Firestore collection with a range filter on the timestamp
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('reports')
          .where('createdAt', isGreaterThanOrEqualTo: firstDayOfMonth)
          .where('createdAt', isLessThanOrEqualTo: lastDayOfMonth)
          .get();

      // Calculate the total report value
      int totalReport = 0;
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        print(doc);
        // Assuming each document has a field 'value' that represents the report value
        totalReport++;
      }

      return totalReport;
    } catch (e) {
      print(e);
    }
    return 0;
  }

  Future<int> onGoingReports() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('reports')
          .where('status', isEqualTo: 'ongoing')
          .get();

      // Calculate the total report value
      int totalReport = 0;
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        totalReport++;
      }
      return totalReport;
    } catch (e) {
      print(e);
    }

    return 0;
  }

  Future<int> pendingReports() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('reports')
        .where('status', isEqualTo: 'pending')
        .get();

    // Calculate the total report value
    int totalReport = 0;
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      // Assuming each document has a field 'value' that represents the report value
      totalReport++;
    }

    return totalReport;
  }

  Future<int> completedReports() async {
    // Query the Firestore collection with a range filter on the timestamp
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('reports')
        .where('status', isEqualTo: 'completed')
        .get();

    // Calculate the total report value
    int totalReport = 0;
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      // Assuming each document has a field 'value' that represents the report value
      totalReport++;
    }

    return totalReport;
  }

  Future<void> rateReport(double rates, String uid) async {
    Map<Object, Object?> newData = {'ratings': rates};
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      FirebaseFirestore.instance.collection('reports').doc(uid).update(newData);
      return _fetchReports();
    });
  }

  Future<void> deleteReport(String uid) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await FirebaseFirestore.instance.collection('reports').doc(uid).delete();
      return _fetchReports();
    });
  }

  Future addReport(ReportModel report) async {
    state = const AsyncValue.loading();
    var uuid = const Uuid();
    final generatedId = uuid.v1();
    //TODO: make it reportmodel
    await FirebaseFirestore.instance
        .collection('reports')
        .doc(generatedId)
        .set(report.copyWith(id: generatedId).toJson());
  }

  Future updateReport(ReportModel updateReport) async {
    await FirebaseFirestore.instance
        .collection('reports')
        .doc(updateReport.id)
        .update(updateReport.toJson());
  }

  Future addUpdate(
      {String? title,
      required String reportId,
      required String imageurl,
      required String description}) async {
    //TODO: addd update in firestore
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      FirebaseFirestore.instance.collection('reports').doc(reportId).update({
        'updatedAt': DateTime.now(),
        'updates': FieldValue.arrayUnion([
          {
            'image': imageurl,
            'description': description,
            title: 'title',
            'createdAt': DateTime.now()
          }
        ])
      });
      return _fetchReports();
    });
  }

  void showReportDetails(
      {required BuildContext context, required ReportModel row}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Report Details"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                )
              ],
            )),
            content: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    children: [
                      Container(
                        height: 200,
                        width: 500,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: Image.network(
                                  row.imageUrl ?? 'assets/images/map.png',
                                ).image,
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      Container(
                        height: row.updates.isEmpty && !row.isVerified
                            ? 200
                            : row.updates.isNotEmpty
                                ? 450
                                : 250,
                        width: 500,
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Consumer(builder: (_, ref, child) {
                              final user = ref
                                  .watch(userControllerProvider.notifier)
                                  .getUserById(id: row.userId);
                              return FutureBuilder<UserModel>(
                                  future: user,
                                  builder: (_, snap) {
                                    if (snap.hasData) {
                                      return RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                              color: Colors.black),
                                          children: <TextSpan>[
                                            const TextSpan(
                                                text: 'Posted by : ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                              text: snap.data!.email,
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  });
                            }),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(color: Colors.black),
                                children: <TextSpan>[
                                  const TextSpan(
                                      text: 'Title: ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                    text: row.title,
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(color: Colors.black),
                                children: <TextSpan>[
                                  const TextSpan(
                                      text: 'Type: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: row.type),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(color: Colors.black),
                                children: <TextSpan>[
                                  const TextSpan(
                                      text: 'Address: ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                    text: row.address,
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(color: Colors.black),
                                children: <TextSpan>[
                                  const TextSpan(
                                      text: 'Landmark: ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                    text: row.landmark,
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(color: Colors.black),
                                children: <TextSpan>[
                                  const TextSpan(
                                      text: 'Description: ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                    text: row.description,
                                  ),
                                ],
                              ),
                            ),
                            row.status != 'ongoing'
                                ? row.updates.isNotEmpty
                                    ? const Padding(
                                        padding: EdgeInsets.only(
                                            top: 20, bottom: 10),
                                        child: Text(
                                          'Updates :',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : const SizedBox()
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (row.updates.isNotEmpty)
                                              const Text(
                                                'Ongoing Updates',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.orange),
                                              ),
                                            Consumer(
                                                builder: (context, ref, child) {
                                              final reportProvider = ref.read(
                                                  reportProviderProvider
                                                      .notifier);
                                              final currentIndex = ref
                                                  .watch(drawerIndexProvider);
                                              return MaterialButton(
                                                color: primaryColor,
                                                onPressed: () {
                                                  //TODO: verify
                                                  Navigator.pop(context);
                                                  if (currentIndex == 1) {
                                                    reportProvider
                                                        .verifyReport(row.id);
                                                  } else {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            content: UpdateForm(
                                                              report: row,
                                                            ),
                                                          );
                                                        });
                                                  }
                                                },
                                                child: const Row(
                                                  children: [
                                                    Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                    ),
                                                    Text(
                                                      'Update',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            })
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                            Column(
                              children: [
                                row.updates.isEmpty
                                    ? const SizedBox()
                                    : SizedBox(
                                        height: 250,
                                        child: CarouselSlider(
                                          options: CarouselOptions(
                                              enableInfiniteScroll: false,
                                              height: 250.0),
                                          items: row.updates.map((updateValue) {
                                            return Builder(
                                              builder: (BuildContext context) {
                                                return Container(
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                updateValue
                                                                    .image),
                                                            fit: BoxFit.cover)),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          color: Colors.black26,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                updateValue
                                                                    .description,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16.0),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ));
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      )
                              ],
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Consumer(builder: (context, ref, child) {
                                    final reportProvider = ref
                                        .read(reportProviderProvider.notifier);
                                    final currentIndex =
                                        ref.watch(drawerIndexProvider);

                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        row.status == 'completed'
                                            ? const SizedBox()
                                            : Row(
                                                children: [
                                                  if (currentIndex == 1)
                                                    MaterialButton(
                                                      color: Colors.red,
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        reportProvider
                                                            .rejectReport(
                                                                row.id);
                                                      },
                                                      child: const Text(
                                                        'Reject',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  if (currentIndex != 4)
                                                    MaterialButton(
                                                      color: Colors.green,
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        if (currentIndex == 1) {
                                                          reportProvider
                                                              .verifyReport(
                                                                  row.id);
                                                        } else {
                                                          reportProvider
                                                              .updateStatus(
                                                                  reportId:
                                                                      row.id,
                                                                  value:
                                                                      'completed');
                                                        }
                                                      },
                                                      child: Text(
                                                        currentIndex == 1
                                                            ? 'Verify'
                                                            : 'Complete Report',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                ],
                                              )
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
