import 'package:delivery_santanna/dao/crud_model.dart';
import 'package:url_launcher/url_launcher.dart';

class HttpService {

  static sendMessage(
      String number,
      String message,
      String name,
      String total,
      String time,
      String order) async {

      var url = 'https://api.whatsapp.com/send/?phone=$number&text=$message';
      print(url);

      try{
        CRUDModel crudModel = CRUDModel('orders');

        await crudModel.addOrder(name,
        total,
        time,
        order);

      }catch(e){
        print('Exception Crud' + e.toString());
      }

      try{
          await launch(url);
      }catch(e){
        print('Exception' + e.toString());
      }

  }
}
