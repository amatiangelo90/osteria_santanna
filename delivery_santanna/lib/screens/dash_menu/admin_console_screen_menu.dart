import 'dart:async';

import 'package:delivery_santanna/dao/crud_model.dart';
import 'package:delivery_santanna/models/cart.dart';
import 'package:delivery_santanna/models/product.dart';
import 'package:delivery_santanna/screens/menu/a_la_carte_screen.dart';
import 'package:delivery_santanna/utils/costants.dart';
import 'package:delivery_santanna/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'add_new_product.dart';
import 'calendar_dash.dart';
import 'calendar_dash_delivery.dart';
import 'manage_menu_item_page.dart';
import 'manage_wine_item.dart';

class AdminConsoleMenuScreen extends StatefulWidget {
  static String id = 'dash_menu';

  @override
  _AdminConsoleMenuScreenState createState() => _AdminConsoleMenuScreenState();
}

class _AdminConsoleMenuScreenState extends State<AdminConsoleMenuScreen> {
  double width;
  double height;
  List<Product> sushiProductList = <Product>[];
  List<Product> startersMenuList = <Product>[];
  List<Product> mainDishProductList = <Product>[];
  List<Product> secondMainDishProductList = <Product>[];
  List<Product> sideDishProductList = <Product>[];
  List<Product> dessertProductList = <Product>[];
  List<Product> wineProductList = <Product>[];
  List<Product> drinkProductList = <Product>[];
  List<Cart> cartProductList = <Cart>[];

  final scaffoldState = GlobalKey<ScaffoldState>();
  String currentMenuType = sushiMenuType;
  int currentMenuItem = 0;

  PageController controller = PageController(
      initialPage: 0);

  void updateMenuType(int menuType){
    switch(menuType){
      case 0:
        currentMenuType = startersMenuType;
        controller.jumpToPage(0);
        break;
      case 1:
        currentMenuType = mainDishMenuType;
        controller.jumpToPage(1);
        break;
      case 2:
        currentMenuType = secondMainDishMenuType;
        controller.jumpToPage(2);
        break;
      case 3:
        currentMenuType = sideDishMenuType;
        controller.jumpToPage(3);
        break;
      case 4:
        currentMenuType = sushiMenuType;
        controller.jumpToPage(4);
        break;
      case 5:
        currentMenuType = dessertMenuType;
        controller.jumpToPage(5);
        break;
      case 6:
        currentMenuType = wineMenuType;
        controller.jumpToPage(6);
        break;
      case 7:
        currentMenuType = drinkMenuType;
        controller.jumpToPage(7);
        break;
    }
  }

  ScrollController scrollViewColtroller = ScrollController();

  @override
  void initState() {
    scrollViewColtroller = ScrollController();
    scrollViewColtroller.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (scrollViewColtroller.offset >=
        scrollViewColtroller.position.maxScrollExtent &&
        !scrollViewColtroller.position.outOfRange) {
      setState(() {
        _direction = true;
      });
    }
    if (scrollViewColtroller.offset <=
        scrollViewColtroller.position.minScrollExtent &&
        !scrollViewColtroller.position.outOfRange) {
      setState(() {
        _direction = false;
      });
    }
  }

  bool _direction = false;

  @override
  void dispose() {
    super.dispose();
    scrollViewColtroller.dispose();
  }

  _moveUp() {
    scrollViewColtroller.animateTo(scrollViewColtroller.offset - 450,
        curve: Curves.linear, duration: Duration(milliseconds: 200));
  }

