import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_santanna/models/calendar_manager.dart';
import 'package:delivery_santanna/models/cart.dart';
import 'package:delivery_santanna/models/product.dart';
import 'package:delivery_santanna/models/order_store.dart';
import 'package:delivery_santanna/models/exception_event.dart';

import 'dao.dart';

class CRUDModel{

  final String collection;

  Dao _dao;
  List<Product> products;
  List<CalendarManagerClass> calConfiguList;
  List<OrderStore> customerOrders;

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

  Future<List<CalendarManagerClass>> fetchCalendarConfiguration() async {
    var result = await _dao.getCalendarDataCollection();

    calConfiguList = result.docs
        .map((doc) => CalendarManagerClass.fromMap(doc.data(), doc.id))
        .toList();
    return calConfiguList;
  }

  Future<List<OrderStore>> fetchCustomersOrder() async {

    try{
      var result = await _dao.getOrdersStoreCollection();

      customerOrders = result.docs
          .map((doc) => OrderStore.fromMap(
          doc.data(),
          doc.id,
          buildListCart(doc.data()['cartItemsList'])))
          .toList();

      print(customerOrders);

      return customerOrders.toList();
    }catch(e){
      throw Exception(e);
    }
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

  Future removeCalendar(String id) async{
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

  Future addCalendarConfiguration(CalendarManagerClass calendarManagerClass) async{

    await _dao.addDocument(calendarManagerClass.toJson());
    return ;

  }

  Future addException(
      String name,
      String exception,
      String time) async {

    ExceptionEvent exceptionEv = ExceptionEvent(
        Random.secure().nextInt(40000000).toString(),
        name,
        exception,
        time);

    await _dao.addDocument(exceptionEv.toJson());
    return ;
  }

  Future addOrder(
      String uniqueId,
      String name,
      String total,
      String time,
      List<dynamic> cartItems,
      bool confirmed,
      String typeOrder,
      String datePickupDelivery,
      String hourPickupDelivery,
      String address,
      String city) async {

    OrderStore orderStore = OrderStore(
        '',
        uniqueId,
        name,
        cartItems,
        time,
        total,
        confirmed,
        typeOrder,
        datePickupDelivery,
        hourPickupDelivery,
        city,
        address);

    await _dao.addDocument(orderStore.toJson());
    return ;
  }

  List buildListCart(List element) {

    try{
      List<Cart> listCart = <Cart>[];
      element.forEach((currentItem) {

        currentItem = currentItem.toString().replaceAll('{', '{"');
        currentItem = currentItem.toString().replaceAll('}', '"}');
        currentItem = currentItem.toString().replaceAll(',', '","');
        currentItem = currentItem.toString().replaceAll(':', '":"');
        currentItem = currentItem.toString().replaceAll(' product', 'product');
        currentItem = currentItem.toString().replaceAll(' numberOfItem', 'numberOfItem');
        currentItem = currentItem.toString().replaceAll(' changes', 'changes');
        Map valueMap = json.decode(currentItem);
        listCart.add(Cart(
            product : Product('', valueMap['product'], '', ["-"], ["-"], 0.0, 0, ["-"], '', 'true'),
            numberOfItem: int.parse(valueMap['numberOfItem'].toString().replaceAll(" ", "")),
            changes: null
        ));
      });

      return listCart;
    }catch(e){
      print('Exception: ' + e.toString());
      throw Exception(e);
    }

  }
}