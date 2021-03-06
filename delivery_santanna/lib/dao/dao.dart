import 'package:cloud_firestore/cloud_firestore.dart';

class Dao{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionPath;
  CollectionReference _collectionReference;

  Dao(this.collectionPath) {
    _collectionReference = _db.collection(collectionPath);
  }

  Future<QuerySnapshot> getDataCollection(){
    return _collectionReference.orderBy('category').get();
  }

  Future<QuerySnapshot> getCalendarDataCollection(){
    return _collectionReference.get();
  }

  Future<QuerySnapshot> getOrdersStoreCollection() {
    return _collectionReference.orderBy('address',descending: false).orderBy('hourPickupDelivery', descending: false).get();
  }

  Stream<QuerySnapshot> streamDataCollection(){
    return _collectionReference.get().asStream();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return _collectionReference.doc(id).get();
  }

  Future<void> removeDocument(String id){
    return _collectionReference.doc(id).delete();
  }
  Future<DocumentReference> addDocument(Map data) {

    return _collectionReference.add(data);
  }
  Future<void> updateDocument(Map data , String id) {
    return _collectionReference.doc(id).update(data) ;
  }
}