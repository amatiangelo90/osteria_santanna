import 'package:url_launcher/url_launcher.dart';

class HttpService {

  static sendMessage(String number, String message) async {

      var url = 'https://api.whatsapp.com/send/?phone=$number&text=$message';
      print(url);
      try{
          await launch(url);
      }catch(e){
        print('Exception' + e.toString());
      }

  }
}
