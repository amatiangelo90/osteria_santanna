import 'package:chips_choice/chips_choice.dart';
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
  List<String> choicedChangesList = [];

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Container(
      child: AlertDialog(
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
                          verticalDirection: VerticalDirection.down,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(this.widget.product.name, overflow: TextOverflow.visible, style: TextStyle(fontSize: 15.0, fontFamily: 'LoraFont'),),
                            Text('€ ' + this.widget.product.price.toString(), overflow: TextOverflow.visible , style: TextStyle(fontSize: 20.0, fontFamily: 'LoraFont'),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
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
                        this.widget.product.category == 'wine' ? SizedBox(height: 1.0,) :
                        this.widget.product.changes.isNotEmpty ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Content(
                            child: ChipsChoice<String>.multiple(
                              value: choicedChangesList,
                              onChanged: (val) => setState(() => choicedChangesList = val),
                              choiceItems: C2Choice.listFrom<String, String>(
                                source: castDynamicListToStrinList(this.widget.product.changes),
                                value: (i, v) => v,
                                label: (i, v) => v,
                                tooltip: (i, v) => v,
                              ),
                            ),
                          ),
                        ) : SizedBox(height: 1.0,),
                        RaisedButton(
                            child: Text(
                              "Aggiungi al Carrello", overflow: TextOverflow.ellipsis , style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'LoraFont'),
                            ),
                            color: Colors.teal.shade800,
                            onPressed: (){
                              if(_counter != 0){
                                cartProductList.add(Cart(
                                    product: this.widget.product,
                                    numberOfItem: _counter,
                                    changes: choicedChangesList));
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
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(Utils.getIngredientsFromProduct(this.widget.product), overflow: TextOverflow.visible, style: TextStyle(fontSize: 15.0, fontFamily: 'LoraFont'),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: this.widget.product.category == 'wine' ?
                          Text('Cantina: ' +  this.widget.product.changes[0], overflow: TextOverflow.visible , style: TextStyle(fontSize: 15.0, fontFamily: 'LoraFont'),)
                              : SizedBox(height: 0.0,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: this.widget.product.category == 'wine' ?
                          Text(Utils.getAllergensFromProduct(this.widget.product), overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 16.0, fontFamily: 'LoraFont'),)
                              : Text('Allergeni: ' +  Utils.getAllergensFromProduct(this.widget.product), overflow: TextOverflow.visible , style: TextStyle(fontSize: 13.0, fontFamily: 'LoraFont'),),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          child:
                          Image.asset(this.widget.product.image, width: screenWidth - 100, height: screenHeight - 600, fit: BoxFit.fitHeight,),
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

  List<String> castDynamicListToStrinList(List<dynamic> changes) {
    List<String> output = [];
    changes.forEach((element) {
      output.add(element.toString());
    }
    );
    return output;
  }
}

class Content extends StatefulWidget {

  final Widget child;

  Content({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> with AutomaticKeepAliveClientMixin<Content>  {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
            fit: FlexFit.loose,
            child: widget.child
        ),
      ],
    );
  }
}
