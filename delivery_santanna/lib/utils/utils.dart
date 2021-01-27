
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

  static List<DateTime> getAvailableData(){
    return [DateTime.utc(2021,1 ,29 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,1 ,30 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,1 ,31 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,2 ,5 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,2 ,6 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,2 ,7 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,2 ,12 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,2 ,13 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,2 ,14 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,2 ,19 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,2 ,20 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,2 ,21 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,2 ,26 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,2 ,27 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,2 ,28 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,3 ,5 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,3 ,6 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,3 ,7 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,3 ,12 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,3 ,13 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,3 ,14 ,0 ,0 ,0 ,0 ,0),
    ];
  }
}