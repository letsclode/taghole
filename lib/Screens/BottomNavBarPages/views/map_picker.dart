import 'dart:async';

import 'package:bouncerwidget/bouncerwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:map_picker/map_picker.dart';
import 'package:taghole/constant/color.dart';

class KMapPicker extends StatefulWidget {
  const KMapPicker({Key? key}) : super(key: key);

  @override
  _KMapPickerState createState() => _KMapPickerState();
}

class _KMapPickerState extends State<KMapPicker> {
  final _controller = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();
  LatLng? _initialPosition;

  late CameraPosition cameraPosition;

  var textController = TextEditingController();

  @override
  void initState() {
    _getUserLocation();
    super.initState();
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      cameraPosition = CameraPosition(
        target: _initialPosition!,
        zoom: 14.4746,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _initialPosition == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitCubeGrid(
                    color: secondaryColor,
                    size: 80.0,
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    'Loading...',
                    style: TextStyle(color: secondaryColor),
                  ),
                  SizedBox(height: 50.0),
                  Text(
                    'In case it keeps on loading, please enable location.',
                    style: TextStyle(color: secondaryColor, fontSize: 20.0),
                  ),
                ],
              ),
            )
          : Stack(
              alignment: Alignment.topCenter,
              children: [
                MapPicker(
                  // pass icon widget
                  iconWidget: BouncingWidget(
                    child: Image.asset(
                      "assets/images/pin.png",
                      height: 40,
                    ),
                  ),
                  //add map picker controller
                  mapPickerController: mapPickerController,
                  child: GoogleMap(
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    // hide location button
                    myLocationButtonEnabled: false,
                    mapType: MapType.normal,
                    //  camera position
                    initialCameraPosition: cameraPosition,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    onCameraMoveStarted: () {
                      // notify map is moving
                      mapPickerController.mapMoving!();
                      setState(() {
                        textController.text = "checking ...";
                      });
                    },
                    onCameraMove: (cameraPosition) {
                      this.cameraPosition = cameraPosition;
                    },
                    onCameraIdle: () async {
                      // notify map stopped moving
                      // update the ui with the address
                      mapPickerController.mapFinishedMoving!();
                      //get address name from camera position
                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                        cameraPosition.target.latitude,
                        cameraPosition.target.longitude,
                      );
                      setState(() {
                        textController.text =
                            '${placemarks.first.name}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';
                      });
                    },
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).viewPadding.top + 20,
                  width: MediaQuery.of(context).size.width - 50,
                  height: 50,
                  child: Container(
                    color: const Color.fromARGB(125, 158, 158, 158),
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: TextFormField(
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        readOnly: true,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none),
                        controller: textController,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 24,
                  left: 24,
                  right: 24,
                  child: SizedBox(
                    height: 50,
                    child: MaterialButton(
                      color: secondaryColor,
                      disabledColor: Colors.grey,
                      onPressed: textController.text == "checking ..."
                          ? null
                          : () {
                              loc.LocationData locationData =
                                  loc.LocationData.fromMap({
                                "latitude": cameraPosition.target.latitude,
                                "longitude": cameraPosition.target.longitude,
                              });

                              Navigator.of(context)
                                  .pop<loc.LocationData>(locationData);
                            },
                      child: const Text(
                        "Submit Location",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
