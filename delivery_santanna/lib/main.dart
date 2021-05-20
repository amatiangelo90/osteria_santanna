import 'package:delivery_santanna/screens/dash_menu/add_new_product.dart';
import 'package:delivery_santanna/screens/dash_menu/admin_console_screen_menu.dart';
import 'package:delivery_santanna/screens/dash_menu/manage_menu_item_page.dart';
import 'package:delivery_santanna/screens/menu/a_la_carte_screen.dart';
import 'package:delivery_santanna/screens/delivery/home_page_screen.dart';
import 'package:delivery_santanna/screens/dash_delivery//manage_item_page.dart';
import 'package:delivery_santanna/screens/menu_choose_screen.dart';
import 'package:delivery_santanna/screens/splash_screen_santanna.dart';
import 'package:delivery_santanna/screens/dash_delivery//admin_console_screen.dart';
import 'package:delivery_santanna/screens/dash_delivery//add_new_product.dart';
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
                  AdminConsoleMenuScreen.id : (context) => AdminConsoleMenuScreen(),
                  AddNewProductCarteScreen.id : (context) => AddNewProductCarteScreen(),
                  ManageItemPage.id : (context) => ManageItemPage(),
                  AddNewProductScreen.id : (context) => AddNewProductScreen(),
                  MenuChooseScreen.id : (context) => MenuChooseScreen(),
                  ALaCarteMenuScreen.id : (context) => ALaCarteMenuScreen(),
                  ManageMenuItemPage.id : (context) => ManageMenuItemPage(),
                }
            );
          }
          return CircularProgressIndicator();
        }
    );

  }
}