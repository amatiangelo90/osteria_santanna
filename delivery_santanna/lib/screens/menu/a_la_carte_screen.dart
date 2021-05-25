import 'dart:async';

import 'package:delivery_santanna/dao/crud_model.dart';
import 'package:delivery_santanna/models/calendar_manager.dart';
import 'package:delivery_santanna/models/cart.dart';
import 'package:delivery_santanna/models/product.dart';
import 'package:delivery_santanna/screens/dash_menu/admin_console_screen_menu.dart';
import 'package:delivery_santanna/screens/delivery/home_page_screen.dart';
import 'package:delivery_santanna/utils/costants.dart';
import 'package:delivery_santanna/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:delivery_santanna/reservation/reservation.dart';

class ALaCarteMenuScreen extends StatefulWidget {
  static String id = 'a_la_carte';

  @override
  _ALaCarteMenuScreenState createState() => _ALaCarteMenuScreenState();
}

class _ALaCarteMenuScreenState extends State<ALaCarteMenuScreen> {

  double width;
  double height;
  List<Product> sushiProductList = <Product>[];
  List<Product> startersMenuList = <Product>[];
  List<Product> mainDishProductList = <Product>[];
  List<Product> secondMainDishProductList = <Product>[];
  List<Product> sideDishMenuTypeProductList = <Product>[];
  List<Product> dessertProductList = <Product>[];
  List<Product> drinkProductList = <Product>[];
  List<Cart> cartProductList = <Cart>[];

  List<CalendarManagerClass> listCalendarConfiguration;
  List<CalendarManagerClass> listCalendarConfigurationDelivery;
  CRUDModel crudModelCalendar;
  CRUDModel crudModelCalendarDelivery;

  List<Product> wineProductList = <Product>[];
  List<Product> wineProductDummyList = <Product>[];

  final _passwordController = TextEditingController();
  TextEditingController editingController = TextEditingController();

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

  ScrollController scrollViewController = ScrollController();

  @override
  void initState() {
    scrollViewController = ScrollController();
    scrollViewController.addListener(_scrollListener);
    crudModelCalendar = CRUDModel(calendarSettings);
    crudModelCalendarDelivery = CRUDModel(calendarSettingsDelivery);
    super.initState();
  }

  _scrollListener() {
    if (scrollViewController.offset >=
        scrollViewController.position.maxScrollExtent &&
        !scrollViewController.position.outOfRange) {
      setState(() {
        _direction = true;
      });
    }
    if (scrollViewController.offset <=
        scrollViewController.position.minScrollExtent &&
        !scrollViewController.position.outOfRange) {
      setState(() {
        _direction = false;
      });
    }
  }

