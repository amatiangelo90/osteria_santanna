import 'dart:convert';

import 'package:delivery_santanna/models/cart.dart';
import 'package:delivery_santanna/models/product.dart';
import 'package:delivery_santanna/screens/add_modal_screen.dart';
import 'package:delivery_santanna/screens/cart_screen.dart';
import 'package:delivery_santanna/utils/costants.dart';
import 'package:delivery_santanna/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const sushiMenuType = 'assets/menu_sushi.json';
const fromKitchenMenuType = 'assets/menu_fromKitchen.json';
const dessertMenuType = 'assets/menu_dessert.json';
const wineMenuType = 'assets/cantina.json';

class OsteriaSantAnnaHomePage extends StatefulWidget {
  static String id = '/';

  @override
  _OsteriaSantAnnaHomePageState createState() => _OsteriaSantAnnaHomePageState();
}

class _OsteriaSantAnnaHomePageState extends State<OsteriaSantAnnaHomePage> {

  List<Cart> cartProductList = <Cart>[];

  final scaffoldState = GlobalKey<ScaffoldState>();
  String currentMenuType = sushiMenuType;
  int currentMenuItem = 0;

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
        break;
      case 1:
        currentMenuType = fromKitchenMenuType;
        break;
      case 2:
        currentMenuType = dessertMenuType;
        break;
      case 3:
        currentMenuType = wineMenuType;
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


    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    PageController controller = PageController(
        viewportFraction: 0.7,
        initialPage: 0);

    List<Widget> banners = <Widget>[];

    for(int i = 0; i < bannerItems.length; i++){
      var bannerView = Padding(
        padding: EdgeInsets.all(10.0),
        child: Container(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        offset: Offset(2.0, 3.0),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      )
                    ]
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: Image.asset(
                  bannerImages[i],
                  fit: BoxFit.cover,),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black54]),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(bannerItems[i], style: TextStyle(fontSize: 25.0, fontFamily: 'LoraFont', color: Colors.white),),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      banners.add(bannerView);
    }

    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Visibility(
            visible: _direction,
            maintainSize: false,
            child: FloatingActionButton(
              backgroundColor: Colors.teal.shade800,
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
              backgroundColor: Colors.teal.shade800,
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
          child: SafeArea(
            child: SingleChildScrollView(
              controller: scrollViewColtroller,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.info_outline ,size: 30.0, color: Colors.teal.shade800,), onPressed: (){
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Utils.buildAlertDialog(context);
                              }
                          );
                        },
                        ),
                        Text('Osteria Sant\'Anna', style: TextStyle(fontSize: 19.0, fontFamily: 'LoraFont'),),
                        Stack(
                          children: <Widget>[
                            IconButton(icon: Icon(Icons.shopping_cart_outlined), onPressed: (){
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => CartScreen(cartItems: cartProductList,
                                  function: removeProductFromCart,),
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
                  ),
                  Container(
                    width: screenWidth,
                    height: screenHeight*9/40,
                    child: GestureDetector(
                      child: PageView(
                        onPageChanged: (page)=>{
                          setState((){
                            updateMenuType(page);
                          }),
                        },
                        controller: controller,
                        scrollDirection: Axis.horizontal,
                        children: banners,
                      ),
                    ),
                  ),
                  Container(
                      child: FutureBuilder(
                        initialData: <Widget>[Text('')],
                        future: createList(),
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
          ),
        ),
      ),
    );
  }


  Future<List<Widget>> createList() async{

    List<Widget> items = <Widget>[];

    String dataString = await DefaultAssetBundle.of(context).loadString(currentMenuType);
    List<dynamic> dataJson = jsonDecode(dataString);

    List<Product> productList = <Product>[];

    dataJson.forEach((json) {
      productList.add(Product.fromJson(json));
    });

    print(productList);

    productList.forEach((product) {
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
    });
    return items;
  }

  bool _twoListContainsSameElements(List<String> changes, List<String> changesFromModal) {
    bool output = true;
    if(changes.length != changesFromModal.length){
      return false;
    }
    changes.forEach((elementChanges) {
      if(!changesFromModal.contains(elementChanges)){
        print('assign false');
        output = false;
      }
    });

    if(output){
      return true;
    }else{
      return false;
    }
  }
}




