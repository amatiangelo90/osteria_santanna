import 'package:delivery_santanna/models/cart.dart';
import 'package:delivery_santanna/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class InputFormScreen extends StatefulWidget {

  final List<Cart> cartItems;
  final double total;

  InputFormScreen({@required this.cartItems, this.total});

  @override
  _InputFormScreenState createState() => _InputFormScreenState();
}

class _InputFormScreenState extends State<InputFormScreen> {

  List<City> _cities = City.getCities();
  List<TimeSlotDelivery> _slotsDelivery = TimeSlotDelivery.getDeliverySlots();
  List<TimeSlotPickup> _slotsPicker = TimeSlotPickup.getPickupSlots();

  List<DropdownMenuItem<City>> _dropdownCitytems;
  List<DropdownMenuItem<TimeSlotDelivery>> _dropdownTimeSlotDelivery;
  List<DropdownMenuItem<TimeSlotPickup>> _dropdownTimeSlotPickup;

  City _selectedCity;
  TimeSlotDelivery _selectedTimeSlotDelivery;
  TimeSlotPickup _selectedTimeSlotPikup;

  double _currentTotal = 0.0;

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _dropdownCitytems = buildDropdownCityMenu(_cities);
    _selectedCity = _dropdownCitytems[0].value;

    _dropdownTimeSlotDelivery = buildDropdownSlotDelivery(_slotsDelivery);
    _selectedTimeSlotDelivery = _dropdownTimeSlotDelivery[0].value;

    _dropdownTimeSlotPickup = buildDropdownSlotPickup(_slotsPicker);
    _selectedTimeSlotPikup = _dropdownTimeSlotPickup[0].value;

    if(this.widget.total <30){
      _currentTotal = this.widget.total + 3.0;
    }else{
      _currentTotal = this.widget.total;
    }
    super.initState();
  }

  List<DropdownMenuItem<City>> buildDropdownCityMenu(List cities) {
    List<DropdownMenuItem<City>> items = [];
    for (City city in cities) {
      items.add(
        DropdownMenuItem(
          value: city,
          child: Center(child: Text(city.name, style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),)),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<TimeSlotDelivery>> buildDropdownSlotDelivery(List slots) {
    List<DropdownMenuItem<TimeSlotDelivery>> items = [];
    for (TimeSlotDelivery slotItem in slots) {
      items.add(
        DropdownMenuItem(
          value: slotItem,
          child: Center(child: Text(slotItem.slot, style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),)),
        ),
      );
    }
    return items;
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




  onChangeDropdownItem(City currentSelectedCity) {
    setState(() {
      _selectedCity = currentSelectedCity;
    });
  }

  onChangeDropTimeSlotDelivery(TimeSlotDelivery currentTimeSlot) {
    setState(() {
      _selectedTimeSlotDelivery = currentTimeSlot;
    });
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.delivery_dining, color: Colors.teal.shade800,),),
              Tab(icon: Icon(Icons.shopping_bag, color: Colors.teal.shade800,),),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
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
                              child: Center(child: Text('Dati Consegna', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),),
                            ),
                            Card(
                              elevation: 0.0,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Spedizione ', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                      this.widget.total < 30.0
                                          ? Text('€ 3', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),)
                                          : Text('€ 0', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Totale € $_currentTotal', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
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
                                    autofocus: true,
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
                              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                              child: Center(
                                child: Card(
                                  child: TextField(
                                    autofocus: false,
                                    controller: _addressController,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Indirizzo',
                                    ),
                                  ),
                                ),
                              ),
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
                                          iconSize: 40.0,
                                          isExpanded: true,
                                          value: _selectedCity,
                                          items: _dropdownCitytems,
                                          onChanged: onChangeDropdownItem,
                                        ),
                                      ),
                                      Text("Cap: " + _selectedCity.cap, style: TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'LoraFont'),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Fascia Oraria', style: TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'LoraFont'),),
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
                                          value: _selectedTimeSlotDelivery,
                                          items: _dropdownTimeSlotDelivery,
                                          onChanged: onChangeDropTimeSlotDelivery,
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
                                            icon: Image.asset('images/whatapp_icon_c.png'),
                                            iconSize: 100.0, onPressed: (){
                                          HttpService.sendMessage("393454937047",
                                            buildMessageFromCartDelivery(
                                                this.widget.cartItems,
                                                _nameController.value.text,
                                                _selectedCity.name + ' (${_selectedCity.cap})',
                                                _addressController.value.text,
                                                getCurrentDateTime(),
                                                _currentTotal.toString(),
                                                _selectedTimeSlotDelivery.slot),
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
            ListView(
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
                              child: Center(child: Text('Dati Asporto', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),),
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
                                        Text('Totale € ' + this.widget.total.toString() , style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
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
                                            icon: Image.asset('images/whatapp_icon_c.png'),
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
          ],
        ),
      ),
    );
  }

  buildMessageFromCartDelivery(List<Cart> cartItems, String name, String city, String address, String date, String total, String slot) {
    String itemList = '';

    cartItems.forEach((element) {
      itemList = itemList + "%0a" + element.numberOfItem.toString() + " x " + element.product.name;
    });

    String message =
        "ORDINE DELIVERY%0a" +
        "%0a%0aOsteria Sant'Anna%0a" +
        itemList + "%0a"
        + "%0aTotale ordine : " + total + " € " +
        "%0a----------------------------------"
            "%0aIndirizzo: $address"
            "%0aCittà: $city"
            "%0a%0aData Ordine: $date"
            "%0aOre Consegna: $slot "
            "%0a"
            "%0a"
            "%0aOsteria Sant'Anna confermerà il vostro ordine nel minor tempo possibile"
            "%0a"
            "%0aOrdine Effettuato da: $name";

    message = message.replaceAll('&', '%26');
    return message;
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

class TimeSlotDelivery {
  int id;
  String slot;

  TimeSlotDelivery(this.id, this.slot);

  static List<TimeSlotDelivery> getDeliverySlots() {
    return <TimeSlotDelivery>[
      TimeSlotDelivery(1, '19:30 - 20:30'),
      TimeSlotDelivery(2, '20:30 - 21:30'),
      TimeSlotDelivery(3, '21:30 - 22:30'),
    ];
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

class City {
  int id;
  String name;
  String cap;

  City(this.id, this.name, this.cap);

  static List<City> getCities() {
    return <City>[
      City(1, 'Cisternino','72014'),
      City(2, 'Martina Franca','74015'),
      City(3, 'Locorotondo','70010'),
      City(4, 'Casalini','72014'),
      City(5, 'Fasano/Pezze Di Greco','72015'),
    ];
  }
}

