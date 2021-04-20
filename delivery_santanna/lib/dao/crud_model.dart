import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_santanna/models/product.dart';
import 'package:delivery_santanna/models/order_store.dart';

import 'dao.dart';

class CRUDModel{

  final String collection;

  Dao _dao;
  List<Product> products;

  CRUDModel(this.collection){
    _dao = Dao(this.collection);
  }

  Future<List<Product>> fetchProducts() async {
    var result = await _dao.getDataCollection();

    products = result.docs
        .map((doc) => Product.fromMap(doc.data(), doc.id))
        .toList();

    return products;
  }

  Stream<QuerySnapshot> fetchProductsAsStream() {
    return _dao.streamDataCollection();
  }

  Future<Product> getProductById(String id) async {
    var doc = await _dao.getDocumentById(id);
    return  Product.fromMap(doc.data(), doc.id) ;
  }


  Future removeProduct(String id) async{
    await _dao.removeDocument(id) ;
    return ;
  }
  Future updateProduct(Product data, String id) async{
    await _dao.updateDocument(data.toJson(), id) ;
    return ;
  }

  Future addProduct(Product data) async{

    await _dao.addDocument(data.toJson());

    return ;

  }

  Future addOrder(
     String name,
     String total,
     String time,
     String order) async {

    OrderStore orderStore = OrderStore(
        Random.secure().nextInt(40000000).toString(),
        name,
        order,
        time,
      total);

    await _dao.addDocument(orderStore.toJson());
    return ;
  }
}