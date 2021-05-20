import 'package:delivery_santanna/dao/crud_model.dart';
import 'package:delivery_santanna/models/product.dart';
import 'package:delivery_santanna/utils/costants.dart';
import 'package:delivery_santanna/utils/round_icon_botton.dart';
import 'package:delivery_santanna/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'admin_console_screen_menu.dart';


class ManageMenuItemPage extends StatefulWidget {

  static String id = 'manage_menu_page';

  final Product product;
  final String menuType;

  ManageMenuItemPage({@required this.product, @required this.menuType});

  @override
  _ManageMenuItemPageState createState() => _ManageMenuItemPageState();
}

class _ManageMenuItemPageState extends State<ManageMenuItemPage> {
  double _price;
  Product productBase;

  List<Category> _categoryPicker;
  List<DropdownMenuItem<Category>> _dropdownCategory;
  Category _selectedCategory;

  TextEditingController _nameController;
  TextEditingController _ingredientsController;

  @override
  void initState() {
    super.initState();
    productBase = this.widget.product;
    _nameController = TextEditingController(text: productBase.name);
    _ingredientsController = TextEditingController(text: Utils.getIngredientsFromProductALaCarte(productBase));
    _categoryPicker = Category.getCategoryList(this.widget.menuType);
    _price = productBase.price;

    _categoryPicker = Category.getCategoryList(this.widget.menuType);
    _dropdownCategory = buildDropdownSlotPickup(_categoryPicker);
    _selectedCategory = _dropdownCategory[getIndexByCategory(productBase.category, this.widget.menuType)].value;
  }


  onChangeDropCategory(Category currentCategory) {
    setState(() {
      _selectedCategory = currentCategory;
    });
  }

  List<DropdownMenuItem<Category>> buildDropdownSlotPickup(List category) {
    List<DropdownMenuItem<Category>> items = [];
    for (Category category in category) {
      items.add(
        DropdownMenuItem(
          value: category,
          child: Center(child: Text(category.cat, style: TextStyle(color: Colors.black, fontSize: 16.0,),)),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(productBase.name,  style: TextStyle(fontSize: 20.0, color: Colors.white),),
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 0.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                          child: Center(
                            child: Card(
                              child: TextField(
                                controller: _nameController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Nome',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                          child: Center(
                            child: Card(
                              child: TextField(
                                controller: _ingredientsController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Ingredienti',
                                ),
                                maxLines: 4,
                              ),
                            ),
                          ),
                        ),
                        Text('*Ricorda di dividere la lista ingredienti con la virgola (,)', style: TextStyle(fontSize: 10),),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 3.0),
                          child: Center(
                            child: Card(
                              borderOnForeground: true,
                              elevation: 1.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      value: _selectedCategory,
                                      items: _dropdownCategory,
                                      onChanged: onChangeDropCategory,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RoundIconButton(
                                icon: FontAwesomeIcons.minus,
                                function: () {
                                  setState(() {
                                    if(_price > 1)
                                      _price = _price - 0.5;
                                  });
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(_price.toString() + ' €', style: TextStyle(fontSize: 20.0,),),
                              ),
                              RoundIconButton(
                                icon: FontAwesomeIcons.plus,
                                function: () {
                                  setState(() {
                                    _price = _price + 0.5;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: [
                            RaisedButton(
                                child: Text('Disponibile',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                color: productBase.available == 'true' ? Colors.blueAccent : Colors.grey,
                                elevation: 5.0,
                                onPressed: () async {
                                  updateProductBase('true');

                                }
                            ),
                            RaisedButton(
                                child: Text('Esaurito',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                color: productBase.available == 'false' ? Colors.red : Colors.grey,
                                elevation: 5.0,
                                onPressed: () async {
                                  updateProductBase('false');
                                }
                            ),
                            RaisedButton(
                                child: Text('Novità',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                color: productBase.available == 'new' ? Colors.green : Colors.grey,
                                elevation: 5.0,
                                onPressed: () async {
                                  updateProductBase('new');
                                }
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.all(23.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                              RaisedButton(
                                child: Text('Aggiorna',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                color: Colors.green,
                                elevation: 5.0,
                                onPressed: () async {
                                  print('Update menu [' + this.widget.menuType + ']');
                                  print('Update menu [' + productBase.category + ']');
                                  CRUDModel crudModel = CRUDModel(this.widget.menuType);
                                  productBase.price = _price;
                                  productBase.name = _nameController.value.text;
                                  productBase.listIngredients = _ingredientsController.value.text.split(",");
                                  await crudModel.updateProduct(productBase, productBase.id);
                                  Navigator.pushNamed(context, AdminConsoleMenuScreen.id);
                                },
                              ),
                              RaisedButton(
                                child: Text('Elimina',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                                color: Colors.redAccent,
                                elevation: 5.0,
                                onPressed: ()  async {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Conferma"),
                                        content: Text("Eliminare " + productBase.name + " ?"),
                                        actions: <Widget>[
                                          FlatButton(
                                              onPressed: () async {
                                                print('Product base id : ' + productBase.id);
                                                CRUDModel crudModel = CRUDModel(this.widget.menuType);
                                                await crudModel.removeProduct(productBase.id);
                                                Navigator.pushNamed(context, AdminConsoleMenuScreen.id);
                                              },
                                              child: const Text("Cancella")
                                          ),
                                          FlatButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text("Indietro"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Column(
                              children: [
                                Text('Codice prodotto'),
                                Text('[' + productBase.id + ']'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  int getIndexByCategory(String category, String menuType) {
    switch(menuType){
      case sushiMenuType:
        switch(category){
          case categoryTartare:
            return 1;
          case categoryNigiri:
            return 2;
          case categoryRoll:
            return 3;
          case categoryPoke:
            return 4;
          case categoryTempura:
            return 5;
          case categoryCryspyRice:
            return 5;
          default:
            return 0;
        }
        break;
      case fromKitchenMenuType:

        switch(category){
          case categoryFromKitchen:
            return 1;
          default:
            return 0;
        }
        break;
      case dessertMenuType:
        switch(category){
          case categoryDessert:
            return 1;
          default:
            return 0;
        }
        break;
      case wineMenuType:
        switch(category){
          case categoryWhiteWine:
            return 1;
          case categoryRedWine:
            return 2;
          case categoryBollicineWine:
            return 3;
          case categoryRoseWine:
            return 4;
          default:
            return 0;
        }
        break;
    }
  }

  void updateProductBase(String state) {
    setState(() {
      productBase.available = state;
    });
  }


}

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