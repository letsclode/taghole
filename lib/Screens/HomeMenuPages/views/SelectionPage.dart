import 'package:flutter/material.dart';
import 'package:taghole/Screens/HomeMenuPages/views/ComplaintForm.dart';
import 'package:taghole/constant/color.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: secondaryColor,
          ),
          title: const Text(
            "New Complaint",
            style: TextStyle(color: secondaryColor),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // MaterialButton(
                //   splashColor: secondaryColor,
                //   focusColor: secondaryColor,
                //   onPressed: () {},
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(30.0),
                //   ),
                //   child: const Text(
                //     "Capture through camera",
                //     style: TextStyle(
                //       color: secondaryColor,
                //     ),
                //   ),
                // ),
                // const Divider(
                //   color: Color(0xff2e279d),
                //   height: 20.0,
                //   endIndent: 150,
                //   indent: 150,
                //   thickness: 0.5,
                // ),
                MaterialButton(
                  splashColor: secondaryColor,
                  focusColor: secondaryColor,
                  onPressed: null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ComplaintForm()),
                      );
                    },
                    child: const Text(
                      "Upload Through Gallery",
                      style: TextStyle(
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                // const Divider(
                //   color: Color(0xff2e279d),
                //   height: 20.0,
                //   endIndent: 150,
                //   indent: 150,
                //   thickness: 0.5,
                // ),
                // const Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     FloatingActionButton(
                //       onPressed: null,
                //       backgroundColor: secondaryColor,
                //       child: Icon(Icons.question_answer),
                //     ),
                //     SizedBox(width: 20),
                //     Text(
                //       "How to Report",
                //       style: TextStyle(color: secondaryColor),
                //     ),
                //   ],
                // )
              ],
            ),
          ],
        ));
  }
}
