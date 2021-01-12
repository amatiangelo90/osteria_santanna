
import 'package:delivery_santanna/screens/home_page_screen.dart';
import 'package:delivery_santanna/screens/splash_screen_santanna.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Osteria Delivery',
        initialRoute: SplashScreenSantAnna.id,
        routes:{
          SplashScreenSantAnna.id : (context) => SplashScreenSantAnna(),
          OsteriaSantAnnaHomePage.id : (context) => OsteriaSantAnnaHomePage(),
        }
    );
  }
}