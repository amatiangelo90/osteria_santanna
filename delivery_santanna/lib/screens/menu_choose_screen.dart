import 'package:delivery_santanna/screens/menu/a_la_carte_screen.dart';
import 'package:delivery_santanna/screens/delivery/home_page_screen.dart';
import 'package:flutter/material.dart';

class MenuChooseScreen extends StatefulWidget {

  static String id = 'menu_choose';
  @override
  _MenuChooseScreenState createState() => _MenuChooseScreenState();
}

class _MenuChooseScreenState extends State<MenuChooseScreen> {
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Flexible(
              flex: 3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                      child: GestureDetector(
                        child: Text('Delivery Menù', style: TextStyle(color: Colors.black, fontSize: 17.0, fontFamily: 'LoraFont'),),
                        onTap: ()=> Navigator.pushNamed(context, OsteriaSantAnnaHomePage.id),

                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                      child: GestureDetector(
                        child: Text('A\' la Carte Menù', style: TextStyle(color: Colors.black, fontSize: 17.0, fontFamily: 'LoraFont'),),
                        onTap: ()=> Navigator.pushNamed(context, ALaCarteMenuScreen.id),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
