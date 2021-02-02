import 'package:delivery_santanna/models/product.dart';
import 'package:flutter/material.dart';

class Cart{

  Product product;
  int numberOfItem;
  List<String> changes;

  Cart({@required this.product,
    @required this.numberOfItem,
    this.changes});

  @override
  String toString() {
    return 'Cart : ' + this.product.toString() + ' x ' + this.numberOfItem.toString() + ' - Changes: ' + this.changes.toString();
  }

}