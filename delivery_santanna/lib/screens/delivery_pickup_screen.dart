import 'package:delivery_santanna/components/icon_content.dart';
import 'package:delivery_santanna/components/reusable_card.dart';
import 'package:delivery_santanna/models/cart.dart';
import 'package:delivery_santanna/screens/delivery_screen.dart';
import 'package:delivery_santanna/screens/pickup_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DeliveryPickupScreen extends StatefulWidget {

  final List<Cart> cartItems;
  final double total;

  DeliveryPickupScreen({@required this.cartItems, this.total});

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
            padding: const EdgeInsets.all(20.0),
            child: Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
          ),
          Flexible(
            flex: 6,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: ReusableCard(
                        color: Colors.white,
                        cardChild: IconContent(label: 'ASPORTO', icon: Icons.shopping_bag_outlined,color: Colors.teal.shade800,description: '',),
                        onPress: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return PickupScreen(cartItems: this.widget.cartItems, total: this.widget.total,);
                              }
                          );
                        },
                      )),
                  Expanded(
                      child: ReusableCard(
                        color: Colors.white,
                        cardChild: IconContent(label: 'DELIVERY', icon: Icons.delivery_dining, color: Colors.teal.shade800, description: 'Costo spedizione €3. Per ordini superiori a 50 € la spedizione è gratuita',),
                        onPress: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return DeliveryScreen(cartItems: this.widget.cartItems, total: this.widget.total, );
                              }
                          );
                        },
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
