import 'package:flutter/material.dart';
import 'package:santanna_app/models/product.dart';

class Cart{

  Product product;
  int numberOfItem;

  Cart({@required this.product,
    @required this.numberOfItem});
}