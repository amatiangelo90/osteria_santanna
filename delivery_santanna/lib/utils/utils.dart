
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
    DateTime.utc(2021,3 ,19 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,3 ,20 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,3 ,21 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,3 ,26 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,3 ,27 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,3 ,28 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,4 ,2 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,4 ,3 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,4 ,4 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,4 ,9 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,4 ,10 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,4 ,11 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,4 ,16 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,4 ,17 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,4 ,18 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,4 ,23 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,4 ,24 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,4 ,25 ,0 ,0 ,0 ,0 ,0),
    ];
  }

  static String getWeekDay(int weekday) {
    switch(weekday){
      case 1:
        return "Lunedi";
      case 2:
        return "Martedi";
      case 3:
        return "Mercoledi";
      case 4:
        return "Gioverdi";
      case 5:
        return "Venerdi";
      case 6:
        return "Sabato";
      case 7:
        return "Domenica";
    }
    return "";
  }

  static String getMonthDay(int month) {
    switch(month){
      case 1:
        return "Gennaio";
      case 2:
        return "Febbraio";
      case 3:
        return "Marzo";
      case 4:
        return "Aprile";
      case 5:
        return "Maggio";
      case 6:
        return "Giugno";
      case 7:
        return "Luglio";
      case 8:
        return "Agosto";
      case 9:
        return "Settembre";
      case 10:
        return "Ottobre";
      case 11:
        return "Novembre";
      case 12:
        return "Dicembre";
    }
    return "";
  }
}