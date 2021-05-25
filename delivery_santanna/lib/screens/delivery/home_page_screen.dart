import 'dart:async';
import 'package:delivery_santanna/models/calendar_manager.dart';
import 'package:delivery_santanna/models/cart.dart';
import 'package:delivery_santanna/models/product.dart';
import 'package:delivery_santanna/screens/delivery/add_modal_screen.dart';
import 'package:delivery_santanna/screens/delivery/cart_screen.dart';
import 'package:delivery_santanna/utils/costants.dart';
import 'package:delivery_santanna/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:delivery_santanna/dao/crud_model.dart';
import 'package:uuid/uuid.dart';

class OsteriaSantAnnaHomePage extends StatefulWidget {
  static String id = 'delivery-service';

  final List<CalendarManagerClass> listCalendarConfiguration;

  OsteriaSantAnnaHomePage({@required this.listCalendarConfiguration});

  @override
  _OsteriaSantAnnaHomePageState createState() => _OsteriaSantAnnaHomePageState();
}

class _OsteriaSantAnnaHomePageState extends State<OsteriaSantAnnaHomePage> {

  var uuid;

  List<Product> sushiProductList = <Product>[];
  /*List<Product> kitchenProductList = <Product>[];
  List<Product> dessertProductList = <Product>[];
  List<Product> wineProductList = <Product>[];*/

  List<Cart> cartProductList = <Cart>[];

  final scaffoldState = GlobalKey<ScaffoldState>();
  String currentMenuType = sushiMenuType;
  int currentMenuItem = 0;

  PageController controller = PageController(
      initialPage: 0);

  void updateCurrentMenuItemCount(List<Cart> cartItemToAdd){

    setState(() {
      print('Adding to cart the following element: ' + cartItemToAdd[0].toString());
      print('Current cart object: ' + cartProductList.toString());

      var _present = false;
      currentMenuItem = currentMenuItem + cartItemToAdd[0].numberOfItem;

      cartProductList.forEach((element) {
        if(element.product.name == cartItemToAdd[0].product.name
            && _twoListContainsSameElements(element.changes, cartItemToAdd[0].changes)){

          print(element.changes.toString() + ' =================== ' + cartItemToAdd[0].changes.toString());
          element.numberOfItem = element.numberOfItem + cartItemToAdd[0].numberOfItem;
          _present = true;

        }
      });

      if(!_present){
        cartProductList.addAll(cartItemToAdd);
      }
    });
  }

  void removeProductFromCart(int cartListToRemove) {
    setState(() {
      if(cartListToRemove == null){
        currentMenuItem = 0;
      }else{
        currentMenuItem = currentMenuItem - cartListToRemove;
      }
    });
  }


  void updateMenuType(int menuType){
    switch(menuType){
      case 0:
        currentMenuType = sushiMenuType;
        controller.jumpToPage(0);
        break;
      case 1:
        currentMenuType = fromKitchenMenuType;
        controller.jumpToPage(1);
        break;
      case 2:
        currentMenuType = dessertMenuType;
        controller.jumpToPage(2);
        break;
      case 3:
        currentMenuType = wineMenuType;
        controller.jumpToPage(3);
        break;
    }
  }

  ScrollController scrollViewColtroller = ScrollController();

