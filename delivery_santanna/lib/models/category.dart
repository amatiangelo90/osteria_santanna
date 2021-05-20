import 'package:delivery_santanna/utils/costants.dart';

class Category {
  int id;
  String cat;

  Category(this.id, this.cat);

  static List<Category> getCategoryList(String menuType) {
    print(menuType);
    switch(menuType){
      case sushiMenuType:
        return <Category>[
          Category(1, 'Scegli Categoria'),
          Category(2, categoryTartare),
          Category(3, categoryNigiri),
          Category(4, categoryRoll),
          Category(5, categoryPoke),
          Category(6, categoryTempura),
          Category(7, categoryCryspyRice),
        ];
        break;
      case fromKitchenMenuType:
        return <Category>[
          Category(1, 'Scegli Categoria'),
          Category(2, categoryFromKitchen),
        ];
        break;
      case dessertMenuType:
        return <Category>[
          Category(1, 'Scegli Categoria'),
          Category(2, categoryDessert),
        ];
        break;
      case wineMenuType:
        return <Category>[
          Category(1, 'Scegli Categoria'),
          Category(2, categoryWhiteWine),
          Category(3, categoryRedWine),
          Category(4, categoryBollicineWine),
          Category(5, categoryRoseWine),
        ];
        break;
      default:
        return <Category>[
          Category(1, 'Scegli Categoria'),
          Category(2, categoryWhiteWine),
        ];
    }
  }
}