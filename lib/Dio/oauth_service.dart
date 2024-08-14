import 'package:url_launcher/url_launcher.dart';

Future<void> initiateOAuthFlow(String provider) async {
  final String baseUrl = 'https://i11a409.p.ssafy.io:8443/oauth2/authorization/$provider';
  final Uri url = Uri.parse(baseUrl);

  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}