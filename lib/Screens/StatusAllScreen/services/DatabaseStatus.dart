import 'package:url_launcher/url_launcher.dart';

navigateme(String lat, String long) async {
  String url = "https://www.google.com/maps?q=$lat,$long";
  if (await canLaunchUrl(Uri(path: url))) {
    await launchUrl(Uri(path: url));
  } else {
    throw 'Could not launch $url';
  }
}

seepothole(String downloadurl) async {
  if (await canLaunchUrl(Uri(path: downloadurl))) {
    await launchUrl(Uri(path: downloadurl));
  } else {
    throw 'Could not launch $downloadurl';
  }
}