  @override
  void initState() {
    uuid = Uuid().v1();
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
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: Text('Asporto Sant\'Anna', style: TextStyle(fontSize: 19.0, color: Colors.black, fontFamily: 'LoraFont'),
              ),
              centerTitle: true,
              actions: [
                IconButton(icon: Icon(Icons.info_outline ,size: 30.0, color: OSTERIA_GOLD,), onPressed: (){
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Utils.buildAlertDialog(context);
                      }
                  );
                },
                ),
                Column(
                  children: [
                    SizedBox(height: 4.0,),
                    Stack(
                      children: <Widget>[
                        IconButton(icon: Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.black,
                        ),
                            onPressed: (){
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => CartScreen(
                                  cartItems: cartProductList,
                                  function: removeProductFromCart,
                                  uniqueId: uuid,
                                  listCalendarConfiguration: this.widget.listCalendarConfiguration,
                                ),
                                ),
                              );
                            }),
                        currentMenuItem == 0 ? Text('') :
                        Positioned(
                          top: 6.0,
                          right: 10.0,
                          child: Stack(
                            children: <Widget>[
                              Icon(Icons.brightness_1, size: 15, color: Colors.redAccent,),
                              Positioned(
                                right: 5.0,
                                top: 2.0,
                                child: Center(child: Text(currentMenuItem.toString() , style: TextStyle(fontSize: 8.0, color: Colors.white, fontFamily: 'LoraFont'),
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
              ],
            ),
            /*drawer: Drawer(
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
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    children: [
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Sushi & Susci',
                            style: TextStyle(fontSize: 19.0, color: Colors.black, fontFamily: 'LoraFont'),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            updateMenuType(0);
                          });
                          Navigator.pop(context);
                        },
                      ),
                      *//*ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Dalla Cucina',
                            style: TextStyle(fontSize: 19.0, color: Colors.black, fontFamily: 'LoraFont'),
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
                          child: Text('Dolci',
                            style: TextStyle(fontSize: 19.0, color: Colors.black, fontFamily: 'LoraFont'),
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
                          child: Text('Vini e Bollicine',
                            style: TextStyle(fontSize: 19.0, color: Colors.black, fontFamily: 'LoraFont'),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            updateMenuType(3);
                          });
                          Navigator.pop(context);
                        },
                      ),*//*
                    ],
                  ),
                  SizedBox(height: 180.0),
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Admin Console',
                        style: TextStyle(fontSize: 19.0, color: Colors.black, fontFamily: 'LoraFont'),
                      ),
                    ),
                    onTap: () {
                      _showLockScreen(
                        context,
                        opaque: false,
                        cancelButton: Text(
                          'Cancel',
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                          semanticsLabel: 'Cancel',
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),*/
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
                  /*SingleChildScrollView(
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
                              future: createList(fromKitchenMenuType),
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
                  ),*/
                  /*SingleChildScrollView(
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
                  ),*/
                ],
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
      case sushiMenuType:
        menuType = 'Sushi & Susci';
        nextMenu = 1;
        break;
      case fromKitchenMenuType:
        menuType = 'Dalla Cucina';
        previousMenu = 0;
        nextMenu = 2;
        break;
      case dessertMenuType:
        menuType = 'Dolci';
        previousMenu = 1;
        nextMenu = 3;
        break;
      case wineMenuType:
        menuType = 'Vini';
        previousMenu = 2;
        break;
    }

    List<Widget> items = <Widget>[
      Card(
        color: Colors.white,
        elevation: 3.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /*currentMenuType == sushiMenuType ? Text('') :
            GestureDetector(
              child: Icon(Icons.chevron_left,
                color: Colors.black,),
              onTap: (){
                setState(() {
                  updateMenuType(previousMenu);
                });
              },
            ),*/
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(menuType, style: TextStyle(fontSize: 18.0, color: Colors.black, fontFamily: 'LoraFont')),
              ),
            ),
            /*currentMenuType == wineMenuType ? Text('') :
            GestureDetector(
              child: Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
              onTap: (){
                setState(() {
                  updateMenuType(nextMenu);
                });
              },
            ),*/
          ],
        ),
      ),
    ];

    List<Product> productList = await getCurrentProductList(currentMenuType);

    productList.forEach((product) {
      if(listTypeWine.contains(product.category)){
        items.add(
          InkWell(
            hoverColor: Colors.blueGrey,
            splashColor: Colors.greenAccent,
            highlightColor: Colors.blueGrey.withOpacity(0.5),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ModalAddItem(product: product, updateCountCallBack: updateCurrentMenuItemCount);
                  }
              );
            },
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 2.0,
                        blurRadius: 5.0,
                      ),
                    ]
                ),
                child: ClipRect(
                  child: Banner(
                    message: getNameByType(product.category),
                    color: getColorByType(product.category),
                    location: BannerLocation.topEnd,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                          child: Image.asset(product.image, width: 90.0, height: 90.0, fit: BoxFit.contain,),
                        ),
                        SizedBox(
                          width: 250.0,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                                  child: Text(product.name, style: TextStyle(fontSize: 16.0,color: Colors.black, fontFamily: 'LoraFont'),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(Utils.getIngredientsFromProduct(product), overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 11.0, color: Colors.black, fontFamily: 'LoraFont'),),
                                ),
                                Text('',),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text('€ ' + product.price.toString(), overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'LoraFont'),),
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
          product.available == 'false' ?
          InkWell(
            hoverColor: Colors.blueGrey,
            splashColor: Colors.greenAccent,
            highlightColor: Colors.blueGrey.withOpacity(0.5),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                      content: Text(product.name + ' Esaurito', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Indietro"),
                        ),
                      ],
                    );
                  }
              );
            },
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 2.0,
                        blurRadius: 5.0,
                      ),
                    ]
                ),
                child: ClipRect(
                  child: Banner(
                    message: 'Esaurito',
                    location: BannerLocation.topEnd,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                          child: Image.asset(product.image, width: 90.0, height: 90.0, fit: BoxFit.cover,),
                        ),
                        SizedBox(
                          width: 250.0,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                                  child: Text(product.name, style: TextStyle(fontSize: 16.0, fontFamily: 'LoraFont'),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(Utils.getIngredientsFromProduct(product), overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 11.0, fontFamily: 'LoraFont'),),
                                ),
                                Text('',),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text('€ ' + product.price.toString(), overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 14.0, fontFamily: 'LoraFont'),),
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
          ) : product.available == 'new' ?
          InkWell(
            hoverColor: Colors.blueGrey,
            splashColor: Colors.greenAccent,
            highlightColor: Colors.blueGrey.withOpacity(0.5),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ModalAddItem(product: product, updateCountCallBack: updateCurrentMenuItemCount);
                  }
              );
            },
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 2.0,
                        blurRadius: 5.0,
                      ),
                    ]
                ),
                child: ClipRect(
                  child: Banner(
                    message: 'Novità',
                    color: Colors.green,
                    location: BannerLocation.topEnd,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                          child: Image.asset(product.image, width: 90.0, height: 90.0, fit: BoxFit.cover,),
                        ),
                        SizedBox(
                          width: 250.0,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                                  child: Text(product.name, style: TextStyle(fontSize: 16.0, fontFamily: 'LoraFont'),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(Utils.getIngredientsFromProduct(product), overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 11.0, fontFamily: 'LoraFont'),),
                                ),
                                Text('',),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text('€ ' + product.price.toString(), overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 14.0, fontFamily: 'LoraFont'),),
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
          )
              : InkWell(
            hoverColor: Colors.blueGrey,
            splashColor: Colors.greenAccent,
            highlightColor: Colors.blueGrey.withOpacity(0.5),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ModalAddItem(product: product, updateCountCallBack: updateCurrentMenuItemCount);
                  }
              );
            },
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ModalAddItem(product: product, updateCountCallBack: updateCurrentMenuItemCount);
                  }
              );
            },
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 2.0,
                        blurRadius: 5.0,
                      ),
                    ]
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                      child: Image.asset(product.image, width: 90.0, height: 90.0, fit: BoxFit.fitHeight,),
                    ),
                    SizedBox(
                      width: 250.0,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                              child: Text(product.name, style: TextStyle(fontSize: 16.0, fontFamily: 'LoraFont'),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(Utils.getIngredientsFromProduct(product), overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 11.0, fontFamily: 'LoraFont'),),
                            ),
                            Text('',),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text('€ ' + product.price.toString(), overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 14.0, fontFamily: 'LoraFont'),),
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
        );
      }
    }
    );
    return items;
  }

  bool _twoListContainsSameElements(List<String> changes, List<String> changesFromModal) {
    bool output = true;
    if(changes.length != changesFromModal.length){
      return false;
    }
    changes.forEach((elementChanges) {
      if(!changesFromModal.contains(elementChanges)){
        output = false;
      }
    });

    if(output){
      return true;
    }else{
      return false;
    }
  }

  Future<List<Product>> getCurrentProductList(String currentMenuType) async {

    switch(currentMenuType){

      case sushiMenuType:
        if(sushiProductList.isEmpty){
          CRUDModel crudModel = CRUDModel(currentMenuType);
          sushiProductList = await crudModel.fetchProducts();
          return sushiProductList;
        }else{
          /*CRUDModel crudModel = CRUDModel(currentMenuType);
          sushiProductList = await crudModel.fetchProducts();*/
          return sushiProductList;
        }
        break;
    /* case fromKitchenMenuType:
        if(kitchenProductList.isEmpty){
          CRUDModel crudModel = CRUDModel(currentMenuType);
          kitchenProductList = await crudModel.fetchProducts();
          return kitchenProductList;
        }else{
          *//*CRUDModel crudModel = CRUDModel(currentMenuType);
          kitchenProductList = await crudModel.fetchProducts();*//*
          return kitchenProductList;

        }*/
    /*break;*/
    /*case dessertMenuType:
        if(dessertProductList.isEmpty){
          CRUDModel crudModel = CRUDModel(currentMenuType);
          dessertProductList = await crudModel.fetchProducts();
          return dessertProductList;
        }else{
          *//*CRUDModel crudModel = CRUDModel(currentMenuType);
          dessertProductList = await crudModel.fetchProducts();*//*
          return dessertProductList;
        }
        break;
      case wineMenuType:
        if(wineProductList.isEmpty){
          CRUDModel crudModel = CRUDModel(currentMenuType);
          wineProductList = await crudModel.fetchProducts();
          return wineProductList;
        }else{
          *//*CRUDModel crudModel = CRUDModel(currentMenuType);
          wineProductList = await crudModel.fetchProducts();*//*
          return wineProductList;
        }*/
    /*break;*/
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
}




