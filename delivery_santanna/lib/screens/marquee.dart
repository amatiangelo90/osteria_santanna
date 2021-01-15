import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class Marquee_class extends StatefulWidget {
  static String id = 'marq';
  @override
  _Marquee_classState createState() => _Marquee_classState();
}

class _Marquee_classState extends State<Marquee_class> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marquee',
      home: Scaffold(
        backgroundColor: Colors.deepOrange,
        body: ListView(
          padding: EdgeInsets.only(top: 50.0),
          children: [
            _buildMarquee(),
          ].map(_wrapWithStuff).toList(),
        ),
      ),
    );
  }

  Widget _buildMarquee() {
    return Marquee(text: 'There once was a boy who told this story about a boy: ',
    );
  }

  Widget _wrapWithStuff(Widget child) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Container(height: 50.0, color: Colors.white, child: child),
    );
  }
}