
import 'package:delivery_santanna/models/product.dart';

class Utils{

  static getIngredientsFromProduct(Product product){
    String ingredientString = "";
    List<dynamic> dataIngredients = product.listIngredients;
    dataIngredients.forEach((ingredient) {
      ingredientString = ingredientString + ingredient + " | ";
    });
    return ingredientString.substring(0, ingredientString.length -2);


  }

  static getAllergensFromProduct(Product product){
    String allergensString = "";
    List<dynamic> dataAllergens = product.listAllergens;
    dataAllergens.forEach((allergen) {
      allergensString = allergensString + allergen + " | ";
    });
    return allergensString.substring(0, allergensString.length -2);
  }
}