import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taghole/constant/color.dart';
import 'package:taghole/controllers/auth_controller.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LatLng? _initialPosition;
  MapType _currentMapType = MapType.normal;
  List<Placemark> _placemark = [];
  String? _address;
  Position? _position;
  double? _lat;
  double? _lng;
  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() async {
    Permission.location.request().then((permission) async {
      if (permission.isGranted) {
        await _getUserLocation();
        await _populateClients();
      }
      if (permission.isDenied) {
        _setDefaultLocation();
      }
    });
  }

  Future _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _setDefaultLocation() {
    setState(() {
      _initialPosition = const LatLng(12.0676, 124.5930);
    });
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  Widget mapButton(Function()? function, Icon icon, Color color) {
    return MaterialButton(
      onPressed: function,
      shape: const CircleBorder(),
      elevation: 2.0,
      padding: const EdgeInsets.all(7.0),
      color: color,
      child: icon,
    );
  }

  Future getAddress(double latitude, double longitude) async {
    _placemark = await placemarkFromCoordinates(latitude, longitude);
    setState(() {
      _address = "${_placemark[0].name},${_placemark[0].locality}";
    });
  }

  void getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      _position = res;
      _lat = _position!.latitude;
      _lng = _position!.longitude;
    });
    await getAddress(_lat!, _lng!);
  }

  Set<Marker> _createMarkers() {
    return _markers.values.toSet();
  }

  _populateClients() {
    FirebaseFirestore.instance.collection('reports').get().then((docs) {
      if (docs.docs.isNotEmpty) {
        for (int i = 0; i < docs.docs.length; ++i) {
          print("DATA HERE");
          print(docs.docs[i].data());
          initMarker(docs.docs[i].data(), docs.docs[i].id);
        }
      }
    });
  }

  void initMarker(request, requestId) {
    var markerIdVal = requestId;
    final MarkerId markerId = MarkerId(markerIdVal);
    // creating a new MARKER
    final Marker marker = Marker(
      onTap: () {
        showModalBottomSheet<void>(
          context: scaffoldKey.currentState!.context,
          builder: (BuildContext context) {
            return Container(
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5)),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.network(
                                  request['imageurl'],
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                        ),
                                      );
                                    }
                                  },
                                  fit: BoxFit.fill,
                                ),
                                const Positioned.fill(
                                  child: Center(
                                    child:
                                        CircularProgressIndicator(), // Facebook-like loader
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text("Type: ${request['potholetype']}"),
                            Text("Address: ${request['address']}")
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
      markerId: markerId,
      position: LatLng(request['position']['geopoint'].latitude,
          request['position']['geopoint'].longitude),
      infoWindow: InfoWindow(
        title: request['potholetype'],
        snippet: request['address'],
      ),
    );
    setState(() {
      _markers[markerId] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "Location Tags",
          style: TextStyle(color: secondaryColor),
        ),
        centerTitle: true,
        actions: [
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                  onPressed: () {
                    ref.read(authControllerProvider.notifier).signOut();
                  },
                  icon: const Icon(Icons.exit_to_app));
            },
          )
        ],
      ),
      body: _initialPosition == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitCubeGrid(
                    size: 60.0,
                    color: secondaryColor,
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    'Loading...',
                  ),
                  SizedBox(height: 50.0),
                  Text(
                    'In case it keeps on loading, please enable location.',
                  ),
                ],
              ),
            )
          : Stack(
              children: <Widget>[
                GoogleMap(
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  mapType: _currentMapType,
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition!,
                    zoom: 14.4746,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  markers: _createMarkers(),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                    child: Column(
                      children: <Widget>[
                        mapButton(_onMapTypeButtonPressed,
                            const Icon(Icons.filter_hdr), Colors.white),
                      ],
                    ),
                  ),
                )
              ],
            ),
      // floatingActionButton: FloatingActionButton.extended(
      //     onPressed: () {
      //       //TODO: try to add
      //       showDialog(
      //           context: context,
      //           builder: (context) {
      //             return AlertDialog(
      //               title: const Text("Tag a hole"),
      //               content: SizedBox(
      //                 height: MediaQuery.of(context).size.height / 6,
      //                 child: Column(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     const Text(
      //                         'In order to tag a hole you must be a registered user.'),
      //                     Row(
      //                       mainAxisAlignment: MainAxisAlignment.end,
      //                       children: [
      //                         Consumer(
      //                           builder: (context, ref, child) {
      //                             return MaterialButton(
      //                               color: secondaryColor,
      //                               onPressed: () async {
      //                                 //  ref.read(authControllerProvider.notifier).signOut();
      //                                 Navigator.pushNamed(
      //                                     context, '/citizenSignup');
      //                               },
      //                               child: const Text(
      //                                 "Register Now",
      //                                 style: TextStyle(color: Colors.white),
      //                               ),
      //                             );
      //                           },
      //                         )
      //                       ],
      //                     )
      //                   ],
      //                 ),
      //               ),
      //             );
      //           });
      //     },
      //     label: const Icon(Icons.report)),
    );
  }
}
