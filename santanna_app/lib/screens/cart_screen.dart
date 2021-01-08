import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:santanna_app/models/cart.dart';
import 'package:santanna_app/models/product.dart';

class CartScreen extends StatefulWidget {

  final List<Cart> cartItems;
  CartScreen(this.cartItems);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  double _total;

  @override
  void initState() {
    super.initState();
    _getTotal();
  }

  _getTotal() {
    print('CCC' + this.widget.cartItems.toString());

    _total = 0.0;

    this.widget.cartItems.forEach((cartItem){
      setState(() {
        _total = _total + ((cartItem.product.price - ((cartItem.product.price/100)*cartItem.product.discountApplied)) * cartItem.numberOfItem);
      });
    });
    print('Totale' + _total.toString());
  }


  @override
  Widget build(BuildContext context) {

    String dropDownCity = '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Center(child: Text("Carrello ", style: TextStyle(color: Colors.black, fontSize: 19.0, fontFamily: 'LoraFont'),)),
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: this.widget.cartItems.isEmpty ?
      Container(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Il Carrello è vuoto",style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'))),
        ],
      ))
          : Container(
          child: Column(
            children: [
              FutureBuilder(
                initialData: <Widget>[Text('')],
                future: buildListFromCart(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        child: SafeArea(
                          child: SingleChildScrollView(
                            child: ListView(
                              primary: false,
                              shrinkWrap: true,
                              children: snapshot.data,
                            ),
                          ),
                        ),
                      ),
                    );
                  }else{
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          )
      ),
      bottomSheet: Container(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          verticalDirection: VerticalDirection.down,

          children: [
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Text("Totale € " +  _total.toString() ,style: TextStyle(color: Colors.black, fontSize: 17.0, fontFamily: 'LoraFont')),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: RaisedButton(
                    child: Text('Checkout',style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'LoraFont')),
                    color: _total != 0.0 ? Colors.green : Colors.grey,
                    elevation: 1.0,
                    onPressed: (){
                      FlutterOpenWhatsapp.sendSingleMessage("393402776601", buildMessageFromCart(this.widget.cartItems)
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<List<Widget>> buildListFromCart() async{

    List<Widget> items = List<Widget>();


    this.widget.cartItems.forEach((cartItem) {

      items.add(Padding(
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
                child: Image.asset(cartItem.product.image, width: 90.0, height: 90.0, fit: BoxFit.cover,),
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cartItem.product.name, style: TextStyle(fontSize: 16.0, fontFamily: 'LoraFont'),),
                            Text(' x ' + cartItem.numberOfItem.toString() , style: TextStyle(color: Colors.green, fontSize: 16.0, fontFamily: 'LoraFont'),),
                          ],
                        ),
                      ),
                      Text('',),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text('€ ' + cartItem.product.price.toString(), overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 14.0, fontFamily: 'LoraFont'),),
                      ),
                      cartItem.product.discountApplied != 0 ?
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, top: 5),
                        child: Text('Sconto ' + cartItem.product.discountApplied.toString() + ' %', overflow: TextOverflow.ellipsis , style: TextStyle(color: Colors.green, fontSize: 13.0, fontFamily: 'LoraFont'),),
                      ) : Text(''),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      );
    });
    return items;
  }

  buildMessageFromCart(List<Cart> cartItems) {
    String itemList = '';

    cartItems.forEach((element) {
      itemList = itemList + "\n" + element.numberOfItem.toString() + " x " + element.product.name;
    });

    String message = "Osteria Sant'Anna Delivery\n\n"
        + itemList + "\n"
        + "\nTotale ordine : " + _total.toString() +
        "\n"
            "\nConsegna: - "
            "\nData: - "
            "\nOre: - "
            "\n"
            "\nOsteria Sant'Anna confermerà il vostro ordine nel minor tempo possibile"
            "\n"
            "\nOrdine Effettuato da: Angelo Amati";
    return message;
  }
}