  _moveDown() {
    scrollViewColtroller.animateTo(scrollViewColtroller.offset + 450,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;


    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Visibility(
            visible: _direction,
            maintainSize: false,
            child: FloatingActionButton(
              backgroundColor: OSTERIA_GOLD,
              onPressed: () {
                _moveUp();
              },
              child: RotatedBox(
                  quarterTurns: 1, child: Icon(Icons.chevron_left)),
            ),
          ),
          Visibility(
            maintainSize: false,
            visible: !_direction,
            child: FloatingActionButton(
              backgroundColor: OSTERIA_GOLD,
              onPressed: () {
                _moveDown();
              },
              child: RotatedBox(
                  quarterTurns: 3, child: Icon(Icons.chevron_left)),
            ),
          )
        ],
      ),
      key: scaffoldState,
      body: NotificationListener<ScrollUpdateNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollViewColtroller.position.userScrollDirection ==
              ScrollDirection.reverse) {
            setState(() {
              _direction = true;
            });
          } else {
            if (scrollViewColtroller.position.userScrollDirection ==
                ScrollDirection.forward) {
              setState(() {
                _direction = false;
              });
            }
          }
          return true;
        },
        child: SafeArea(
          child: Container(
            width: screenWidth,
            height: screenHeight,
            child: Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(color: OSTERIA_GOLD),
                backgroundColor: Colors.white,
                elevation: 0.0,
                title: Text('Dashboard', style: TextStyle(fontSize: 19.0, color: OSTERIA_GOLD, fontFamily: 'LoraFont'),
                ),
                centerTitle: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: IconButton(
                      icon: const Icon(Icons.calendar_today, size: 37,),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => CalendarManager())
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: IconButton(
                      icon: const Icon(Icons.delivery_dining, size: 37,),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => CalendarManagerDelivery())
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: IconButton(
                      icon: const Icon(Icons.add_circle, size: 40,),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AddNewProductCarteScreen())
                        );
                      },
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: 4.0,),
                    ],
                  ),
                ],
              ),
              drawer: Drawer(
                elevation: 3.0,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    SizedBox(height: 50.0,),
                    DrawerHeader(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/logo_santanna.png"),
                            fit: BoxFit.cover),
                        color: Colors.white38,
                      ),
                    ),
                    Column(
                      children: [
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.home,
                                  color: OSTERIA_GOLD,),
                                Text('  Home',
                                  style: TextStyle(fontSize: 19.0, color: OSTERIA_GOLD, fontFamily: 'LoraFont'),
                                ),
                              ],
                            ),
                          ),
                          onTap: () =>  Navigator.pushNamed(context, ALaCarteMenuScreen.id),
                        ),
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Antipasti',
                              style: TextStyle(fontSize: 19.0, color: OSTERIA_GOLD, fontFamily: 'LoraFont'),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              updateMenuType(0);
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Primi',
                              style: TextStyle(fontSize: 19.0, color: OSTERIA_GOLD, fontFamily: 'LoraFont'),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              updateMenuType(1);
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Secondi',
                              style: TextStyle(fontSize: 19.0, color: OSTERIA_GOLD, fontFamily: 'LoraFont'),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              updateMenuType(2);
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Contorni',
                              style: TextStyle(fontSize: 19.0, color: OSTERIA_GOLD, fontFamily: 'LoraFont'),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              updateMenuType(3);
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Sushi & Susci',
                              style: TextStyle(fontSize: 19.0, color: OSTERIA_GOLD, fontFamily: 'LoraFont'),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              updateMenuType(4);
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Dolci',
                              style: TextStyle(fontSize: 19.0, color: OSTERIA_GOLD, fontFamily: 'LoraFont'),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              updateMenuType(5);
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Vini',
                          style: TextStyle(fontSize: 19.0, color: OSTERIA_GOLD, fontFamily: 'LoraFont'),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          updateMenuType(6);
                        });
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Bevande',
                          style: TextStyle(fontSize: 19.0, color: OSTERIA_GOLD, fontFamily: 'LoraFont'),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          updateMenuType(7);
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              body: SafeArea(
                child: PageView(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  children: [
                    SingleChildScrollView(
                      controller: scrollViewColtroller,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              child: FutureBuilder(
                                initialData: <Widget>[Column(
                                  children: [
                                    Center(child: CircularProgressIndicator()),
                                    SizedBox(),
                                    Center(child: Text('Caricamento menù..',
                                      style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'LoraFont'),
                                    ),),
                                  ],
                                )],
                                future: createList(startersMenuType),
                                builder: (context, snapshot){
                                  if(snapshot.hasData){
                                    return Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: ListView(
                                        primary: false,
                                        shrinkWrap: true,
                                        children: snapshot.data,
                                      ),
                                    );
                                  }else{
                                    return CircularProgressIndicator();
                                  }
                                },
                              )
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      controller: scrollViewColtroller,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              child: FutureBuilder(
                                initialData: <Widget>[Column(
                                  children: [
                                    Center(child: CircularProgressIndicator()),
                                    SizedBox(),
                                    Center(child: Text('Caricamento menù..',
                                      style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'LoraFont'),
                                    ),),
                                  ],
                                )],
                                future: createList(mainDishMenuType),
                                builder: (context, snapshot){
                                  if(snapshot.hasData){
                                    return Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: ListView(
                                        primary: false,
                                        shrinkWrap: true,
                                        children: snapshot.data,
                                      ),
                                    );
                                  }else{
                                    return CircularProgressIndicator();
                                  }
                                },
                              )
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      controller: scrollViewColtroller,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              child: FutureBuilder(
                                initialData: <Widget>[Column(
                                  children: [
                                    Center(child: CircularProgressIndicator()),
                                    SizedBox(),
                                    Center(child: Text('Caricamento menù..',
                                      style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'LoraFont'),
                                    ),),
                                  ],
                                )],
                                future: createList(secondMainDishMenuType),
                                builder: (context, snapshot){
                                  if(snapshot.hasData){
                                    return Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: ListView(
                                        primary: false,
                                        shrinkWrap: true,
                                        children: snapshot.data,
                                      ),
                                    );
                                  }else{
                                    return CircularProgressIndicator();
                                  }
                                },
                              )
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      controller: scrollViewColtroller,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              child: FutureBuilder(
                                initialData: <Widget>[Column(
                                  children: [
                                    Center(child: CircularProgressIndicator()),
                                    SizedBox(),
                                    Center(child: Text('Caricamento menù..',
                                      style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'LoraFont'),
                                    ),),
                                  ],
                                )],
                                future: createList(sideDishMenuType),
                                builder: (context, snapshot){
                                  if(snapshot.hasData){
                                    return Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: ListView(
                                        primary: false,
                                        shrinkWrap: true,
                                        children: snapshot.data,
                                      ),
                                    );
                                  }else{
                                    return CircularProgressIndicator();
                                  }
                                },
                              )
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      controller: scrollViewColtroller,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              child: FutureBuilder(
                                initialData: <Widget>[Column(
                                  children: [
                                    Center(child: CircularProgressIndicator()),
                                    SizedBox(),
                                    Center(child: Text('Caricamento menù..',
                                      style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'LoraFont'),
                                    ),),
                                  ],
                                )],
                                future: createList(sushiMenuType),
                                builder: (context, snapshot){
                                  if(snapshot.hasData){
                                    return Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: ListView(
                                        primary: false,
                                        shrinkWrap: true,
                                        children: snapshot.data,
                                      ),
                                    );
                                  }else{
                                    return CircularProgressIndicator();
                                  }
                                },
                              )
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      controller: scrollViewColtroller,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              child: FutureBuilder(
                                initialData: <Widget>[Column(
                                  children: [
                                    Center(child: CircularProgressIndicator()),
                                    SizedBox(),
                                    Center(child: Text('Caricamento menù..',
                                      style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'LoraFont'),
                                    ),),
                                  ],
                                )],
                                future: createList(dessertMenuType),
                                builder: (context, snapshot){
                                  if(snapshot.hasData){
                                    return Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: ListView(
                                        primary: false,
                                        shrinkWrap: true,
                                        children: snapshot.data,
                                      ),
                                    );
                                  }else{
                                    return CircularProgressIndicator();
                                  }
                                },
                              )
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      controller: scrollViewColtroller,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              child: FutureBuilder(
                                initialData: <Widget>[Column(
                                  children: [
                                    Center(child: CircularProgressIndicator()),
                                    SizedBox(),
                                    Center(child: Text('Caricamento menù..',
                                      style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'LoraFont'),
                                    ),),
                                  ],
                                )],
                                future: createList(wineMenuType),
                                builder: (context, snapshot){
                                  if(snapshot.hasData){
                                    return Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: ListView(
                                        primary: false,
                                        shrinkWrap: true,
                                        children: snapshot.data,
                                      ),
                                    );
                                  }else{
                                    return CircularProgressIndicator();
                                  }
                                },
                              )
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      controller: scrollViewColtroller,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              child: FutureBuilder(
                                initialData: <Widget>[Column(
                                  children: [
                                    Center(child: CircularProgressIndicator()),
                                    SizedBox(),
                                    Center(child: Text('Caricamento menù..',
                                      style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'LoraFont'),
                                    ),),
                                  ],
                                )],
                                future: createList(drinkMenuType),
                                builder: (context, snapshot){
                                  if(snapshot.hasData){
                                    return Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: ListView(
                                        primary: false,
                                        shrinkWrap: true,
                                        children: snapshot.data,
                                      ),
                                    );
                                  }else{
                                    return CircularProgressIndicator();
                                  }
                                },
                              )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<List<Widget>> createList(String currentMenuType) async{

    String menuType = '';
    int previousMenu;
    int nextMenu;

    switch(currentMenuType){
      case startersMenuType:
        menuType = 'Antipasti';
        nextMenu = 1;
        break;
      case mainDishMenuType:
        menuType = 'Primi';
        previousMenu = 0;
        nextMenu = 2;
        break;
      case secondMainDishMenuType:
        menuType = 'Secondi';
        previousMenu = 1;
        nextMenu = 3;
        break;
      case sideDishMenuType:
        menuType = 'Contorni';
        previousMenu = 2;
        nextMenu = 4;
        break;
      case sushiMenuType:
        menuType = 'Sushi & Susci';
        previousMenu = 3;
        nextMenu = 5;
        break;
      case dessertMenuType:
        menuType = 'Dolci';
        previousMenu = 4;
        nextMenu = 6;
        break;
      case wineMenuType:
        menuType = 'Vini';
        previousMenu = 5;
        nextMenu = 7;
        break;
      case drinkMenuType:
        menuType = 'Bevande';
        previousMenu = 6;
        break;
    }

    List<Widget> items = <Widget>[
      Column(
        children: [
          Card(
            color: Colors.white38,
            elevation: 0.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                currentMenuType == startersMenuType ? Text('') :
                GestureDetector(
                  child: Icon(Icons.chevron_left,
                    color: OSTERIA_GOLD,),
                  onTap: (){
                    setState(() {
                      updateMenuType(previousMenu);
                    });
                  },
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Text(menuType, style: TextStyle(fontSize: 22.0, color: OSTERIA_GOLD, fontFamily: 'LoraFont')),
                  ),
                ),
                currentMenuType == drinkMenuType ? Text('') :
                GestureDetector(
                  child: Icon(
                    Icons.chevron_right,
                    color: OSTERIA_GOLD,
                  ),
                  onTap: (){
                    setState(() {
                      updateMenuType(nextMenu);
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              color: OSTERIA_GOLD,
              height: 2,
              indent: 12,
            ),
          ),
        ],
      ),
    ];

    List<Product> productList = await getCurrentProductList(currentMenuType);

    productList.forEach((product) {
      if(listTypeWine.contains(product.category)){
        items.add(
          InkWell(
            onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => ManageMenuWinePage(product: product, menuType: currentMenuType,),),),
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: product.available == 'false' ? Colors.redAccent : Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRect(
                  child: Banner(
                    message: getNameByType(product.category),
                    color: getColorByType(product.category),
                    location: BannerLocation.topEnd,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 200,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                product.available == 'false' ? Padding(
                                  padding: const EdgeInsets.fromLTRB(100,0,10,0),
                                  child: Text('Esaurito', style: TextStyle(fontSize: 19, color: Colors.red),),
                                ) : SizedBox(width: 0,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                                  child: Text(product.name, style: TextStyle(color: OSTERIA_GOLD, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                ),
                                Utils.getIngredientsFromProductALaCarte(product) == '' ? SizedBox(height: 0,) : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(Utils.getIngredientsFromProductALaCarte(product), overflow: TextOverflow.fade , style: TextStyle(fontSize: 13.0, fontFamily: 'LoraFont'),),
                                ),
                                product.changes != null ? Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text('Cantina: ' + product.changes[0], overflow: TextOverflow.fade , style: TextStyle(fontSize: 13.0, color: Colors.black, fontFamily: 'LoraFont'),),
                                ) : SizedBox(width: 0,),

                                Text('',),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text('€ ' + product.price.toString(), overflow: TextOverflow.ellipsis , style: TextStyle(color: OSTERIA_GOLD, fontSize: 14.0, fontFamily: 'LoraFont'),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      } else{
        items.add(
            product.available == 'true' ? Padding(
              padding: EdgeInsets.all(6.0),
              child: Container(
                child: getRowFromProduct(product, currentMenuType),
              ),
            ) : Padding(
              padding: EdgeInsets.all(6.0),
              child: Container(
                child: ClipRect(
                  child: Banner(
                    message: product.available == 'new' ? 'Novità' : 'Esaurito',
                    color: product.available == 'new' ? Colors.green.shade500 : Colors.red.shade900,
                    location: BannerLocation.topEnd,
                    child: getRowFromProduct(product, currentMenuType),
                  ),
                ),
              ),
            )
        );
      }
    }
    );
    return items;
  }

  Future<List<Product>> getCurrentProductList(String currentMenuType) async {


    switch(currentMenuType){

      case sushiMenuType:
        if(sushiProductList.isEmpty){
          CRUDModel crudModel = CRUDModel(currentMenuType);
          sushiProductList = await crudModel.fetchProducts();
          return sushiProductList;
        }else{
          return sushiProductList;
        }
        break;
      case startersMenuType:

        if(startersMenuList.isEmpty){
          CRUDModel crudModel = CRUDModel(currentMenuType);
          startersMenuList = await crudModel.fetchProducts();
          return startersMenuList;
        }else{
          return startersMenuList;

        }
        break;
      case mainDishMenuType:

        if(mainDishProductList.isEmpty){
          CRUDModel crudModel = CRUDModel(currentMenuType);
          mainDishProductList = await crudModel.fetchProducts();
          return mainDishProductList;
        }else{
          return mainDishProductList;
        }
        break;
      case secondMainDishMenuType:

        if(secondMainDishProductList.isEmpty){
          CRUDModel crudModel = CRUDModel(currentMenuType);
          secondMainDishProductList = await crudModel.fetchProducts();
          return secondMainDishProductList ;
        }else{
          return secondMainDishProductList ;
        }
        break;
      case sideDishMenuType:
        if(sideDishProductList.isEmpty){
          CRUDModel crudModel = CRUDModel(currentMenuType);
          sideDishProductList = await crudModel.fetchProducts();
          return sideDishProductList ;
        }else{
          return sideDishProductList ;
        }
        break;
      case dessertMenuType:

        if(dessertProductList.isEmpty){
          CRUDModel crudModel = CRUDModel(currentMenuType);
          dessertProductList = await crudModel.fetchProducts();
          return dessertProductList;
        }else{
          return dessertProductList;
        }
        break;
      case wineMenuType:

        if(wineProductList.isEmpty){
          CRUDModel crudModel = CRUDModel(currentMenuType);
          wineProductList = await crudModel.fetchProducts();
          return reorderWineListByType(wineProductList);
        }else{
          return reorderWineListByType(wineProductList);
        }
        break;
      case drinkMenuType:

        if(drinkProductList.isEmpty){
          CRUDModel crudModel = CRUDModel(currentMenuType);
          drinkProductList = await crudModel.fetchProducts();
          return drinkProductList;
        }else{
          return drinkProductList;
        }
        break;
    }
  }
  getNameByType(String type) {

    switch(type){
      case 'whitewine':
        return 'Bianco';
      case 'redwine':
        return 'Rosso';
      case 'bollicine':
        return 'Bollicine';
      case 'Champagne':
        return 'Champagne';
      case 'rosewine':
        return 'Rosato';
    }
    return '';
  }

  getColorByType(String type) {
    switch(type){
      case 'whitewine':
        return Colors.yellow.shade600;
      case 'bollicine':
        return Colors.blue.shade400;
      case 'redwine':
        return Colors.red.shade900;
      case 'Champagne':
        return Color.fromRGBO(130, 97, 60, 1.0);
      case 'rosewine':
        return Colors.pinkAccent.shade100;
    }
    return Colors.black;
  }

  getRowFromProduct(Product product, String currentMenuType) {
    return InkWell(
      onTap: () => Navigator.push(context,
        MaterialPageRoute(builder: (context) => ManageMenuItemPage(product: product, menuType: currentMenuType,),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            width: width - 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Text(product.name, style: TextStyle(color: OSTERIA_GOLD, fontSize: 18.0, fontFamily: 'LoraFont'),),
                ),
                Utils.getIngredientsFromProductALaCarte(product) == '' ? SizedBox(height: 0,) : Padding(
                  padding: const EdgeInsets.fromLTRB(15, 2, 15, 5),
                  child: Text(Utils.getIngredientsFromProductALaCarte(product), overflow: TextOverflow.fade , style: TextStyle(fontSize: 13.0, fontFamily: 'LoraFont'),),
                ),
                Text('€ ' + product.price.toString(), overflow: TextOverflow.ellipsis , style: TextStyle(color: OSTERIA_GOLD,fontSize: 15.0, fontFamily: 'LoraFont'),),
                Text('',),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Product> reorderWineListByType(List<Product> wineProductList) {
    List<Product> reorderedBollicineList = <Product>[];
    List<Product> reorderedRedList = <Product>[];
    List<Product> reorderedRoseList = <Product>[];
    List<Product> reorderedWitheList = <Product>[];
    List<Product> fullList = <Product>[];

    wineProductList.forEach((element) {
      if(element.category.toLowerCase() == 'Bollicine'.toLowerCase()){
        reorderedBollicineList.add(element);
      }
      if(element.category.toLowerCase() == 'redwine'.toLowerCase()){
        reorderedRedList.add(element);
      }
      if(element.category.toLowerCase() == 'rosewine'.toLowerCase()){
        reorderedRoseList.add(element);
      }
      if(element.category.toLowerCase() == 'whitewine'.toLowerCase()){
        reorderedWitheList.add(element);
      }
    });
    fullList.addAll(reorderedWitheList);
    fullList.addAll(reorderedRoseList);
    fullList.addAll(reorderedRedList);
    fullList.addAll(reorderedBollicineList);

    return fullList;
  }
}




