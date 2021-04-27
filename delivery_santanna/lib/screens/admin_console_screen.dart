import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:delivery_santanna/dao/crud_model.dart';
import 'package:delivery_santanna/models/cart.dart';
import 'package:delivery_santanna/models/order_store.dart';
import 'package:delivery_santanna/models/product.dart';
import 'package:delivery_santanna/screens/home_page_screen.dart';
import 'package:delivery_santanna/screens/manage_item_page.dart';
import 'package:delivery_santanna/utils/utils.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:flutter/material.dart';
import 'package:delivery_santanna/utils/costants.dart';
import 'package:delivery_santanna/screens/add_new_product.dart';

class AdminConsoleScreen extends StatefulWidget {
  static String id = 'admin_console';
  @override
  _AdminConsoleScreenState createState() => _AdminConsoleScreenState();
}

class _AdminConsoleScreenState extends State<AdminConsoleScreen> {

  List<Product> sushiProductList = <Product>[];
  List<Product> kitchenProductList = <Product>[];
  List<Product> dessertProductList = <Product>[];
  List<Product> wineProductList = <Product>[];
  DateTime _selectedDateTime = new DateTime.now();

  final _datePikerController = DatePickerController();

  List<OrderStore> ordersList = <OrderStore>[];

  ScrollController scrollViewController = ScrollController();

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.home_outlined, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, OsteriaSantAnnaHomePage.id),
          ),
          backgroundColor: Colors.black,
          title: Center(child: Text('Dashboard')),
          actions: [
            IconButton(icon: Icon(Icons.refresh ,size: 30.0, color: Colors.white,), onPressed: (){
              setState(() {});
            }
            ),
          ],
        ),
        floatingActionButton: _selectedIndex != 4 ? FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddNewProductScreen())
            );
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ) : SizedBox(height: 0,),
        body: _selectedIndex != 4 ? getWorkingWidgetByItem(_selectedIndex)
            : buildOrdersManagePage(),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.food_bank),
              label: 'Sushi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_sharp),
              label: 'Kitchen',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cake),
              label: 'Dessert',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wine_bar),
              label: 'Wine',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'Orders',
            ),
          ],
          currentIndex: _selectedIndex,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.teal[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Future<List<Widget>> createList(String currentMenuType) async{

    List<Product> productList = await getCurrentProductList(currentMenuType);
    productList.forEach((element) {
      print(element.category);
    });
    List<Widget> items = <Widget>[];

    productList.forEach((product) {
      items.add(
        product.available == 'false' ?
        InkWell(
          hoverColor: Colors.blueGrey,
          splashColor: Colors.greenAccent,
          highlightColor: Colors.blueGrey.withOpacity(0.5),
          onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => ManageItemPage(product: product, menuType: currentMenuType,),
            ),
          ),
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
                                child: Text(product.name, style: TextStyle(fontSize: 16.0),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(Utils.getIngredientsFromProduct(product), overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 11.0),),
                              ),
                              Text('',),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text('€ ' + product.price.toString(), overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 14.0),),
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
          onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => ManageItemPage(product: product, menuType: currentMenuType,),
            ),
          ),
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
                                child: Text(product.name, style: TextStyle(fontSize: 16.0),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(Utils.getIngredientsFromProduct(product), overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 11.0),),
                              ),
                              Text('',),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text('€ ' + product.price.toString(), overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 14.0),),
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
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => ManageItemPage(product: product, menuType: currentMenuType,),
              ),
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
                            child: Text(product.name, style: TextStyle(fontSize: 16.0),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(Utils.getIngredientsFromProduct(product), overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 11.0),),
                          ),
                          Text('',),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text('€ ' + product.price.toString(), overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 14.0),),
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
    );
    return items;
  }

  Future<List<Product>> getCurrentProductList(String currentMenuType) async {

    CRUDModel crudModel = CRUDModel(currentMenuType);

    switch(currentMenuType){
      case sushiMenuType:
        sushiProductList = await crudModel.fetchProducts();
        return sushiProductList;
        break;
      case fromKitchenMenuType:
        kitchenProductList = await crudModel.fetchProducts();
        return kitchenProductList;
        break;
      case dessertMenuType:
        dessertProductList = await crudModel.fetchProducts();
        return dessertProductList;
        break;
      case wineMenuType:
        wineProductList = await crudModel.fetchProducts();
        return wineProductList;
        break;
    }
  }

  String getMenuTypeByPageNumber(int selectedIndex) {
    switch(selectedIndex){
      case 0:
        return sushiMenuType;
      case 1:
        return fromKitchenMenuType;
      case 2:
        return dessertMenuType;
      case 3:
        return wineMenuType;
    }
  }

  getWorkingWidgetByItem(int selectedIndex) {
    return SingleChildScrollView(
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
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),),
                  ],
                )],
                future: createList(getMenuTypeByPageNumber(selectedIndex)),
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
    );
  }

  buildOrdersManagePage() {
    return SingleChildScrollView(
      controller: scrollViewController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DatePicker(
                DateTime.now(),
                activeDates: Utils.getAvailableData(),
                dateTextStyle: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),
                dayTextStyle: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),
                monthTextStyle: TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'LoraFont'),
                selectionColor: Colors.pinkAccent,
                deactivatedColor: Colors.grey,
                selectedTextColor: Colors.white,
                daysCount: 25,
                locale: 'it',
                controller: _datePikerController,
                onDateChange: (date) {
                  setSelectedDate(date);
                },
              ),
            ],
          ),
          Container(
              child: FutureBuilder(
                initialData: <Widget>[Column(
                  children: [
                    Center(child: CircularProgressIndicator()),
                    SizedBox(),
                    Center(child: Text('Caricamento ordini..',
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),),
                  ],
                )],
                future: createOrdersListByDateTime(_selectedDateTime),
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
    );
  }

  Future<List<Widget>> createOrdersListByDateTime (DateTime date) async{

    String selectedDatePickupDelivery = Utils.getWeekDay(date.weekday) +" ${date.day} " + Utils.getMonthDay(date.month);
    CRUDModel crudModel = CRUDModel(ORDERS_TRACKER);

    List<OrderStore> ordersList = await crudModel.fetchCustomersOrder();
    List<Widget> items = <Widget>[];
    ordersList.forEach((orderItem) {

    });

    ordersList.forEach((orderItem) {
      orderItem.datePickupDelivery == selectedDatePickupDelivery ?
      items.add(
          ClipRRect(
            child: Banner(
              message: orderItem.typeOrder,
              color: orderItem.typeOrder == DELIVERY_TYPE ? Colors.orangeAccent : Colors.blue.shade800,
              location: BannerLocation.topEnd,
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
                  child: ExpansionCard(
                      borderRadius: 20,
                      title: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              orderItem.name,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 5.0,),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      orderItem.date,
                                      style: TextStyle(fontSize: 15, color: Colors.black),
                                    ),
                                    Text(
                                      'Tot. ' + orderItem.total,
                                      style: TextStyle(fontSize: 15, color: Colors.black),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                              ],
                            ),
                          ],
                        ),
                      ),
                      children: [
                        Table(
                          border: TableBorder(horizontalInside: BorderSide(width: 1, color: orderItem.typeOrder == DELIVERY_TYPE ? Colors.orangeAccent : Colors.blue.shade800, style: BorderStyle.solid)),
                          children: buildListWidgetFromCart(orderItem.cartItemsList),
                        ),
                        SizedBox(height: 30,),
                        orderItem.typeOrder == DELIVERY_TYPE ?
                            Text('Consegna : ') : SizedBox(height: 0,),
                      ]
                  ),
                ),
              ),
            ),
          )
      ) : print('');
    });
    if(items.isEmpty){
      items.add(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text("Nessun ordine per la data corrente",style: TextStyle(color: Colors.black, fontSize: 16.0,))),
            ],
          )
      );
    }
    return items;
  }

  buildListWidgetFromCart(List<Cart> cartItemsList) {
    List<TableRow> rowTable = <TableRow>[];
    rowTable.add(
      TableRow(
          children: [
            Column(children:[
              Text('Prodotto')
            ]),
            Column(children:[
              Text('Quantità')
            ]),
          ]),
    );
    cartItemsList.forEach((element) {
      rowTable.add(
        TableRow(
            children: [
              Column(children:[
                Text(element.product.name)
              ]),
              Column(children:[
                Text(element.numberOfItem.toString())
              ]),
            ]),
      );
    });

    return rowTable;
  }

  void setSelectedDate(DateTime date) {
    setState(() {
      _selectedDateTime = date;
    });

  }
}