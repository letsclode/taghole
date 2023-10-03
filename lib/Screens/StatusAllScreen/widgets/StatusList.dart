import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taghole/constant/color.dart';

import '../services/DatabaseStatus.dart';

class StatusList extends StatefulWidget {
  const StatusList({super.key});

  @override
  _StatusListState createState() => _StatusListState();
}

class _StatusListState extends State<StatusList> {
  final _firestore = FirebaseFirestore.instance;

  Future deleteReport(String uid) async {
    await _firestore.collection('reports').doc(uid).delete();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: getStatusList(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: secondaryColor,
          )); // Show a loading indicator while waiting for data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No tags found"));
          }
          return ListView.builder(
            primary: false,
            itemCount: snapshot.data!.docs.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, i) {
              dynamic data = snapshot.data!.docs[i].data()
                  as Map<Object, Object?>; // TODO: watch this if its working

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
                          if (data['work'] == false) {
                            return CircleAvatar(
                                backgroundImage:
                                    NetworkImage(data['imageurl'] ?? ''),
                                // backgroundColor: Colors.grey,
                                radius: 20);
                          } else {
                            return const CircleAvatar(
                                backgroundColor: Colors.grey, radius: 20);
                          }
                        }),
                        textColor: secondaryColor,
                        title: Text("Type :${data['potholetype']}"),
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
                                    Text("Type :${data['potholetype']}"),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text("Address :${data['address']}"),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                  ],
                                )),
                          ),
                          ButtonBar(
                            alignment: MainAxisAlignment.spaceAround,
                            buttonHeight: 52.0,
                            buttonMinWidth: 90.0,
                            children: <Widget>[
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0)),
                                onPressed: () async {
                                  //TODO delete

                                  await deleteReport(snapshot.data!.docs[i].id);
                                  setState(() {});
                                },
                                child: const Column(
                                  children: <Widget>[
                                    Icon(Icons.delete),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    Text('Delete Tag'),
                                  ],
                                ),
                              ),
                              const Column(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                ],
                              ),
                              Switcher(
                                  data: data, uid: snapshot.data!.docs[i].id),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}

class Switcher extends StatefulWidget {
  const Switcher({super.key, required this.data, required this.uid});
  final Map<Object, Object?> data;
  final String uid;

  @override
  State<Switcher> createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {
  final _firestore = FirebaseFirestore.instance;

  Future<bool> updateReport(bool isValidate, String uid) async {
    print('click');
    Map<Object, Object?> newData = {'isValidate': isValidate};
    final data = await _firestore
        .collection('reports')
        .doc(uid)
        .update(newData)
        .then((value) => isValidate);
    return data;
  }

  bool isValidate = false;
  late String uid;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      isValidate = widget.data['isValidate'] as bool;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: updateReport(
          isValidate, widget.uid), // This is the Future you want to listen to
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return Switch(
            value: snapshot.data ?? false,
            onChanged: (value) {
              setState(() {
                isValidate = value;
              });
            });
      },
    );
  }
}
