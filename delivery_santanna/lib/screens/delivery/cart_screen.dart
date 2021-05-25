import 'package:delivery_santanna/models/calendar_manager.dart';
import 'package:delivery_santanna/models/cart.dart';
import 'package:delivery_santanna/models/promoclass.dart';
import 'package:delivery_santanna/utils/costants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'delivery_pickup_screen.dart';

class CartScreen extends StatefulWidget {

  final List<Cart> cartItems;
  final Function function;
  final String uniqueId;
  final List<CalendarManagerClass> listCalendarConfiguration;

  CartScreen({@required this.cartItems,
    @required this.function,
    @required this.uniqueId,
    @required this.listCalendarConfiguration
  });

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  final _discountController = TextEditingController();

  static final String _codeDiscount = 'SANNA10';

  double _total;
  double _totalWithoutDiscount;
  bool _discountApplied = false;
  List<Widget> currentListItems = <Widget>[];
  Promo promo;

  @override
  void initState() {
    promo = Promo(false, null, null);
    super.initState();
    _getTotal();
  }

  _getTotal() {
    _total = 0.0;
    this.widget.cartItems.forEach((cartItem){
      setState(() {
        _total = _total + ((cartItem.product.price - ((cartItem.product.price/100)*cartItem.product.discountApplied)) * cartItem.numberOfItem);
      });
    });
  }

  _applyDiscount() {
    setState(() {
      _totalWithoutDiscount = _total;
      _total = _total - ((_total/100)*10);
      _discountApplied = true;
      promo = Promo(true, _codeDiscount, 10);
    });
  }

  _removeItemFromCartList(Cart cartItem){
    setState(() {
      this.widget.cartItems.remove(cartItem);
      _getTotal();
      this.widget.function(cartItem.numberOfItem);
    });
  }

