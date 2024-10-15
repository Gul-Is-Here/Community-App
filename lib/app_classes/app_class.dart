import 'package:url_launcher/url_launcher.dart';

class AppClass {
  Future<void> launchURL(String url) async {
    if (url.isEmpty) {
      throw 'Invalid URL';
    }

    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri,
          mode: LaunchMode.externalApplication); // Opens in external browser
    } else {
      throw 'Could not launch $url';
    }
  }
}
