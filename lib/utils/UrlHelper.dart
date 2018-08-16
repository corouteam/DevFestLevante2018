import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url,
      forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}