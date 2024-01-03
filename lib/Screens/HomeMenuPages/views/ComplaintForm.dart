import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as loc;
import 'package:taghole/Screens/BottomNavBarPages/views/map_picker.dart';
import 'package:taghole/adminweb/models/report/report_model.dart';
import 'package:taghole/adminweb/providers/report/report_provider.dart';
import 'package:taghole/constant/color.dart';

import '../../../repositories/auth_repository.dart';
import '../services/toast.dart';

class ComplaintForm extends StatefulWidget {
  final ReportModel? report;
  final double additionalHeight;

  const ComplaintForm({super.key, this.report, this.additionalHeight = 0});

  @override
  _ComplaintFormState createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _potholetypeFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _landmarkFocusNode = FocusNode();
  final FocusNode _titleFocusNode = FocusNode();

  final _firestore = FirebaseFirestore.instance;
  GeoFlutterFire geo = GeoFlutterFire();
  loc.Location location = loc.Location();

  String? _potholetype, _address, _description, _landmark, _title;
  String? imageurl;
  XFile? image;
  final picker = ImagePicker();

  late GeoFirePoint point;
  bool loader = false;

  Future _getImage({required source}) async {
    var selectedImage = await ImagePicker().pickImage(source: source);

    setState(() {
      image = selectedImage;
    });

    await uploadImage();
  }

  Future uploadImage() async {
    Reference ref = FirebaseStorage.instance.ref().child(image!.path);
    UploadTask uploadTask = ref.putFile(File(image!.path));

    var downUrl =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();

    setState(() {
      imageurl = downUrl.toString();
    });
    debugPrint('url is $imageurl');
  }

  void setLocation() async {
    var pos = await location.getLocation();
    point = geo.point(latitude: pos.latitude!, longitude: pos.longitude!);
  }

  void pop() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    setLocation();
    _potholetype = 'pothole';
    if (widget.report != null) {
      setState(() {
        _address = widget.report!.address;
        _description = widget.report!.description;
        _landmark = widget.report!.landmark;
        _potholetype = widget.report!.type;
        imageurl = widget.report!.imageUrl;
      });
    }
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
          "Road Damage Report",
          style: TextStyle(color: secondaryColor),
        ),
        centerTitle: true,
      ),
      body: loader
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height +
                      widget.additionalHeight,
                  width: MediaQuery.of(context).size.width,
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
                                  image != null
                                      ? SizedBox(
                                          height: 200,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Image.file(
                                            File(image!.path),
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      : Center(
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                    Icons.cloud_upload_rounded),
                                                Center(
                                                  child: Builder(
                                                    builder: (context) {
                                                      if (image == null) {
                                                        return const Text(
                                                          'Please choose an image',
                                                          style: TextStyle(
                                                              fontSize: 15.0,
                                                              color: Colors
                                                                  .redAccent),
                                                        );
                                                      } else {
                                                        return const Text(
                                                          'Image has been selected',
                                                          style: TextStyle(
                                                              fontSize: 15.0,
                                                              color:
                                                                  Colors.green),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    secondaryColor),
                                            onPressed: () {
                                              _getImage(
                                                  source: ImageSource.camera);
                                            },
                                            icon: const Icon(
                                              Icons.add_a_photo,
                                              color: Colors.white,
                                            ),
                                            label: const Text(
                                              'Capture',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    secondaryColor),
                                            onPressed: () {
                                              _getImage(
                                                  source: ImageSource.gallery);
                                            },
                                            icon: const Icon(
                                              Icons.add_a_photo,
                                              color: Colors.white,
                                            ),
                                            label: const Text(
                                              'Upload',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            initialValue: _title,
                            focusNode: _titleFocusNode,
                            autofocus: true,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: "Title",
                              hintText: "Title",
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
                                return 'Please enter the land mark';
                              }
                              return null;
                            },
                            onSaved: (value) => _title = value,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            initialValue: _description,
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
                          TextFormField(
                            initialValue: _landmark,
                            focusNode: _landmarkFocusNode,
                            autofocus: true,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: "Landmark",
                              hintText: "Landmark",
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
                                return 'Please enter the land mark';
                              }
                              return null;
                            },
                            onSaved: (value) => _landmark = value,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Types',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                DropdownButton<String>(
                                    hint: const Text("Types"),
                                    isExpanded: true,
                                    value: _potholetype,
                                    focusNode: _potholetypeFocusNode,
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'pothole',
                                        child: Text('pothole'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'cracks',
                                        child: Text('cracks'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'deformation',
                                        child: Text('deformation'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'deep',
                                        child: Text('deep'),
                                      )
                                    ],
                                    onChanged: (newValue) {
                                      setState(() {
                                        _potholetype = newValue;
                                      });
                                    }),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Column(
                            children: [
                              _address == null
                                  ? const Text('No location yet')
                                  : Text(_address!),
                              OutlinedButton(
                                onPressed: () {
                                  _address = '';
                                  Navigator.push<loc.LocationData?>(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const KMapPicker()),
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
                                            '${placemarks.first.thoroughfare} ${placemarks.first.street}';
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
                          Consumer(
                            builder: (context, ref, child) {
                              final user = ref
                                  .read(authRepositoryProvider)
                                  .getCurrentUser();

                              final reportProvider =
                                  ref.read(reportProviderProvider.notifier);
                              print('user');
                              print(user!.uid);
                              return MaterialButton(
                                color: secondaryColor,
                                onPressed: () async {
                                  _formKey.currentState!.save();
                                  print(image);
                                  if (image == null && imageurl == null) {
                                    toastMessage('Please Select an Image');
                                  } else {
                                    if (_potholetype == null ||
                                        _potholetype!.isEmpty) {
                                      toastMessage(
                                          'Please provide a pothole type');
                                    } else if (_address == null) {
                                      toastMessage('Please set a location');
                                    } else {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          loader = true;
                                        });
                                        toastMessage(
                                            "Thank You Your Response has been submitted");
                                        if (widget.report != null) {
                                          await reportProvider.updateReport(
                                              widget.report!.copyWith(
                                                  title: _title!,
                                                  position: point.data,
                                                  type: _potholetype!,
                                                  address: _address!,
                                                  imageUrl: imageurl,
                                                  description: _description!,
                                                  landmark: _landmark!,
                                                  updatedAt: DateTime.now()));
                                        } else {
                                          print('imageurl is $imageurl');
                                          ReportModel reportModel = ReportModel(
                                              id: "",
                                              title: _title!,
                                              userId: user.uid,
                                              description: _description!,
                                              status: 'pending',
                                              isVerified: false,
                                              type: _potholetype!,
                                              imageUrl: imageurl,
                                              createdAt: DateTime.now(),
                                              updatedAt: DateTime.now(),
                                              updates: [],
                                              address: _address!,
                                              landmark: _landmark!,
                                              position: point.data);
                                          await reportProvider
                                              .addReport(reportModel);
                                        }
                                        setState(() {
                                          loader = false;
                                          image = null;
                                        });
                                        setState(() {
                                          pop();
                                        });
                                      }
                                    }
                                  }
                                },
                                child: const Text(
                                  "Submit",
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            },
                          )
                        ],
                      )),
                ),
              ),
            ),
    );
  }
}