  _emptyCart(List<Cart> cartItems){
    setState(() {
      this.widget.cartItems.clear();
      _getTotal();
      this.widget.function(null);
    });
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Center(child: Text("Carrello", style: TextStyle(color: Colors.black, fontSize: 19.0, fontFamily: 'LoraFont'),)),
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(
              FontAwesomeIcons.trash,
              color: Colors.black,
            ),
            onPressed: () async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Conferma", style: TextStyle(color: Colors.black, fontSize: 19.0, fontFamily: 'LoraFont'),),
                    content: Text("Svuotare il carrello?", style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: (){
                            _emptyCart(this.widget.cartItems);
                            Navigator.of(context).pop(true);
                          },
                          child: const Text("Svuota")
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: this.widget.cartItems.isEmpty ?
          Container(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text("Il Carrello è vuoto",style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'))),
            ],
          ))
              : Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Flexible(
                    flex: 5,
                    child: ListView.builder(
                      itemCount: this.widget.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = this.widget.cartItems[index].product.name;
                        return Dismissible(
                          key: Key(item),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (DismissDirection direction) async {
                            if(direction == DismissDirection.endToStart){
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Conferma"),
                                    content: Text("Eliminare  " + this.widget.cartItems[index].numberOfItem.toString() +
                                        " x " + this.widget.cartItems[index].product.name.toString() + " ?"),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () => Navigator.of(context).pop(true),
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
                            }else{
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Aggiunto"),
                                    content: Text("1 x " + this.widget.cartItems[index].product.name.toString()),
                                  );
                                },
                              );
                            }
                          },

                          onDismissed: (direction) {
                            _removeItemFromCartList(this.widget.cartItems[index]);
                          },

                          background: Container(
                              color: Colors.redAccent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Center(child: Icon(
                                      FontAwesomeIcons.trash,
                                      color: Colors.white,
                                    ),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          child: buildListFromCart(this.widget.cartItems[index]),
                        );
                      },
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          color: Colors.white70,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 2.0,
                              blurRadius: 10.0,
                            ),
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            _discountApplied ? Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Totale € " , style: TextStyle(color: Colors.teal.shade800, fontSize: 20.0, fontFamily: 'LoraFont')),
                                  Text(_totalWithoutDiscount.toString(), style: TextStyle(decoration: TextDecoration.lineThrough ,color: Colors.deepOrangeAccent, fontSize: 20.0, fontFamily: 'LoraFont')),
                                  Text(" " + _total.toString(), style: TextStyle(color: Colors.teal.shade800, fontSize: 20.0, fontFamily: 'LoraFont')),

                                ],
                              ),
                            ) :Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Text("Totale € " +  _total.toString() ,style: TextStyle(color: Colors.teal.shade800, fontSize: 20.0, fontFamily: 'LoraFont')),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RaisedButton(
                                    child: Text('Codice Promo',style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'LoraFont')),
                                    color: _total != 0.0 ? OSTERIA_GOLD : Colors.grey,
                                    elevation: 5.0,
                                    onPressed: (){
                                      _discountApplied ?
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(backgroundColor: Colors.deepOrange.shade800 ,
                                          content: Text('Codice promo già applicato (' + _codeDiscount + ')  - 10%'))) :
                                      _total > 59.9 ? showDialog(
                                          context: context,
                                          builder: (context){
                                            return AlertDialog(
                                              title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                              content: Column(
                                                children: [
                                                  Text('Inserire il codice promo', style: TextStyle(color: Colors.black, fontSize: 17.0, fontFamily: 'LoraFont'),),
                                                  SizedBox(height: 40.0,),
                                                  Center(
                                                    child: Card(
                                                      child: TextField(
                                                        controller: _discountController,
                                                        textAlign: TextAlign.center,
                                                        decoration: InputDecoration(
                                                          border: OutlineInputBorder(),
                                                          labelText: 'Codice Promo',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 40.0,),
                                                  RaisedButton(
                                                    child: Text('Convalida', style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'LoraFont')),
                                                    color: _total != 0.0 ? Colors.green : Colors.grey,
                                                    elevation: 5.0,
                                                    onPressed: (){
                                                      if(_discountController.value.text == _codeDiscount){
                                                        _applyDiscount();
                                                        ScaffoldMessenger.of(context)
                                                            .showSnackBar(SnackBar(
                                                            backgroundColor: Colors.teal.shade800,
                                                            content: Text('Codice valido. Sconto 10% applicato')));
                                                        Navigator.of(context).pop(false);
                                                      }else{
                                                        ScaffoldMessenger.of(context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                              backgroundColor: Colors.red.shade800,
                                                              content: Text('Codice promo non valido')
                                                          ),
                                                        );
                                                        Navigator.of(context).pop(false);
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  onPressed: () => Navigator.of(context).pop(false),
                                                  child: const Text("Indietro"),
                                                ),
                                              ],
                                            );
                                          }
                                      ) : showDialog(
                                          context: context,
                                          builder: (context){
                                            return AlertDialog(
                                              title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                              content: Text('Attenzione! Sconto applicabile per importi superiori a 60 euro.', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                              actions: <Widget>[
                                                FlatButton(
                                                  onPressed: () => Navigator.of(context).pop(false),
                                                  child: const Text("Indietro"),
                                                ),
                                              ],
                                            );
                                          }
                                      );
                                      /*ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(backgroundColor: Colors.deepOrange.shade800 ,
                                          content: Text('Promo non disponibile per la settimana in corso')));*/
                                    }



                                ),
                                RaisedButton(
                                  child: Text('Conferma',style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'LoraFont')),
                                  color: _total != 0.0 ? Colors.green : Colors.grey,
                                  elevation: 5.0,
                                  onPressed: (){
                                    _total != 0.0 ? showDialog(
                                        context: context,
                                        builder: (context) {
                                          return DeliveryPickupScreen(
                                            cartItems: this.widget.cartItems,
                                            total: _total,
                                            promo: promo,
                                            uniqueId: this.widget.uniqueId,
                                            listCalendarConfiguration: this.widget.listCalendarConfiguration,
                                          );
                                        }
                                    ) : showDialog(
                                        context: context,
                                        builder: (context){
                                          return AlertDialog(
                                            title: Center(child: Text("Carrello Vuoto", style: TextStyle(color: Colors.black, fontSize: 20.0, fontFamily: 'LoraFont'))),
                                            content: Text(''),
                                          );
                                        }
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
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
  }

  buildListFromCart(cartItem) {
    return Padding(
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                  child: Image.asset(cartItem.product.image, width: 90.0, height: 90.0, fit: BoxFit.fitHeight,),
                ),
                SizedBox(
                  width: 210.0,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                          child: Text(cartItem.product.name, overflow: TextOverflow.ellipsis ,style: TextStyle(fontSize: 16.0, fontFamily: 'LoraFont'),),
                        ),
                        cartItem.changes.length == 0 ? SizedBox(height: 0.0,) : Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(cartItem.changes.toString(), overflow: TextOverflow.visible , style: TextStyle(fontSize: 11.0, fontFamily: 'LoraFont'),),
                        ),
                        Text('',),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0,),
                          child: Text(cartItem.numberOfItem.toString() + ' x ' + cartItem.product.price.toString() + ' €', overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 16.0, fontFamily: 'LoraFont'),),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            IconButton(
              icon: Icon(
                FontAwesomeIcons.trash,
                color: Colors.redAccent,
              ),
              onPressed: () async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Conferma"),
                      content: Text("Eliminare  " + cartItem.numberOfItem.toString() +
                          " x " + cartItem.product.name.toString() + " ?"),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: (){
                              _removeItemFromCartList(cartItem);
                              Navigator.of(context).pop(true);
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
    );
  }
}
