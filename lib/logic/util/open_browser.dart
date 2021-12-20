import 'package:url_launcher/url_launcher.dart';

void openGoogleTranslateInBrowser(String word) async {
  final url =
      "https://translate.google.com/?sl=en&tl=fa&text=$word&op=translate";
  if (!await launch(url)) {
    throw 'Could not launch $url';
  }
}
