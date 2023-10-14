import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as loc;
import 'package:taghole/adminweb/models/report/report_model.dart';
import 'package:taghole/constant/color.dart';

import '../../../repositories/auth_repository.dart';
import '../../Screens/HomeMenuPages/services/toast.dart';

class UpdateForm extends StatefulWidget {
  final ReportModel report;
  const UpdateForm({super.key, required this.report});

  @override
  _UpdateFormState createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _descriptionFocusNode = FocusNode();

  final _firestore = FirebaseFirestore.instance;
  GeoFlutterFire geo = GeoFlutterFire();
  loc.Location location = loc.Location();

  String? _description;
  String? imageurl;
  final picker = ImagePicker();

  late GeoFirePoint point;

  Future _getImage({required source}) async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.any, allowMultiple: false);

    if (result != null && result.files.isNotEmpty) {
      final fileBytes = result.files.first.bytes;
      final fileName = result.files.first.name;

      // upload file
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('images/$fileName')
          .putData(fileBytes!);

      var downUrl = await (await uploadTask.whenComplete(() => null))
          .ref
          .getDownloadURL();
      var url = downUrl.toString();
      setState(() {
        imageurl = url;
        print('iamge url');
        print(imageurl);
      });
    }
  }

  void setLocation() async {
    var pos = await location.getLocation();
    point = geo.point(latitude: pos.latitude!, longitude: pos.longitude!);
  }

  void addUpdate({required String reportId}) async {
    //TODO: addd update in firestore
    _firestore.collection('reports').doc(reportId).update({
      'updates': FieldValue.arrayUnion([
        {'image': imageurl, 'description': _description}
      ])
    });
  }

  @override
  void initState() {
    setLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              DottedBorder(
                color: Colors.grey,
                strokeWidth: 1,
                child: SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      imageurl != null
                          ? SizedBox(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(
                                imageurl!,
                                fit: BoxFit.fitWidth,
                              ),
                            )
                          : Center(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.cloud_upload_rounded),
                                    Center(
                                      child: Builder(
                                        builder: (context) {
                                          if (imageurl == null) {
                                            return const Text(
                                              'Please choose an image',
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.redAccent),
                                            );
                                          } else {
                                            return const Text(
                                              'Image has been selected',
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.green),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      Positioned(
                        bottom: 5,
                        right: 10,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: secondaryColor),
                                onPressed: () {
                                  _getImage(source: ImageSource.gallery);
                                },
                                icon: const Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Upload',
                                  style: TextStyle(color: Colors.white),
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
              TextFormField(
                focusNode: _descriptionFocusNode,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: "Description",
                  hintText: "description",
                  focusColor: secondaryColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    borderSide: BorderSide(
                      color: secondaryColor,
                      width: 1.0,
                    ),
                  ),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (value) => _description = value,
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      final user =
                          ref.read(authRepositoryProvider).getCurrentUser();
                      print('user');
                      print(user!.uid);
                      return MaterialButton(
                        color: secondaryColor,
                        onPressed: () async {
                          _formKey.currentState!.save();
                          if (imageurl == null) {
                            toastMessage('Please Select an Image');
                          } else {
                            if (_formKey.currentState!.validate()) {
                              toastMessage("Updates uploaded");
                              addUpdate(reportId: widget.report.id);
                              await Future.delayed(const Duration(seconds: 3));
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ],
              )
            ],
          )),
    );
  }
}
