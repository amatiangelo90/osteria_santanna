import 'package:delivery_santanna/components/icon_content.dart';
import 'package:delivery_santanna/components/reusable_card.dart';
import 'package:delivery_santanna/models/calendar_manager.dart';
import 'package:delivery_santanna/models/cart.dart';
import 'package:delivery_santanna/models/promoclass.dart';
import 'package:delivery_santanna/screens/delivery/delivery_screen.dart';
import 'package:delivery_santanna/screens/delivery/pickup_screen.dart';
import 'package:delivery_santanna/utils/costants.dart';
import 'package:flutter/material.dart';

class DeliveryPickupScreen extends StatefulWidget {

  final List<Cart> cartItems;
  final double total;
  final Promo promo;
  final String uniqueId;
  final List<CalendarManagerClass> listCalendarConfiguration;

  DeliveryPickupScreen({
    @required this.cartItems,
    this.total,
    this.promo,
    this.uniqueId,
    @required this.listCalendarConfiguration});


  @override
  _DeliveryPickupScreenState createState() => _DeliveryPickupScreenState();
}

class _DeliveryPickupScreenState extends State<DeliveryPickupScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Padding(
            padding: EdgeInsets.fromLTRB(30.0, 20.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Text('Indietro', style: TextStyle(color: Colors.black, fontSize: 17.0, fontFamily: 'LoraFont'),),
                  onTap: () => Navigator.of(context).pop(false),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 6,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ReusableCard(
                      color: Colors.white,
                      cardChild: IconContent(label: 'ASPORTO', icon: Icons.shopping_bag_outlined,color: OSTERIA_GOLD, description: '',),
                      onPress: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return PickupScreen(
                                cartItems: this.widget.cartItems,
                                total: this.widget.total,
                                promo: this.widget.promo,
                                uniqueId: this.widget.uniqueId,
                                listCalendarConfiguration: this.widget.listCalendarConfiguration,
                              );
                            }
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: ReusableCard(
                      color: Colors.white,
                      cardChild: IconContent(label: 'DELIVERY', icon: Icons.delivery_dining, color: OSTERIA_GOLD, description: 'Servizio delivery non attivo',),
                      onPress: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(backgroundColor: Colors.red.shade900 ,
                            content: Text('Attenzione! Servizio delivery non attivo')));
                        /*if(DateTime.now().day == 2){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Attenzione', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                  content: Text('Servizio delivery non attivo per il giorno corrente', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text("Indietro"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }else{
                            this.widget.total >= 30 ?
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return DeliveryScreen(
                                    cartItems: this.widget.cartItems,
                                    total: this.widget.total,
                                    promo: this.widget.promo,
                                    uniqueId: this.widget.uniqueId,
                                  );
                                }
                            ) : showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Attenzione', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                  content: Text('Per il servizio delivery il minimo d\'ordine è di € 30', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text("Indietro"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }*/
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
