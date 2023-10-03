import 'dart:async';
import 'dart:ui';

import 'package:bouncerwidget/bouncerwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:map_picker/map_picker.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:taghole/Screens/BottomNavBarPages/views/search_location.dart';
import 'package:taghole/constant/color.dart';
import 'package:taghole/constant/grid.dart';

class KMapPicker extends StatefulWidget {
  const KMapPicker({Key? key}) : super(key: key);

  @override
  _KMapPickerState createState() => _KMapPickerState();
}

class _KMapPickerState extends State<KMapPicker> {
  final _controller = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();
  LatLng? _initialPosition;
  final locationController = FloatingSearchBarController();

  late BitmapDescriptor _locationMarker;
  Set<Marker> _markers = {};

  late CameraPosition cameraPosition;

  var textController = TextEditingController();

  bool isSearchLocationFocus = false;

  late LatLng _currentCenter;

  LatLng? locationLatLng;

  late bool isManualPin;

  @override
  void initState() {
    isManualPin = false;
    _getUserLocation();
    super.initState();
  }

  void _getUserLocation() async {
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _initialPosition = const LatLng(12.0676, 124.5930);
      // _initialPosition = LatLng(position.latitude, position.longitude);
      cameraPosition = CameraPosition(
        target: _initialPosition!,
        zoom: 14.4746,
      );
    });
  }

  Future<void> setMap(LatLng? latLng) async {
    const iconData = Icons.location_on_rounded;
    final locationPictureRecorder = PictureRecorder();
    final locationCanvas = Canvas(locationPictureRecorder);
    final locationTextPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    final locationIconStr = String.fromCharCode(iconData.codePoint);

    locationTextPainter.text = TextSpan(
        text: locationIconStr,
        style: TextStyle(
          letterSpacing: 0.0,
          fontSize: 120.0,
          fontFamily: iconData.fontFamily,
        ));
    locationTextPainter.layout();
    locationTextPainter.paint(locationCanvas, const Offset(0.0, 0.0));

    final locationPicture = locationPictureRecorder.endRecording();
    final locationImage = await locationPicture.toImage(120, 120);
    final locationBytes =
        await locationImage.toByteData(format: ImageByteFormat.png);

    _locationMarker = BitmapDescriptor.fromBytes(
      locationBytes!.buffer.asUint8List(),
    );
    if (latLng != null) {
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('location_marker'),
            position: latLng,
            icon: _locationMarker,
          ),
        );
      });
    } else {
      setState(() => _markers = {});
    }
    await setView(latLng);
  }

  Future<void> setView(LatLng? latLng) async {
    final GoogleMapController controller = await _controller.future;
    if (latLng != null) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latLng.latitude + 0.004, latLng.longitude),
            zoom: 15,
          ),
        ),
      );
    }
  }

  void setOpen(bool isFocus) {
    setState(() => isSearchLocationFocus = isFocus);
  }

  void _onTap(LatLng position) async {
    setState(() {
      _currentCenter = position;
    });

    List<Placemark> placemarks = await placemarkFromCoordinates(
      _currentCenter.latitude,
      _currentCenter.longitude,
    );

    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('location_marker'),
          position: _currentCenter,
          icon: _locationMarker,
        ),
      );
    });
    _setLocation(
      latLng: _currentCenter,
    );
    _setSearchLocationQuery(placemarks.first);
  }

  void _setLocation({LatLng? latLng}) {
    setState(() => locationLatLng = latLng);
  }

  void _setSearchLocationQuery(Placemark placemark) {
    final street = placemark.street;
    final subLocality = placemark.subLocality;
    final locality = placemark.locality;
    final subAdministrativeArea = placemark.subAdministrativeArea;
    final administrativeArea = placemark.administrativeArea;
    final isoCountryCode = placemark.isoCountryCode;

    locationController.query =
        '$street $subLocality $locality $subAdministrativeArea $administrativeArea $isoCountryCode';
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
                            '${placemarks.first.street}, ${placemarks.first.locality}';
                      });
                    },
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).viewPadding.top + 100,
                  width: MediaQuery.of(context).size.width - 75,
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(81, 158, 158, 158),
                        borderRadius: BorderRadius.circular(10)),
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
                    height: 45,
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
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: AppBar().preferredSize.height - KXGrid.medium,
                    left: KXGrid.xLarge,
                    right: KXGrid.xLarge,
                  ),
                  child: SearchLocationContainerWidget(
                    setMap: (value) => setMap(value),
                    controller: locationController,
                    setOpen: (value) => setOpen(value),
                    setLatLng: (latLng) => _onTap(latLng!),
                    disabled: isManualPin,
                  ),
                )
              ],
            ),
    );
  }
}