  bool _direction = false;

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    scrollViewController.dispose();
  }

  _moveUp() {
    scrollViewController.animateTo(scrollViewController.offset - 450,
        curve: Curves.linear, duration: Duration(milliseconds: 200));
  }

  _moveDown() {
    scrollViewController.animateTo(scrollViewController.offset + 450,
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
          if (scrollViewController.position.userScrollDirection ==
              ScrollDirection.reverse) {
            setState(() {
              _direction = true;
            });
          } else {
            if (scrollViewController.position.userScrollDirection ==
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
                backgroundColor: Colors.black,
                elevation: 0.0,
                title: Text('À la Carte', style: TextStyle(fontSize: 19.0, color: OSTERIA_GOLD, fontFamily: 'LoraFont'),
                ),
                centerTitle: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 12, 0),
                    child: GestureDetector(
                      child: Icon(Icons.calendar_today,
                        color: OSTERIA_GOLD,),
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => TableReservationScreen(
                            listCalendarConfiguration: listCalendarConfiguration,
                          ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 12, 0),
                    child: GestureDetector(
                      child: Icon(Icons.shopping_bag_outlined,
                        color: OSTERIA_GOLD,
                      size: 29,),
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => OsteriaSantAnnaHomePage(
                            listCalendarConfiguration: listCalendarConfigurationDelivery,
                          ),
                          ),
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
                child: Container(
                  color: Colors.black,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      SizedBox(height: 40.0,
                        child: Container(
                          color: Colors.white,

                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AdminConsoleMenuScreen.id);
                        },
                        child: Container(
                          color: Colors.white,
                          child: DrawerHeader(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("images/logo_santanna.png"),
                                  fit: BoxFit.cover),
                              color: Colors.white38,
                            ),
                          ),
                        ),
                      ),

                      Column(
                        children: [
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.settings,
                                    color: OSTERIA_GOLD,),
                                  Text('  Settings',
                                    style: TextStyle(fontSize: 19.0, color: OSTERIA_GOLD, fontFamily: 'LoraFont'),
                                  ),
                                ],
                              ),
                            ),
                            onTap: _showModalSettingsAccess,
                          ),
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                    color: OSTERIA_GOLD,),
                                  Text('  Prenota un tavolo',
                                    style: TextStyle(fontSize: 19.0, color: OSTERIA_GOLD, fontFamily: 'LoraFont'),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, TableReservationScreen.id);
                            },
                          ),
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.shopping_bag_outlined,
                                    color: OSTERIA_GOLD,
                                  size: 29,),
                                  Text('  Servizio Asporto',
                                    style: TextStyle(fontSize: 19.0, color: OSTERIA_GOLD, fontFamily: 'LoraFont'),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, OsteriaSantAnnaHomePage.id);
                            },
                          ),
                          SizedBox(height: 10,),
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
              ),
              body: SafeArea(
                child: PageView(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  children: [
                    SingleChildScrollView(
                      controller: scrollViewController,
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
                      controller: scrollViewController,
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
                      controller: scrollViewController,
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
                      controller: scrollViewController,
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
                      controller: scrollViewController,
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
                      controller: scrollViewController,
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
                      controller: scrollViewController,
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
                      controller: scrollViewController,
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

    if(listCalendarConfiguration == null || listCalendarConfiguration.length == 0){
      listCalendarConfiguration = await crudModelCalendar.fetchCalendarConfiguration();
    }
    if(listCalendarConfigurationDelivery == null || listCalendarConfigurationDelivery.length == 0){
      listCalendarConfigurationDelivery = await crudModelCalendarDelivery.fetchCalendarConfiguration();
    }

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
              height: 3,
              indent: 12,
            ),
          ),
        ],
      ),
    ];

    List<Product> productList = await getCurrentProductList(currentMenuType);
    if(currentMenuType == wineMenuType){
      items.add(
        Container(
          height: height * 1/10,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Ricerca per Nome, Uvaggio o Cantina",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))
                ),
              ),
            ),
          ),
        ),
      );
    }
    reorderWineListByType(productList, currentMenuType).forEach((product) {
      if(listTypeWine.contains(product.category) || currentMenuType == wineMenuType){
        items.add(
          Padding(
            padding: EdgeInsets.all(6.0),
            child: Container(
              /*decoration: BoxDecoration(
                  border: Border.all(color: product.available == 'false' ? Colors.red : Colors.white12 ),
                  borderRadius: BorderRadius.circular(10),
              ),*/
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
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                                child: Text(product.name, style: TextStyle(color: OSTERIA_GOLD, fontSize: 16.0, fontFamily: 'LoraFont'),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(Utils.getIngredientsFromProduct(product), overflow: TextOverflow.fade , style: TextStyle(fontSize: 11.0, color: Colors.black, fontFamily: 'LoraFont'),),
                              ),
                              product.changes != null ? Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text('Cantina: ' + product.changes[0], overflow: TextOverflow.fade , style: TextStyle(fontSize: 11.0, color: Colors.black, fontFamily: 'LoraFont'),),
                              ) : SizedBox(width: 0,),
                              SizedBox(height: 13,),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Row(
                                  children: [
                                    Text('€ ' + product.price.toString(), overflow: TextOverflow.ellipsis , style: TextStyle(color: OSTERIA_GOLD, fontSize: 14.0, fontFamily: 'LoraFont'),),
                                    product.available == 'false' ?
                                    Row(
                                      children: [
                                        SizedBox(width: 50,),
                                        Text('ESAURITO', overflow: TextOverflow.ellipsis ,
                                          style: TextStyle(color: Colors.redAccent, fontSize: 14.0, fontFamily: 'LoraFont'),),
                                      ],
                                    ) :
                                        SizedBox(height: 0,)
                                  ],
                                ),
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
        );
      } else{
        items.add(
            product.available == 'true' ? Padding(
              padding: EdgeInsets.all(6.0),
              child: Container(
                child: getRowFromProduct(product),
              ),
            ) : Padding(
              padding: EdgeInsets.all(6.0),
              child: Container(
                child: ClipRect(
                  child: Banner(
                    message: product.available == 'new' ? 'Novità' : 'Esaurito',
                    color: product.available == 'new' ? Colors.green.shade500 : Colors.red.shade900,
                    location: BannerLocation.topEnd,
                    child: getRowFromProduct(product),
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
        if(sideDishMenuTypeProductList.isEmpty){
          CRUDModel crudModel = CRUDModel(currentMenuType);
          sideDishMenuTypeProductList = await crudModel.fetchProducts();
          return sideDishMenuTypeProductList ;
        }else{
          return sideDishMenuTypeProductList ;
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
          wineProductDummyList = wineProductList;
          return wineProductDummyList;
        }else{
          wineProductDummyList = wineProductList;
          return wineProductDummyList;
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

  getRowFromProduct(Product product) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          width: width - 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Text(product.name, style: TextStyle(color: OSTERIA_GOLD, fontSize: 19.0, fontFamily: 'LoraFont'),),
              ),
              Utils.getIngredientsFromProductALaCarte(product) == '' ? SizedBox(height: 0,) : Padding(
                padding: const EdgeInsets.fromLTRB(15, 2, 15, 5),
                child: Text(Utils.getIngredientsFromProductALaCarte(product), overflow: TextOverflow.fade , style: TextStyle(fontSize: 13.0, fontFamily: 'LoraFont'),),
              ),
              SizedBox(height: 1,),
              Text('€ ' + product.price.toString(), overflow: TextOverflow.ellipsis , style: TextStyle(color: OSTERIA_GOLD,fontSize: 16.0, fontFamily: 'LoraFont'),),
              Text('',),
            ],
          ),
        ),
      ],
    );
  }


  void filterSearchResults(String query) {
    List<Product> wineDummyProductList = List<Product>();
    wineDummyProductList.addAll(wineProductList);

    if(query.isNotEmpty) {
      List<Product> dummyListData = List<Product>();
      wineDummyProductList.forEach((item) {

        if(item.name.toLowerCase().contains(query.toLowerCase()) ||
            item.changes[0].toString().toLowerCase().contains(query.toLowerCase()) ||
            listIngredientsContainsQuery(item, query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        wineProductDummyList.clear();
        wineProductDummyList.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        wineProductDummyList.clear();
        wineProductDummyList.addAll(wineProductList);
      });
    }
  }

  bool listIngredientsContainsQuery(Product item, String query) {
    bool contains = false;
    item.listIngredients.forEach((element) {
      if(element.toString().toLowerCase().contains(query.toLowerCase())){
        contains = true;
      }
    });
    return contains;
  }

  List<Product> reorderWineListByType(List<Product> productList, String currentMenuType) {
    if(currentMenuType != wineMenuType){
      return productList;
    }
    List<Product> reorderedBollicineList = <Product>[];
    List<Product> reorderedRedList = <Product>[];
    List<Product> reorderedRoseList = <Product>[];
    List<Product> reorderedWitheList = <Product>[];
    List<Product> fullList = <Product>[];

    productList.forEach((element) {
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

  _showModalSettingsAccess() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text("Settings"),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: Center(
                child: Card(
                  color: Colors.white,
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.black,
                    controller: _passwordController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black, width: 0.0),
                      ),
                      labelStyle: TextStyle(color: Colors.black),
                      fillColor: Colors.black,
                      labelText: 'Password',
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                FlatButton(
                  child: Text('Chiudi'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                    child: Text('Accedi'),
                    onPressed: (){

                      if(_passwordController.value.text == CURRENT_PASSWORD){
                        setState(() {
                          _passwordController.clear();
                        });
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, AdminConsoleMenuScreen.id);
                      }else{
                        setState(() {
                          _passwordController.clear();
                        });

                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(backgroundColor: Colors.red.shade500 ,
                            content: Text('Password errata')));
                      }
                    }
                ),
              ],
            )
          ],
        )
    );
  }

}




