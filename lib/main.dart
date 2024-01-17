import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taghole/Screens/VisitorsPage/visitors_screen.dart';
import 'package:taghole/constant/color.dart';
import 'package:taghole/firebase_options.dart';

import 'Screens/Authentication/views/citizenSignup.dart';
import 'Screens/Authentication/views/home.dart';
import 'Screens/Authentication/welcome_screen.dart';
import 'adminweb/providers/report/report_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotifications =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await FlutterConfig.loadEnvVariables();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  flutterLocalNotifications
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  await _initializeLocalNotifications();

  return runApp(const ProviderScope(child: MyApp()));
}

Future<double> _getDistanceToPinnedLocation(
    double pinnedLatitude, double pinnedLongitude) async {
  final currentLocation = await Geolocator.getCurrentPosition();
  final pinnedLocation = LatLng(pinnedLatitude, pinnedLongitude);
  final distance = Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      pinnedLocation.latitude,
      pinnedLocation.longitude);
  return distance;
}

Future<bool> _checkLocationPermission() async {
  final locationAccess = await Permission.location.status;
  if (locationAccess != PermissionStatus.granted) {
    final permissionGranted = await Permission.location.request();
    return permissionGranted == PermissionStatus.granted;
  } else {
    return true;
  }
}

Future _initializeLocalNotifications() async {
  try {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  } catch (e) {
    print(e);
  }
}

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  if (notificationResponse.payload != null) {
    debugPrint('notification payload: $payload');
  }
}

Timer? distanceTimer;
// List<Map<String, double>> pinnedLocations = [];

Future<void> stopDistanceMonitoring() async {
  distanceTimer?.cancel();
  distanceTimer = null;
}

Future<void> _showNearbyLocationNotification() async {
  try {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'nearby_location',
      'Nearby Location Alert',
      channelDescription: 'Notifies when approaching a pinned location.',
      priority: Priority.high,
      importance: Importance.high,
      playSound: true,
      largeIcon: DrawableResourceAndroidBitmap('app_icon'),
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );
    await flutterLocalNotifications.show(
        0,
        'ALERT',
        'POTHOLE DETECTED IN YOUR VICINITY. DRIVE CAUTIOUSLY ANF BE AWARE OF ROA CONDITIONS. STAY SAFE ON THE ROAD!',
        notificationDetails);
  } catch (e) {
    print('_showNearbyLocationNotification $e');
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  Future<void> startDistanceMonitoringTimer() async {
    if (await _checkLocationPermission()) {
      distanceTimer =
          Timer.periodic(const Duration(seconds: 30), (timer) async {
        List pinnedLocations =
            await ref.read(reportProviderProvider.notifier).pinnedLocation();
        for (Map<String, double> location in pinnedLocations) {
          double distance = await _getDistanceToPinnedLocation(
              location['latitude']!, location['longitude']!);

          if (distance <= 500) {
            await _showNearbyLocationNotification();
            break; // Stop processing other locations when one is within range
          }
        }
      });
    }
  }

  @override
  void initState() {
    startDistanceMonitoringTimer();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    stopDistanceMonitoring();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          primary: secondaryColor,
          seedColor: secondaryColor,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Taghole',
      home: const WelcomeScreen(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => const Home(),
        '/citizenSignup': (BuildContext context) => const CitizenSignup(),
        '/visitorsPage': (BuildContext context) => const VisitorsScreen(),
      },
    );
  }
}
