import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  LatLng? _initialPosition;
  MapType _currentMapType = MapType.normal;
  List<Placemark> _placemark = [];
  String? _address;
  Position? _position;
  double? _lat;
  double? _lng;
  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _populateClients();
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  _onCameraMove(CameraPosition position) {
    // Handle camera move
  }

  Widget mapButton(Function()? function, Icon icon, Color color) {
    return RawMaterialButton(
      onPressed: function,
      shape: const CircleBorder(),
      elevation: 2.0,
      fillColor: color,
      padding: const EdgeInsets.all(7.0),
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
      appBar: AppBar(
        title: const Text(
          "Map",
          style: TextStyle(color: Colors.amber),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: _initialPosition == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitCubeGrid(
                    color: Colors.amber,
                    size: 80.0,
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    'Loading...',
                    style: TextStyle(color: Colors.amber),
                  ),
                  SizedBox(height: 50.0),
                  Text(
                    'In case it keeps on loading, please enable location.',
                    style: TextStyle(color: Colors.amber, fontSize: 20.0),
                  ),
                ],
              ),
            )
          : Stack(
              children: <Widget>[
                GoogleMap(
                  mapType: _currentMapType,
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition!,
                    zoom: 14.4746,
                  ),
                  onCameraMove: _onCameraMove,
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
                        mapButton(
                          _onMapTypeButtonPressed,
                          const Icon(Icons.filter_hdr),
                          Colors.amber,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
