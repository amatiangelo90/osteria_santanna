import 'package:delivery_santanna/models/cart.dart';
import 'package:delivery_santanna/models/product.dart';
import 'package:delivery_santanna/utils/round_icon_botton.dart';
import 'package:delivery_santanna/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';

class ModalAddItem extends StatefulWidget {
  final Product product;
  final Function updateCountCallBack;

  ModalAddItem({
    @required this.product,
    @required this.updateCountCallBack,
  });

  @override
  _ModalAddItemState createState() => _ModalAddItemState();
}

class _ModalAddItemState extends State<ModalAddItem> {
  int _counter = 0;

  List<Cart> cartProductList = <Cart>[];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: Center(child: Text(this.widget.product.name, style: TextStyle(fontSize: 20.0, fontFamily: 'LoraFont'),)),
        content: Container(
          height: MediaQuery.of(context).size.height - 200,
          width: MediaQuery.of(context).size.width - 50,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              children: [
                SafeArea(
                  child: Center(
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              height: 110,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(60.0)),
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.transparent, Colors.black]),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(60.0)),
                                  child: Image.asset(this.widget.product.image),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(Utils.getIngredientsFromProduct(this.widget.product), overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 13.0, fontFamily: 'LoraFont'),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Allergeni: ' +  Utils.getAllergensFromProduct(this.widget.product), overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 13.0, fontFamily: 'LoraFont'),),
                            ),
                            Text('€ ' + this.widget.product.price.toString(), overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 19.0, fontFamily: 'LoraFont'),),

                            /*buildChoiceChipList(this.widget.product.changes),*/

                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RoundIconButton(
                                    icon: FontAwesomeIcons.minus,
                                    function: () {
                                      setState(() {
                                        if(_counter > 0)
                                          _counter = _counter - 1;
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(_counter.toString(), style: TextStyle(fontSize: 20.0, fontFamily: 'LoraFont'),),
                                  ),
                                  RoundIconButton(
                                    icon: FontAwesomeIcons.plus,
                                    function: () {
                                      setState(() {
                                        _counter = _counter + 1;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        RaisedButton(
                            child: Text(
                              "Aggiungi al Carrello", overflow: TextOverflow.ellipsis , style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'LoraFont'),
                            ),
                            color: Colors.teal.shade800,
                            onPressed: (){
                              if(_counter != 0){
                                cartProductList.add(Cart(product: this.widget.product, numberOfItem: _counter));
                                Toast.show(
                                    _counter.toString() + ' x ' + this.widget.product.name + ' aggiunto al carrello',
                                    context,
                                    duration: 2,
                                    backgroundColor: Colors.green.shade500,
                                    gravity: 0
                                );
                                this.widget.updateCountCallBack(cartProductList);
                              }else{
                                Toast.show(
                                    'Nessuna aggiunta',
                                    context,
                                    duration: 2,
                                    backgroundColor: Colors.redAccent,
                                    gravity: 0
                                );
                              }
                              Navigator.pop(context);
                            }
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
