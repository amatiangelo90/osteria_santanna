import 'package:delivery_santanna/models/product.dart';
import 'package:flutter/material.dart';

class Cart{

  Product product;
  int numberOfItem;

  Cart({@required this.product,
    @required this.numberOfItem});

  @override
  String toString() {
    return 'Cart : ' + this.product.toString() + ' x ' + this.numberOfItem.toString();
  }

}