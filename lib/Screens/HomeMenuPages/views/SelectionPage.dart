import 'package:flutter/material.dart';
import 'package:taghole/Screens/HomeMenuPages/views/ComplaintForm.dart';

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
            color: Colors.amber,
          ),
          title: const Text(
            "New Complaint",
            style: TextStyle(color: Colors.amber),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
            //   child: Row(
            //     children: [
            //       RaisedButton.icon(
            //         onPressed: () {
            //           Navigator.pop(context);
            //         },
            //         icon: Icon(
            //           Icons.arrow_back_ios,
            //           color: Colors.white,
            //         ),
            //         color: Colors.amber,
            //         label: Text("Go on Homepage",
            //             style: TextStyle(
            //               color: Colors.white,
            //             )),
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(18.0),
            //             side: BorderSide(color: Colors.amber)),
            //       )
            //     ],
            //   ),
            // ),
            const SizedBox(height: 200),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  splashColor: Colors.amber,
                  focusColor: Colors.amber,
                  onPressed: null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: const Text(
                    "Capture through camera",
                    style: TextStyle(
                      color: Colors.amber,
                    ),
                  ),
                ),
                const Divider(
                  color: Color(0xff2e279d),
                  height: 20.0,
                  endIndent: 150,
                  indent: 150,
                  thickness: 0.5,
                ),
                MaterialButton(
                  splashColor: Colors.amber,
                  focusColor: Colors.amber,
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
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: Color(0xff2e279d),
                  height: 20.0,
                  endIndent: 150,
                  indent: 150,
                  thickness: 0.5,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: null,
                      backgroundColor: Colors.amber,
                      child: Icon(Icons.question_answer),
                    ),
                    SizedBox(width: 20),
                    Text(
                      "How to Report",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                )
              ],
            ),
          ],
        ));
  }
}
