import 'dart:convert';

import 'package:delivery_santanna/models/cart.dart';
import 'package:delivery_santanna/models/product.dart';
import 'package:delivery_santanna/screens/add_modal_screen.dart';
import 'package:delivery_santanna/screens/cart_screen.dart';
import 'package:delivery_santanna/utils/costants.dart';
import 'package:delivery_santanna/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    PageController controller = PageController(
        viewportFraction: 0.8,
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

      key: scaffoldState,
      body: Container(
        width: screenWidth,
        height: screenHeight,
        child: SafeArea(
          child: SingleChildScrollView(
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
                              return AlertDialog(
                                elevation: 2.0,
                                title: Center(child: const Text('Informazioni', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),)),
                                content: Container(
                                  child: Column(
                                    textDirection: TextDirection.ltr,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                                        child: Row(
                                          children: [
                                            Text('Ordini per il Delivery fino alle ',
                                              style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                                            Text('18.00',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0, fontFamily: 'LoraFont'),),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                                        child: Row(
                                          children: [
                                            Text('Ordini per l\'Asporto fino alle ',
                                              style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                                            Text('20.00',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0, fontFamily: 'LoraFont'),),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                                        child: Row(
                                          children: [
                                            Text('Consegna dalle ',
                                              overflow: TextOverflow.visible ,style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                                            Text('19.30',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0, fontFamily: 'LoraFont'),),
                                            Text(' alle ',
                                              overflow: TextOverflow.visible ,style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                                            Text('21.30',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0, fontFamily: 'LoraFont'),),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                                        child: Row(
                                          children: [
                                            Text('Costo delivery: ',
                                              overflow: TextOverflow.visible, style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                                            Text('3 €',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0, fontFamily: 'LoraFont'),),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(' (Gratis per ordini superiori a 50 €)',
                                            overflow: TextOverflow.visible, style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(''),
                                      ),
                                      const Text('Inviaci la richiesta d’ordine, ti risponderemo al più presto dopo aver verificato la disponibilità',
                                        overflow: TextOverflow.visible, style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                                            child: const Text('Grazie per averci scelto',
                                              overflow: TextOverflow.visible, style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
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
    print('' + changes.toString() + ' XXXXX' + changesFromModal.toString());
    print('' + changes.length.toString() + ' XXXXX' + changesFromModal.length.toString());
    if(changes.length != changesFromModal.length){
      print('Dimension different');
      return false;
    }
    changes.forEach((elementChanges) {
      print(changesFromModal.toString() + ' contains ' + elementChanges.toString() + '?');
      if(!changesFromModal.contains(elementChanges)){
        print('assign false');
        output = false;
      }else{
        print('true');
      }
    }
    );
    if(output){
      return true;
    }else{
      return false;
    }
  }
}




