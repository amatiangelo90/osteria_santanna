import 'package:delivery_santanna/models/product.dart';
import 'package:flutter/material.dart';

class Cart{

  Product product;
  int numberOfItem;
  List<String> changes;

  Cart({
    this.product,
    this.numberOfItem,
    this.changes}
    );

  Map<String, dynamic> toJson() => {
    'product': product,
    'numberOfItem': numberOfItem,
    'changes': changes
  };

  factory Cart.fromMap(Map cartMap){
    return Cart(
        product: cartMap['product'],
        numberOfItem: cartMap['numberOfItem'],
        changes: cartMap['changes']
    );
  }

}