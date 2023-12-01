import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taghole/adminweb/models/report/report_model.dart';
import 'package:taghole/constant/color.dart';
import 'package:taghole/controllers/auth_controller.dart';

import '../../../adminweb/providers/report/report_provider.dart';
import '../../HomeMenuPages/views/ComplaintForm.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LatLng? _initialPosition;
  MapType _currentMapType = MapType.normal;

  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  GlobalKey scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      requestPermission();
    } else {
      getUserLocation();
      _setDefaultLocation();
    }
  }

  void requestPermission() async {
    await Permission.location.request().then((permission) async {
      if (permission.isGranted) {
        getUserLocation();
      }
    });
    _setDefaultLocation();
  }

  void getUserLocation() async {
    _filterVisibleReports();
    await _getUserLocation();
  }

  Future _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
        if (_initialPosition == null) {
          _setDefaultLocation();
        }
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

  Set<Marker> _createMarkers() {
    return _markers.values.toSet();
  }

  _filterVisibleReports() async {
    final data =
        await ref.read(reportProviderProvider.notifier).getVisibleReports();

    for (ReportModel report in data) {
      initMarker(data: report);
    }
  }

  void initMarker({required ReportModel data}) {
    final MarkerId markerId = MarkerId(data.id);
    final Marker marker = Marker(
      onTap: () {
        showModalBottomSheet<void>(
          context: scaffoldKey.currentState!.context,
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                height: kIsWeb ? 300 : 250,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: kIsWeb ? 150 : 120,
                      height: kIsWeb ? 150 : 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage(
                          placeholder: const AssetImage(
                              'assets/images/map.png'), // Placeholder image
                          image: NetworkImage(data.imageUrl ?? ''),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Title: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: data.title),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Status: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                !data.isVerified
                                    ? const TextSpan(
                                        text: 'Unverfied',
                                        style: TextStyle(color: Colors.grey))
                                    : TextSpan(
                                        text: data.status == 'ongoing'
                                            ? 'Ongoing'
                                            : 'Completed',
                                        style: TextStyle(
                                          color: data.status == 'completed'
                                              ? Colors.green
                                              : Colors.orange,
                                        )),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Type: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: data.type),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Address: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: data.address,
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            overflow: TextOverflow.fade,
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Landmark: ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: data.landmark,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: RichText(
                              overflow: TextOverflow.fade,
                              maxLines: 3,
                              text: TextSpan(
                                style: const TextStyle(color: Colors.black),
                                children: <TextSpan>[
                                  const TextSpan(
                                      text: 'Description: ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: data.description),
                                ],
                              ),
                            ),
                          ),
                          if (data.status == 'pending')
                            MaterialButton(
                              color: Colors.black,
                              onPressed: () {
                                Navigator.push(
                                  scaffoldKey.currentState!.context,
                                  MaterialPageRoute(
                                      builder: (scaffoldKey) => ComplaintForm(
                                            report: data,
                                            additionalHeight: 150,
                                          )),
                                );
                              },
                              child: const Text(
                                "Repost",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
      markerId: markerId,
      position: LatLng(data.position['geopoint'].latitude,
          data.position['geopoint'].longitude),
      infoWindow: InfoWindow(
        title: data.type,
        snippet: data.address,
      ),
    );
    setState(() {
      _markers[markerId] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider);
    ref.watch(reportProviderProvider);

    return Scaffold(
      key: scaffoldKey,
      appBar: kIsWeb
          ? null
          : AppBar(
              title: const Text(
                "Location Tags",
                style: TextStyle(color: secondaryColor),
              ),
              centerTitle: true,
              actions: [
                user!.isAnonymous
                    ? Consumer(
                        builder: (context, ref, child) {
                          return IconButton(
                              onPressed: () {
                                ref
                                    .read(authControllerProvider.notifier)
                                    .signOut();
                              },
                              icon: const Icon(Icons.exit_to_app));
                        },
                      )
                    : const SizedBox()
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
      floatingActionButton: !user!.isAnonymous
          ? const SizedBox()
          : FloatingActionButton.extended(
              onPressed: () {
                //TODO: try to add
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Tag a hole"),
                        content: SizedBox(
                          height: MediaQuery.of(context).size.height / 6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                  'In order to tag a hole you must be a registered user.'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Consumer(
                                    builder: (context, ref, child) {
                                      return MaterialButton(
                                        color: secondaryColor,
                                        onPressed: () async {
                                          Navigator.pushNamed(
                                              context, '/citizenSignup');
                                        },
                                        child: const Text(
                                          "Register Now",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
              label: const Icon(Icons.report)),
    );
  }
}
