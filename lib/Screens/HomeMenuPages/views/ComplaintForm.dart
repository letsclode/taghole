import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:taghole/Screens/BottomNavBarPages/views/map_picker.dart';

import '../services/focuschanger.dart';
import '../services/toast.dart';

class ComplaintForm extends StatefulWidget {
  const ComplaintForm({super.key});

  @override
  _ComplaintFormState createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _potholetypeFocusNode = FocusNode();
  final FocusNode _departmentFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _landmarkFocusNode = FocusNode();
  final FocusNode _commentFocusNode = FocusNode();
  final FocusNode _phonenumFocusNode = FocusNode();

  final _firestore = FirebaseFirestore.instance;
  GeoFlutterFire geo = GeoFlutterFire();
  Location location = Location();

  String? _username,
      _email,
      _potholetype,
      _department,
      _address,
      _landmark,
      _comment;
  int? _phonenum;
  final bool _work = false;
  String? imageurl;
  XFile? image;
  final picker = ImagePicker();

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

  void uploadform() async {
    var pos = await location.getLocation();
    GeoFirePoint point =
        geo.point(latitude: pos.latitude!, longitude: pos.longitude!);
    _firestore.collection('reports').add({
      'username': _username,
      'position': point.data,
      'email': _email,
      'potholetype': _potholetype,
      'department': _department,
      'address': _address,
      'landmark': _landmark,
      'comment': _comment,
      'phonenum': _phonenum,
      'work': _work,
      'imageurl': imageurl,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.amber,
        ),
        backgroundColor: Colors.white,
        title: const Text(
          "Complaint Form",
          style: TextStyle(color: Colors.amber),
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
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.amber),
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
                    focusColor: Colors.amber,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.amber,
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
                    focusColor: Colors.amber,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.amber,
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
                MaterialButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const KMapPicker()),
                  );
                }),
                // TextFormField(
                //   focusNode: _addressFocusNode,
                //   autofocus: true,
                //   textCapitalization: TextCapitalization.words,
                //   keyboardType: TextInputType.text,
                //   decoration: const InputDecoration(
                //     labelText: "Address",
                //     hintText: "Address of pothole",
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(8.0),
                //       ),
                //       borderSide: BorderSide(
                //         color: Colors.amber,
                //         width: 1.0,
                //       ),
                //     ),
                //   ),
                //   textInputAction: TextInputAction.next,
                //   validator: (address) {
                //     if (address == null) {
                //       return 'Address is Required';
                //     }
                //     return null;
                //   },
                //   onSaved: (address) => _address = address,
                //   onFieldSubmitted: (_) {
                //     fieldFocusChange(
                //         context, _addressFocusNode, _landmarkFocusNode);
                //   },
                // ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  focusNode: _landmarkFocusNode,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "Landmark",
                    hintText: "Nearby Landmark",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.amber,
                        width: 1.0,
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (name) {
                    if (name == null) {
                      return 'Landmark is Required';
                    }
                    return null;
                  },
                  onSaved: (name) => _landmark = name,
                  onFieldSubmitted: (_) {
                    fieldFocusChange(
                        context, _landmarkFocusNode, _commentFocusNode);
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  focusNode: _commentFocusNode,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "Comment",
                    hintText: "Comment about pothole",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.amber,
                        width: 1.0,
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (comment) {
                    if (comment == null) {
                      return 'Comment is Required';
                    }
                    return null;
                  },
                  onSaved: (comment) => _comment = comment,
                  onFieldSubmitted: (_) {
                    fieldFocusChange(
                        context, _commentFocusNode, _usernameFocusNode);
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  focusNode: _usernameFocusNode,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.amber,
                        width: 1.0,
                      ),
                    ),
                    labelText: "Username",
                    hintText: "e.g Yash",
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (name) {
                    String pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
                    RegExp regex = RegExp(pattern);
                    if (!regex.hasMatch(name!)) {
                      return 'Invalid username';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (name) => _username = name,
                  onFieldSubmitted: (_) {
                    fieldFocusChange(
                        context, _usernameFocusNode, _emailFocusNode);
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  focusNode: _emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.amber,
                        width: 1.0,
                      ),
                    ),
                    labelText: "Email",
                    hintText: "e.g abc@gmail.com",
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (email) => EmailValidator.validate(email!)
                      ? null
                      : "Invalid email address",
                  onSaved: (email) => _email = email,
                  onFieldSubmitted: (_) {
                    fieldFocusChange(
                        context, _emailFocusNode, _phonenumFocusNode);
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  focusNode: _phonenumFocusNode,
                  decoration: const InputDecoration(
                    labelText: "Enter your number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.amber,
                        width: 1.0,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _phonenum = int.parse(value);
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ], // Only numbers can be entered
                ),
                const SizedBox(
                  height: 20.0,
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
