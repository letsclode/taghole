import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taghole/adminweb/providers/report_provider.dart';
import 'package:taghole/constant/color.dart';

class StatusList extends ConsumerStatefulWidget {
  const StatusList({super.key});

  @override
  _StatusListState createState() => _StatusListState();
}

class _StatusListState extends ConsumerState<StatusList> {
  @override
  Widget build(BuildContext context) {
    final reportProvider = ref.watch(reportProviderProvider);
    return switch (reportProvider) {
      AsyncData(:final value) => ListView.builder(
          primary: false,
          itemCount: value.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0),
              child: Column(
                children: <Widget>[
                  Card(
                    elevation: 4, // Adjust the elevation as needed
                    margin: const EdgeInsets.all(
                        8.0), // Adjust the margin as needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8.0), // Adjust the border radius as needed
                    ),
                    child: ExpansionTile(
                      leading: Builder(builder: (context) {
                        if (value[i].status) {
                          return CircleAvatar(
                              backgroundImage:
                                  NetworkImage(value[i].imageUrl ?? ''),
                              // backgroundColor: Colors.grey,
                              radius: 20);
                        } else {
                          return const CircleAvatar(
                              backgroundColor: Colors.grey, radius: 20);
                        }
                      }),
                      textColor: secondaryColor,
                      title: Text("Type :${value[i].type}"),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Type :${value[i].type}"),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text("Address :${value[i].address}"),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text("Landmark :${value[i].landmark}"),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  const Text("Description :"),
                                  Text(
                                    value[i].description,
                                    maxLines: 4,
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      AsyncError(:final error) => Text('Error: $error'),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
