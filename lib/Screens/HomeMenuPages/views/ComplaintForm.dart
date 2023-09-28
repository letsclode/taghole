import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as loc;
import 'package:taghole/Screens/BottomNavBarPages/views/map_picker.dart';
import 'package:taghole/constant/color.dart';

import '../services/focuschanger.dart';
import '../services/toast.dart';

class ComplaintForm extends StatefulWidget {
  const ComplaintForm({super.key});

  @override
  _ComplaintFormState createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _potholetypeFocusNode = FocusNode();
  final FocusNode _departmentFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();

  final _firestore = FirebaseFirestore.instance;
  GeoFlutterFire geo = GeoFlutterFire();
  loc.Location location = loc.Location();

  String? _potholetype, _department, _address;
  final bool _work = false;
  String? imageurl;
  XFile? image;
  final picker = ImagePicker();

  late GeoFirePoint point;

  Future _getImage() async {
    var selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      image = selectedImage;
    });
    uploadImage();
  }

  Future uploadImage() async {
    Reference ref = FirebaseStorage.instance.ref().child(image!.path);
    UploadTask uploadTask = ref.putFile(File(image!.path));

    var downUrl =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    var url = downUrl.toString();
    setState(() {
      imageurl = url;
    });
    print('url is $imageurl');
  }

  void setLocation() async {
    var pos = await location.getLocation();
    point = geo.point(latitude: pos.latitude!, longitude: pos.longitude!);
  }

  void uploadform() async {
    _firestore.collection('reports').add({
      'position': point.data,
      'potholetype': _potholetype,
      'department': _department,
      'address': _address,
      'work': _work,
      'imageurl': imageurl,
    });
  }

  @override
  void initState() {
    setLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: const BackButton(
          color: secondaryColor,
        ),
        backgroundColor: Colors.white,
        title: const Text(
          "Complaint Form",
          style: TextStyle(color: secondaryColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor),
                    onPressed: _getImage,
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Add Image',
                      style: TextStyle(color: Colors.white),
                    )),
                const SizedBox(height: 20.0),
                Center(
                  child: Builder(
                    builder: (context) {
                      if (image == null) {
                        return const Text(
                          'Please choose an image',
                          style: TextStyle(
                              fontSize: 15.0, color: Colors.redAccent),
                        );
                      } else {
                        return const Text(
                          'Image has been selected',
                          style: TextStyle(fontSize: 15.0, color: Colors.green),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  focusNode: _potholetypeFocusNode,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "Pothole Type",
                    hintText: "e.g pothole,cracks,deformation,deep etc",
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
                    if (value == null) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onSaved: (value) => _potholetype = value,
                  onFieldSubmitted: (_) {
                    fieldFocusChange(
                        context, _potholetypeFocusNode, _departmentFocusNode);
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  focusNode: _departmentFocusNode,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "Department",
                    hintText: "e.g Nagarpalika",
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
                  validator: (department) {
                    if (department == null) {
                      return 'Department is Required';
                    }
                    return null;
                  },
                  onSaved: (department) => _department = department,
                  onFieldSubmitted: (_) {
                    fieldFocusChange(
                        context, _departmentFocusNode, _addressFocusNode);
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Column(
                  children: [
                    _address!.isEmpty
                        ? const CircularProgressIndicator()
                        : Text(_address!),
                    OutlinedButton(
                      onPressed: () {
                        _address = '';
                        Navigator.push<loc.LocationData?>(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const KMapPicker()),
                        ).then((value) async {
                          if (value != null) {
                            print('address');
                            print(value);

                            point = geo.point(
                                latitude: value.latitude!,
                                longitude: value.longitude!);

                            List<Placemark> placemarks =
                                await placemarkFromCoordinates(
                              point.latitude,
                              point.longitude,
                            );

                            // update the ui with the address
                            setState(() {
                              _address =
                                  '${placemarks.first.name}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';
                            });
                          } else {
                            print("User didn't select a location");
                          }
                        });
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: secondaryColor,
                          ),
                          Text('Pick a location'),
                        ],
                      ),
                    ),
                  ],
                ),
                MaterialButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    if (image == null) {
                      toastMessage('Please Select an Image');
                    } else {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        toastMessage(
                            "Thank You Your Response has been submitted");
                        uploadform();
                        await Future.delayed(const Duration(seconds: 3));
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
