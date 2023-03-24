import 'package:url_launcher/url_launcher_string.dart';

void openGoogleTranslateInBrowser(String word) async {
  final address =
      "https://translate.google.com/?sl=en&tl=fa&text=$word&op=translate";

  if (!await launchUrlString(address)) {
    throw 'Could not launch $address';
  }
}
