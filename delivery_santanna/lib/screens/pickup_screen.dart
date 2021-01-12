import 'package:delivery_santanna/models/cart.dart';
import 'package:delivery_santanna/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PickupScreen extends StatefulWidget {

  final List<Cart> cartItems;
  final double total;

  PickupScreen({@required this.cartItems, this.total});

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {


  List<TimeSlotPickup> _slotsPicker = TimeSlotPickup.getPickupSlots();

  List<DropdownMenuItem<TimeSlotPickup>> _dropdownTimeSlotPickup;

  TimeSlotPickup _selectedTimeSlotPikup;


  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {

    _dropdownTimeSlotPickup = buildDropdownSlotPickup(_slotsPicker);
    _selectedTimeSlotPikup = _dropdownTimeSlotPickup[0].value;

    super.initState();
  }

  List<DropdownMenuItem<TimeSlotPickup>> buildDropdownSlotPickup(List slots) {
    List<DropdownMenuItem<TimeSlotPickup>> items = [];
    for (TimeSlotPickup slotItem in slots) {
      items.add(
        DropdownMenuItem(
          value: slotItem,
          child: Center(child: Text(slotItem.slot, style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),)),
        ),
      );
    }
    return items;
  }

  onChangeDropTimeSlotPickup(TimeSlotPickup currentPickupSlot) {
    setState(() {
      _selectedTimeSlotPikup = currentPickupSlot;
    });
  }

  @override
  Widget build(BuildContext context) {

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: screenHeight - 50,
                width: screenWidth - 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Card(
                          elevation: 0.0,
                          child: Center(child: Text('Dati Asporto', style: TextStyle(color: Colors.black, fontSize: 20.0, fontFamily: 'LoraFont'),),),
                        ),
                        Card(
                          elevation: 0.0,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Totale € ' + this.widget.total.toString() , style: TextStyle(color: Colors.black, fontSize: 19.0, fontFamily: 'LoraFont'),),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                          child: Center(
                            child: Card(
                              child: TextField(
                                controller: _nameController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Nome',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text('Orario Asporto', style: TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'LoraFont'),)),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
                          child: Center(
                            child: Card(
                              borderOnForeground: true,
                              elevation: 1.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      value: _selectedTimeSlotPikup,
                                      items: _dropdownTimeSlotPickup,
                                      onChanged: onChangeDropTimeSlotPickup,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Card(
                            shadowColor: Colors.black,
                            elevation: 0.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    IconButton(
                                        icon: Image.asset('images/whatapp_icon.png'),
                                        iconSize: 100.0, onPressed: (){
                                      HttpService.sendMessage("393454937047",
                                        buildMessageFromCartPickUp(
                                            this.widget.cartItems,
                                            _nameController.value.text,
                                            this.widget.total.toString(),
                                            getCurrentDateTime(),
                                            _selectedTimeSlotPikup.slot),
                                      );
                                    }),
                                    Text('Invia', style: TextStyle(color: Colors.black, fontSize: 19.0, fontFamily: 'LoraFont'),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  String buildMessageFromCartPickUp(List<Cart> cartItems, String name, String total, String date, String slot) {
    String itemList = '';

    cartItems.forEach((element) {
      itemList = itemList + "%0a" + element.numberOfItem.toString() + " x " + element.product.name;
    });

    String message =
        "ORDINE ASPORTO%0a" +
            "%0aOsteria Sant'Anna%0a"
            + itemList + "%0a"
            + "%0aTotale ordine : " + total + " € " +
            "%0a----------------------------------"
                "%0aIndirizzo Ritiro: Viale Stazione 12"
                "%0aCittà: Cisternino (72014)"
                "%0aProvincia: BR"
                "%0a%0aData Ordine: $date"
                "%0aOre Ritiro: $slot "
                "%0a"
                "%0a"
                "%0aOsteria Sant'Anna confermerà il vostro ordine nel minor tempo possibile"
                "%0a"
                "%0aOrdine Effettuato da: $name";

    message = message.replaceAll('&', '%26');
    return message;

  }


  String getCurrentDateTime() {
    var now = new DateTime.now();
    var formatter = new DateFormat.yMd().add_jm();
    return formatter.format(now);
  }
}

class TimeSlotPickup {
  int id;
  String slot;

  TimeSlotPickup(this.id, this.slot);

  static List<TimeSlotPickup> getPickupSlots() {
    return <TimeSlotPickup>[
      TimeSlotPickup(1, '19:30'),
      TimeSlotPickup(2, '20:00'),
      TimeSlotPickup(3, '20:30'),
      TimeSlotPickup(4, '21:00'),
      TimeSlotPickup(5, '21:30'),
      TimeSlotPickup(6, '22:00'),
      TimeSlotPickup(7, '22:30'),
    ];
  }
}

