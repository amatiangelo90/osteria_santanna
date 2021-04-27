import 'package:delivery_santanna/dao/crud_model.dart';
import 'package:delivery_santanna/models/product.dart';
import 'package:delivery_santanna/screens/admin_console_screen.dart';
import 'package:delivery_santanna/utils/costants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ManageItemPage extends StatefulWidget {

  static String id = 'manage_page';

  final Product product;
  final String menuType;

  ManageItemPage({@required this.product, @required this.menuType});

  @override
  _ManageItemPageState createState() => _ManageItemPageState();
}

class _ManageItemPageState extends State<ManageItemPage> {

  Product productBase;

  List<Category> _categoryPicker;
  List<DropdownMenuItem<Category>> _dropdownCategory;
  Category _selectedCategory;

  TextEditingController _nameController;
  TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    productBase = this.widget.product;
    _nameController = TextEditingController(text: productBase.name);
    _priceController = TextEditingController(text: productBase.price.toString());
    _categoryPicker = Category.getCategoryList(this.widget.menuType);
    _dropdownCategory = buildDropdownSlotPickup(_categoryPicker);

    _selectedCategory = _dropdownCategory[getIndexByCategory(productBase.category, this.widget.menuType)].value;
  }

  onChangeDropTimeSlotPickup(Category currentCategory) {
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
                                /*inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                ],*/
                                controller: _priceController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Prezzo',
                                ),
                              ),
                            ),
                          ),
                        ),
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
                                      onChanged: onChangeDropTimeSlotPickup,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
                                  CRUDModel crudModel = CRUDModel(this.widget.menuType);
                                  productBase.price = double.parse(_priceController.value.text);
                                  productBase.name = _nameController.value.text;
                                  productBase.category = _selectedCategory.cat;
                                  await crudModel.updateProduct(productBase, productBase.id);
                                  Navigator.pushNamed(context, AdminConsoleScreen.id);
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
                                        content: Text("Eliminare  " + productBase.name + " ?"),
                                        actions: <Widget>[
                                          FlatButton(
                                              onPressed: () async {
                                                CRUDModel crudModel = CRUDModel(this.widget.menuType);
                                                await crudModel.removeProduct(productBase.id);
                                                Navigator.pushNamed(context, AdminConsoleScreen.id);
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
    }



  }
}