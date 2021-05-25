import 'dart:async';

import 'package:flutter/material.dart';
import 'package:delivery_santanna/screens/menu/a_la_carte_screen.dart';

class SplashScreenSantAnna extends StatefulWidget {
  static String id = 'homeosteria';
  @override
  _SplashScreenSantAnnaState createState() => _SplashScreenSantAnnaState();
}

class _SplashScreenSantAnnaState extends State<SplashScreenSantAnna> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Image.asset('images/donna.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 3500), ()=> Navigator.pushNamed(context, ALaCarteMenuScreen.id));
    /*Timer(Duration(milliseconds: 3500), ()=> Navigator.pushNamed(context, OsteriaSantAnnaHomePage.id));*/
  }

}