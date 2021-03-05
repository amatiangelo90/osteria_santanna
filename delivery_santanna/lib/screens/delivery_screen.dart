import 'package:delivery_santanna/models/cart.dart';
import 'package:delivery_santanna/services/http_service.dart';
import 'package:delivery_santanna/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:delivery_santanna/utils/costants.dart';

class DeliveryScreen extends StatefulWidget {

  final List<Cart> cartItems;
  final double total;

  DeliveryScreen({@required this.cartItems, this.total});

  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {

  List<City> _cities = City.getCities();
  List<TimeSlotDelivery> _slotsDelivery = TimeSlotDelivery.getDeliverySlots();

  List<DropdownMenuItem<City>> _dropdownCitytems;
  List<DropdownMenuItem<TimeSlotDelivery>> _dropdownTimeSlotDelivery;

  City _selectedCity;
  TimeSlotDelivery _selectedTimeSlotDelivery;
  DateTime _selectedDateTime;
  double _currentTotal = 0.0;

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _datePikerController = DatePickerController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _dropdownCitytems = buildDropdownCityMenu(_cities);
    _selectedCity = _dropdownCitytems[0].value;

    _dropdownTimeSlotDelivery = buildDropdownSlotDelivery(_slotsDelivery);
    _selectedTimeSlotDelivery = _dropdownTimeSlotDelivery[0].value;


    if(this.widget.total <50){
      _currentTotal = this.widget.total + 3.0;
    }else{
      _currentTotal = this.widget.total;
    }
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

  onChangeDropdownItem(City currentSelectedCity) {
    setState(() {
      _selectedCity = currentSelectedCity;
      if(currentSelectedCity.name == 'Carovigno'){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Info', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
              content: Text('La consegna a Carovigno è disponibile con punto di incontro presso Corso Umberto n.1 (Rotonda con il delfino)', style: TextStyle(color: Colors.black, fontSize: 13.0, fontFamily: 'LoraFont'),),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Ok"),
                ),
              ],
            );
          },
        );
      }
    });
  }

  onChangeDropTimeSlotDelivery(TimeSlotDelivery currentTimeSlot) {
    setState(() {
      _selectedTimeSlotDelivery = currentTimeSlot;
    });
  }

  @override
  Widget build(BuildContext context) {

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: Text('Indietro', style: TextStyle(color: Colors.black, fontSize: 17.0, fontFamily: 'LoraFont'),),
                        onTap: () => Navigator.of(context).pop(false),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Card(
                        elevation: 0.0,
                        child: Column(
                          children: [
                            Text('Dettagli Consegna', style: TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'LoraFont'),),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Totale € $_currentTotal', style: TextStyle(color: Colors.black, fontSize: 19.0, fontFamily: 'LoraFont'),),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('(Spedizione ', style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                                this.widget.total < 50.0
                                    ? Text('€ 3)', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),)
                                    : Text('€ 0)', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                              ],
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
                        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
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
                                    value: _selectedCity,
                                    items: _dropdownCitytems,
                                    onChanged: onChangeDropdownItem,
                                  ),
                                ),
                                _selectedCity.cap == '' ?
                                Text(''):
                                Text("Cap: " + _selectedCity.cap, style: TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'LoraFont'),),
                              ],
                            ),
                          ),
                        ),
                      ),
                      _selectedCity.name == 'Carovigno' ? Card(
                        elevation: 2.0,
                        child: Text('Consegna prezzo Corso Umbero N°1', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                      ) :
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                        child: Center(
                          child: Card(
                            child: TextField(
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          DatePicker(
                            DateTime.now(),
                            activeDates: Utils.getAvailableData(),
                            dateTextStyle: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),
                            dayTextStyle: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),
                            monthTextStyle: TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'LoraFont'),
                            selectionColor: Colors.teal,
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                        child: Center(
                          child: Card(
                            borderOnForeground: true,
                            elevation: 0.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: IconButton(
                                    icon: Image.asset('images/whatapp_icon_c.png'),
                                    iconSize: 90.0, onPressed: (){
                                    if(_nameController.value.text == ''){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                            content: Text('Inserire il nome', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                            actions: <Widget>[
                                              FlatButton(
                                                onPressed: () => Navigator.of(context).pop(false),
                                                child: const Text("Indietro"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }else if (_selectedCity.name != 'Carovigno' && _addressController.value.text == ''){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                            content: Text('Inserire un indirizzo valido', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                            actions: <Widget>[
                                              FlatButton(
                                                onPressed: () => Navigator.of(context).pop(false),
                                                child: const Text("Indietro"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }else if(_selectedDateTime == null){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                            content: Text('Selezionare una data di consegna valida', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                            actions: <Widget>[
                                              FlatButton(
                                                onPressed: () => Navigator.of(context).pop(false),
                                                child: const Text("Indietro"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }else if(_selectedCity.cap == ''){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                            content: Text('Selezionare la città', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                            actions: <Widget>[
                                              FlatButton(
                                                onPressed: () => Navigator.of(context).pop(false),
                                                child: const Text("Indietro"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }else if(_selectedTimeSlotDelivery.slot == 'Seleziona Fascia Oraria Consegna'){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                            content: Text('Selezionare la fascia oraria per la consegna', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                            actions: <Widget>[
                                              FlatButton(
                                                onPressed: () => Navigator.of(context).pop(false),
                                                child: const Text("Indietro"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else if(_selectedDateTime.day == DateTime.now().day && DateTime.now().hour == 18){
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Attenzione', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                                content: Text('Per ordini delivery effettuati dopo le ore 18 non ci è possibile garantire la consegna, cercheremo ugualmente di soddisfarla se è nelle nostre possibilità. Inoltri la richiesta d\'ordine e le risponderemo al piu presto', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                                actions: <Widget>[
                                                  FlatButton(
                                                      onPressed: (){
                                                        HttpService.sendMessage(numberSantAnna,
                                                          buildMessageFromCartDelivery(
                                                              this.widget.cartItems,
                                                              _nameController.value.text,
                                                              _selectedCity.name + ' (${_selectedCity.cap})',
                                                              _addressController.value.text,
                                                              getCurrentDateTime(),
                                                              _currentTotal.toString(),
                                                              _selectedTimeSlotDelivery.slot,
                                                              _selectedDateTime),
                                                        );
                                                        Navigator.of(context).pop(true);
                                                      },
                                                      child: const Text("Procedi")
                                                  ),
                                                  FlatButton(
                                                    onPressed: () => Navigator.of(context).pop(false),
                                                    child: const Text("Indietro"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }else {
                                        HttpService.sendMessage(numberSantAnna,
                                          buildMessageFromCartDelivery(
                                              this.widget.cartItems,
                                              _nameController.value.text,
                                              _selectedCity.name + ' (${_selectedCity.cap})',
                                              _addressController.value.text,
                                              getCurrentDateTime(),
                                              _currentTotal.toString(),
                                              _selectedTimeSlotDelivery.slot,
                                              _selectedDateTime),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildMessageFromCartDelivery(List<Cart> cartItems,
      String name,
      String city,
      String address,
      String date,
      String total,
      String slot,
      DateTime dateTime) {

    String itemList = '';


    cartItems.forEach((element) {
      itemList = itemList + "%0a" + element.numberOfItem.toString() + " x " + element.product.name;
      if(element.changes.length != 0){
        itemList = itemList + "%0a  " + element.changes.toString();
      }
    });

    if(city == 'Carovigno (72015)'){
      address = 'Corso Umbero N°1';
    }

    String message =
        "ORDINE DELIVERY%0a%0a" +
            " Nome: $name" +
            "%0a Indirizzo: $address"
                "%0a Città: $city"
                "%0a $slot "
                "%0a " + Utils.getWeekDay(dateTime.weekday) +" ${dateTime.day} " + Utils.getMonthDay(dateTime.month) +
            "%0a"
                "%0a-------------------------------------------------"
                "%0a"
            + itemList + "%0a"
            + "%0aTot. " + total + " € ";


    message = message.replaceAll('&', '%26');
    return message;
  }

  String getCurrentDateTime() {
    var now = new DateTime.now();
    var formatter = new DateFormat.yMd().add_jm();
    return formatter.format(now);
  }

  void setSelectedDate(DateTime date) {
    setState(() {
      _selectedDateTime = date;
    });
  }
}

class TimeSlotDelivery {
  int id;
  String slot;

  TimeSlotDelivery(this.id, this.slot);

  static List<TimeSlotDelivery> getDeliverySlots() {
    return <TimeSlotDelivery>[
      TimeSlotDelivery(1, 'Seleziona Fascia Oraria Consegna'),
      TimeSlotDelivery(2, '19:30 - 20:30'),
      TimeSlotDelivery(3, '20:30 - 21:30'),
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
      City(1, 'Seleziona Città',''),
      City(2, 'Cisternino','72014'),
      City(3, 'Martina Franca','74015'),
      City(4, 'Locorotondo','70010'),
      City(5, 'Fasano/Pezze Di Greco','72015'),
      City(6, 'Ostuni','72017'),
      City(7, 'Ceglie','72013'),
      City(8, 'Carovigno','72012'),
    ];
  }
}

