import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../services/DatabaseFaq.dart';

class Faqlist extends StatefulWidget {
  const Faqlist({super.key});

  @override
  _FaqlistState createState() => _FaqlistState();
}

class _FaqlistState extends State<Faqlist> {
  @override
  void initState() {
    super.initState();
    getFaqList().then((results) {
      setState(() {
        querySnapshot = results;
      });
    });
  }

  QuerySnapshot? querySnapshot;

  @override
  Widget build(BuildContext context) {
    if (querySnapshot != null) {
      return ListView.builder(
        primary: false,
        itemCount: querySnapshot!.docs.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, i) {
          return Column(
            children: <Widget>[
              ExpansionTile(
                leading: CircleAvatar(
                  child: Image.asset("assets/FAQ/question.png"),
                ),
                title: Text(
                    "${querySnapshot!.docs[i].data()}"), //TODO dix this to get the exct value
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
                      child: Text(
                          "${querySnapshot!.docs[i].data()}"), //TODO dix this to get the exct value
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    } else {
      return const Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitCubeGrid(
            color: Colors.amber,
            size: 80.0,
          ),
          SizedBox(height: 20.0),
          Text(
            'Loading...',
            style: TextStyle(color: Colors.amber),
          ),
        ],
      ));
    }
  }
}
