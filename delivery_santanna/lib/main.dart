import 'package:delivery_santanna/screens/home_page_screen.dart';
import 'package:delivery_santanna/screens/manage_item_page.dart';
import 'package:delivery_santanna/screens/splash_screen_santanna.dart';
import 'package:delivery_santanna/screens/admin_console_screen.dart';
import 'package:delivery_santanna/screens/add_new_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot){
          if(snapshot.hasError){
            print(snapshot.error);
            return Container(color: Colors.redAccent,);
          }
          if(snapshot.connectionState == ConnectionState.done){
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Osteria Delivery',
                initialRoute: SplashScreenSantAnna.id,
                routes:{
                  SplashScreenSantAnna.id : (context) => SplashScreenSantAnna(),
                  OsteriaSantAnnaHomePage.id : (context) => OsteriaSantAnnaHomePage(),
                  AdminConsoleScreen.id : (context) => AdminConsoleScreen(),
                  ManageItemPage.id : (context) => ManageItemPage(),
                  AddNewProductScreen.id : (context) => AddNewProductScreen(),
                }
            );
          }
          return CircularProgressIndicator();
        }
    );

  }
}