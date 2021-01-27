class Product {

  final String image;
  final String name;
  final List<dynamic> listIngredients;
  final List<dynamic> listAllergens;
  final List<dynamic> changes;
  final double price;
  final int discountApplied;
  final String category;
  final String available;

  Product(this.name,
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

  @override
  String toString() {
    return this.name.toString();
  }

}