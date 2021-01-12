import 'package:url_launcher/url_launcher.dart';

class HttpService {

  static sendMessage(String number, String message) async {

      var url = 'https://api.whatsapp.com/send/?phone=$number&text=$message';

      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
  }
}
