import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/adminweb/widgets/update_form.dart';

import '../../constant/color.dart';
import '../drawer/drawer_index_provider.dart';
import '../models/report/report_model.dart';
import '../providers/report/report_provider.dart';

class TableScreen extends ConsumerStatefulWidget {
  final String title;

  final List<String> headers;
  final List<ReportModel> data;

  const TableScreen(
      {super.key,
      required this.title,
      required this.headers,
      required this.data});

  @override
  ConsumerState<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends ConsumerState<TableScreen> {
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
  final List<ReportModel> data;
  final BuildContext context;
  MyDataTableSource({required this.data, required this.context});

  @override
  DataRow getRow(int index) {
    final ReportModel row = data[index];
    return DataRow(cells: [
      DataCell(!row.isVerified
          ? const Text(
              'Unverified',
              style: TextStyle(color: Colors.grey),
            )
          : row.status
              ? const Text(
                  'Completed',
                  style: TextStyle(color: Colors.green),
                )
              : const Text(
                  'Ongoing',
                  style: TextStyle(color: Colors.orange),
                )),
      DataCell(Text(row.type)),
      DataCell(Text(row.address)),
      DataCell(Row(
        children: [
          OutlinedButton(
              onPressed: () {
                //TODO: show details
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Center(child: Text("Report Details")),
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
                                              row.imageUrl ??
                                                  'assets/images/map.png',
                                            ).image,
                                            fit: BoxFit.cover),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  Container(
                                    height:
                                        row.updates == null && !row.isVerified
                                            ? 200
                                            : 450,
                                    width: 500,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                                color: Colors.black),
                                            children: <TextSpan>[
                                              const TextSpan(
                                                  text: 'Type: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(text: row.type),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                                color: Colors.black),
                                            children: <TextSpan>[
                                              const TextSpan(
                                                  text: 'Address: ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                text: row.address,
                                              ),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                                color: Colors.black),
                                            children: <TextSpan>[
                                              const TextSpan(
                                                  text: 'Landmark: ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        'Ongoing Updates',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.orange),
                                                      ),
                                                      Consumer(builder:
                                                          (context, ref,
                                                              child) {
                                                        final reportProvider =
                                                            ref.read(
                                                                reportProviderProvider
                                                                    .notifier);
                                                        final currentIndex =
                                                            ref.watch(
                                                                drawerIndexProvider);
                                                        return MaterialButton(
                                                          color: primaryColor,
                                                          onPressed: () {
                                                            //TODO: verify
                                                            Navigator.pop(
                                                                context);
                                                            if (currentIndex ==
                                                                1) {
                                                              reportProvider
                                                                  .verifyReport(
                                                                      true,
                                                                      row.id);
                                                            } else {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      content:
                                                                          UpdateForm(
                                                                        report:
                                                                            row,
                                                                      ),
                                                                    );
                                                                  });
                                                            }
                                                          },
                                                          child: const Row(
                                                            children: [
                                                              Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              Text(
                                                                'Update',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
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
                                                            enableInfiniteScroll:
                                                                false,
                                                            height: 250.0),
                                                        items: row.updates!
                                                            .map((updateValue) {
                                                          return Builder(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Container(
                                                                  decoration: BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image: NetworkImage(updateValue
                                                                              .image),
                                                                          fit: BoxFit
                                                                              .cover)),
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  margin: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          5.0),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Container(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            10),
                                                                        color: Colors
                                                                            .black26,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Text(
                                                                              updateValue.description,
                                                                              style: const TextStyle(color: Colors.white, fontSize: 16.0),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Consumer(builder:
                                                  (context, ref, child) {
                                                final reportProvider = ref.read(
                                                    reportProviderProvider
                                                        .notifier);
                                                final currentIndex = ref
                                                    .watch(drawerIndexProvider);

                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    OutlinedButton(
                                                      onPressed: () async {
                                                        //TODO: delete report
                                                        Navigator.pop(context);
                                                        reportProvider
                                                            .deleteReport(
                                                                row.id);
                                                      },
                                                      child: const Text(
                                                        "Delete Report",
                                                        style: TextStyle(
                                                            color: Colors.red),
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
                                                                color: Colors
                                                                    .green,
                                                                onPressed: () {
                                                                  //TODO: verify
                                                                  Navigator.pop(
                                                                      context);
                                                                  if (currentIndex ==
                                                                      1) {
                                                                    reportProvider
                                                                        .verifyReport(
                                                                            true,
                                                                            row.id);
                                                                  } else {
                                                                    reportProvider.updateStatus(
                                                                        reportId: row
                                                                            .id,
                                                                        value:
                                                                            true);
                                                                  }
                                                                },
                                                                child: Text(
                                                                  currentIndex ==
                                                                          1
                                                                      ? 'Verify'
                                                                      : 'Complete Report',
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white),
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
              },
              child: const Text("Details")),
          const SizedBox(
            width: 10,
          ),
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
