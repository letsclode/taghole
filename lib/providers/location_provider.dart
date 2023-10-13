import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:taghole/models/location_result.dart';

final locationCNP = ChangeNotifierProvider<LocationChangeNotifier>(
    (ref) => LocationChangeNotifier());

class LocationChangeNotifier extends ChangeNotifier {
  List<Predictions> searchLocations = [];

  final String? apiKey = dotenv.env['GOOGLE_MAP_API_KEY'];

  Future<void> fetchAddress(String query) async {
    if (query != '') {
      final parseQuery = Uri.encodeFull(query);
      final Uri url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$parseQuery&components=country:ph&key=$apiKey&sessiontoken=1234567890',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);

        final searchLocationResult =
            SearchLocationResult.fromJson(decodedResponse);

        searchLocations = searchLocationResult.predictions;
      }
    } else {
      searchLocations = [];
    }

    notifyListeners();
  }

  Future<LatLng?> getLatLongByPlaceId(String placeId) async {
    final Uri url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      final location = decodedResponse['result']['geometry']['location'];

      final locationLatLng =
          LatLng(location['lat'] as double, location['lng'] as double);

      return locationLatLng;
    }
    return null;
  }

  void clearSearchLocation() {
    searchLocations = [];
    notifyListeners();
  }
}
