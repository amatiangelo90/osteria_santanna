import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:santanna_app/models/product.dart';

class CartScreen extends StatefulWidget {

  final List<Product> cartItems;
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
    _total = 0.0;
    this.widget.cartItems.forEach((product){
      setState(() {
        _total += (product.price - (product.price % product.discountApplied)) * product.quantity;
      });
    });
  }


  @override
  Widget build(BuildContext context) {

    String dropDownCity = 'XXXXXXXXXXXXX';

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
      body: Container(
        child: Column(
          children: [
            this.widget.cartItems.isEmpty ? Container(child: Center(child: Text("Il Carrello è vuoto",style: TextStyle(color: Colors.black, fontSize: 13.0, fontFamily: 'LoraFont')))) : Text(''),
          ],
        ),
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
                    color: _total == 0.0 ? Colors.green : Colors.grey,
                    elevation: 1.0,
                    onPressed: () async {
                      await showDialog(
                        context: this.context,
                        child: AlertDialog(
                          content: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 30.0),
                                  child: Center(child: Text('Riepilogo Ordine', style: TextStyle(color: Colors.black, fontSize: 18.0, fontFamily: 'LoraFont'),),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Nome',

                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Indirizzo',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Città',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButton<String>(
                                    elevation: 16,
                                    underline: Expanded(
                                      child: Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),

                                        ),
                                      ),
                                    ),

                                    onChanged: (String newValue) {
                                      setState(() {
                                        dropDownCity = newValue;
                                      });
                                    },
                                    items: <String>['Cisternino', 'Fasano', 'Ostuni', 'Martina Franca']
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value, style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
