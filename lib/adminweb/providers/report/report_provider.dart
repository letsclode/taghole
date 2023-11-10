import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taghole/adminweb/providers/report/report_filter_type_provider.dart';
import 'package:taghole/adminweb/widgets/update_form.dart';
import 'package:taghole/constant/color.dart';

import '../../drawer/drawer_index_provider.dart';
import '../../models/report/report_model.dart';

part 'report_provider.g.dart';

@riverpod
class ReportProvider extends _$ReportProvider {
  Future<List<ReportModel>> _fetchReports() async {
    print('fetch reports');
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
        return reports.where((element) => !element.isVerified).toList();
      case ReportFilterType.complete:
        return reports
            .where((element) => element.status && element.isVerified)
            .toList();
      case ReportFilterType.ongoing:
        return reports
            .where((element) => !element.status && element.isVerified)
            .toList();
      case ReportFilterType.all:
        return reports;
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
      {required String reportId, required bool value}) async {
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

  Future<void> verifyReport(bool isVisible, String uid) async {
    Map<Object, Object?> newData = {'isVerified': isVisible};
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      FirebaseFirestore.instance
          .collection('reports')
          .doc(uid)
          .update(newData)
          .then((value) => isVisible);
      return _fetchReports();
    });
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

  Future addUpdate(
      {required String reportId,
      required String imageurl,
      required String description}) async {
    //TODO: addd update in firestore
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      FirebaseFirestore.instance.collection('reports').doc(reportId).update({
        'updates': FieldValue.arrayUnion([
          {'image': imageurl, 'description': description}
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
                        height:
                            row.updates == null && !row.isVerified ? 200 : 450,
                        width: 500,
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
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
                            SizedBox(
                                height: 300,
                                width: 500,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
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
                                            final currentIndex =
                                                ref.watch(drawerIndexProvider);
                                            return MaterialButton(
                                              color: primaryColor,
                                              onPressed: () {
                                                //TODO: verify
                                                Navigator.pop(context);
                                                if (currentIndex == 1) {
                                                  reportProvider.verifyReport(
                                                      true, row.id);
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
                                    row.updates == null
                                        ? const SizedBox()
                                        : CarouselSlider(
                                            options: CarouselOptions(
                                                enableInfiniteScroll: false,
                                                height: 250.0),
                                            items:
                                                row.updates!.map((updateValue) {
                                              return Builder(
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  updateValue
                                                                      .image),
                                                              fit: BoxFit
                                                                  .cover)),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            color:
                                                                Colors.black26,
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
                                          )
                                  ],
                                )),
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
                                        OutlinedButton(
                                          onPressed: () async {
                                            //TODO: delete report
                                            Navigator.pop(context);
                                            reportProvider.deleteReport(row.id);
                                          },
                                          child: const Text(
                                            "Delete Report",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                        row.status == true
                                            ? const SizedBox()
                                            : Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  MaterialButton(
                                                    color: Colors.green,
                                                    onPressed: () {
                                                      //TODO: verify
                                                      Navigator.pop(context);
                                                      if (currentIndex == 1) {
                                                        reportProvider
                                                            .verifyReport(
                                                                true, row.id);
                                                      } else {
                                                        reportProvider
                                                            .updateStatus(
                                                                reportId:
                                                                    row.id,
                                                                value: true);
                                                      }
                                                    },
                                                    child: Text(
                                                      currentIndex == 1
                                                          ? 'Verify'
                                                          : 'Complete Report',
                                                      style: const TextStyle(
                                                          color: Colors.white),
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
