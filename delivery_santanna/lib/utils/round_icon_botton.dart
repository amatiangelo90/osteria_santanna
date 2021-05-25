import 'package:flutter/material.dart';

import 'costants.dart';

class RoundIconButton extends StatelessWidget {
  RoundIconButton(
      {@required this.icon, @required this.function, this.onLongfunction});

  final IconData icon;
  final Function function;
  final Function onLongfunction;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onLongPress: onLongfunction,
      elevation: 0.0,
      child: Icon(icon, color: Colors.white,),
      onPressed: function,
      constraints: BoxConstraints.tightFor(width: 40.0, height: 40.0),
      shape: CircleBorder(),
      fillColor: OSTERIA_GOLD,
    );
  }
}