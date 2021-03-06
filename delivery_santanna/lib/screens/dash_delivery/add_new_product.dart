import 'package:delivery_santanna/dao/crud_model.dart';
import 'package:delivery_santanna/models/product.dart';
import 'package:delivery_santanna/screens/dash_delivery/admin_console_screen.dart';
import 'package:delivery_santanna/utils/costants.dart';
import 'package:delivery_santanna/utils/round_icon_botton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class AddNewProductScreen extends StatefulWidget {

  static String id = 'addproduct_page';

  @override
  _AddNewProductScreenState createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {

  Product productBase;
  double _price;
  TextEditingController _nameController;

  Category _selectedCategory;
  List<Category> _categoryPicker;
  List<DropdownMenuItem<Category>> _dropdownCategory;


  @override
  void initState() {
    super.initState();
    productBase = Product('', '', 'images/sushi/default_sushi.jpg', ["-"], ["-"], 0.0, 0, ["-"], '', 'true');
    _nameController = TextEditingController(text: productBase.name);
    _price = 0.0;
    _categoryPicker = Category.getCategoryList();
    _dropdownCategory = buildDropdownSlotPickup(_categoryPicker);
    _selectedCategory = _dropdownCategory[0].value;

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
          child: Center(child: Text(category.menuType, style: TextStyle(color: Colors.black, fontSize: 16.0,),)),
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
          title: Text('Aggiungi Nuovo Piatto',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
          backgroundColor: Colors.black,
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
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  RoundIconButton(
                                    icon: FontAwesomeIcons.minus,
                                    function: () {
                                      setState(() {
                                        if(_price > 5)
                                          _price = _price - 5;
                                      });
                                    },
                                  ),
                                  Text('- 5')
                                ],
                              ),
                              Column(
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
                                  Text('- 0.5')
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(_price.toString() + ' €', style: TextStyle(fontSize: 20.0,),),
                                    Text('')
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  RoundIconButton(
                                    icon: FontAwesomeIcons.plus,
                                    function: () {
                                      setState(() {
                                        _price = _price + 0.5;
                                      });
                                    },
                                  ),
                                  Text('+ 0.5')
                                ],
                              ),
                              Column(
                                children: [
                                  RoundIconButton(
                                    icon: FontAwesomeIcons.plus,
                                    function: () {
                                      setState(() {
                                        if(_price < 200)
                                          _price = _price + 5;
                                      });
                                    },
                                  ),
                                  Text('+ 5')
                                ],
                              ),
                            ],
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        ),

                        RaisedButton(
                            child: Text('Crea Prodotto',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
                            color: Colors.teal.shade800,
                            elevation: 5.0,
                            onPressed: () async {
                              if(_selectedCategory.menuType != 'Scegli Tipo Menu'){
                                print('Creazione Prodotto');
                                CRUDModel crudModel = CRUDModel(_selectedCategory.menuType);
                                productBase.name = _nameController.value.text;
                                productBase.price = _price;
                                print(productBase.toJson());
                                await crudModel.addProduct(productBase);
                                Navigator.pushNamed(context, AdminConsoleScreen.id);
                              }else{
                                print('Maccaron');
                              }

                            }
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
  String menuType;

  Category(this.id, this.menuType);

  static List<Category> getCategoryList() {

    return <Category>[
      Category(1, 'Scegli Tipo Menu'),
      Category(2, sushiMenuType),
      Category(3, fromKitchenMenuType),
      Category(4, dessertMenuType),
      Category(5, wineMenuType),
    ];

  }
}