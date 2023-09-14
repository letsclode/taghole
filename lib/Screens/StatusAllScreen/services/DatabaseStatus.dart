import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

getStatusList() async {
  return await FirebaseFirestore.instance.collection('reports').get();
}

navigateme(String lat, String long) async {
  String url = "https://www.google.com/maps?q=$lat,$long";
  if (await canLaunchUrl(Uri(path: url))) {
    await launchUrl(Uri(path: url));
  } else {
    throw 'Could not launch $url';
  }
}

seepothole(String downloadurl) async {
  String url = downloadurl;
  if (await canLaunchUrl(Uri(path: url))) {
    await launchUrl(Uri(path: url));
  } else {
    throw 'Could not launch $url';
  }
}
