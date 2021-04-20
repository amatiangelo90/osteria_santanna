class OrderStore {

  final String id;
  final String name;
  final String order;
  final String date;
  final String total;


  OrderStore(
      this.id,
      this.name,
      this.order,
      this.date,
      this.total
      );


  toJson(){

    return {
      'id' : id,
      'name' : name,
      'message': order,
      'date': date,
      'total' : total + ' €'
    };
  }


  @override
  String toString() {
    return this.order;
  }

}