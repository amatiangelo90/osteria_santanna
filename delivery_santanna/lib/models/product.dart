class Product {

  final String id;
  final String image;
  final String name;
  final List<dynamic> listIngredients;
  final List<dynamic> listAllergens;
  final List<dynamic> changes;
  final double price;
  final int discountApplied;
  final String category;
  final String available;

  Product(
      this.id,
      this.name,
      this.image,
      this.listIngredients,
      this.listAllergens,
      this.price,
      this.discountApplied,
      this.changes,
      this.category,
      this.available);

  factory Product.fromJson(dynamic json){
    return Product(
      json['id'] as String,
      json['name'] as String,
      json['image'] as String,
      json['ingredients'] as List,
      json['allergens'] as List,
      json['price'] as double,
      json['discountApplied'] as int,
      json['changes'] as List,
      json['category'] as String,
      json['available'] as String,
    );
  }

  factory Product.fromMap(Map snapshot,String id){
    return Product(
      id,
      snapshot['name'] as String,
      snapshot['image'] as String,
      snapshot['ingredients'] as List,
      snapshot['allergens'] as List,
      snapshot['price'] as double,
      snapshot['discountApplied'] as int,
      snapshot['changes'] as List,
      snapshot['category'] as String,
      snapshot['available'] as String,
    );
  }

  toJson(){

    return {
    'id' : id,
    'name': name,
    'image': image,
    'ingredients' : listIngredients,
    'allergens' : listAllergens,
    'price' : price,
    'discountApplied' : discountApplied,
    'changes' : changes,
    'category' : category,
    'available' : available
    };

  }


  @override
  String toString() {
    return this.name.toString();
  }

}