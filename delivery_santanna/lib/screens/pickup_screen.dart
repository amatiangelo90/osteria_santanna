import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:delivery_santanna/models/cart.dart';
import 'package:delivery_santanna/services/http_service.dart';
import 'package:delivery_santanna/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:delivery_santanna/utils/costants.dart';

class PickupScreen extends StatefulWidget {

  final List<Cart> cartItems;
  final double total;

  PickupScreen({@required this.cartItems, this.total});

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {

  DateTime _selectedDateTime;
  final _datePikerController = DatePickerController();

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
                          child: Column(
                            children: [
                              Center(child: Text('Dettagli Asporto', style: TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'LoraFont'),),),
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Totale € ' + this.widget.total.toString() , style: TextStyle(color: Colors.black, fontSize: 20.0, fontFamily: 'LoraFont'),),
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
                          padding: const EdgeInsets.only(top: 5),
                          child: Card(
                            elevation: 0.0,
                            child: Column(
                              children: [
                                Text('Indirizzo Ritiro', style: TextStyle(color: Colors.black, fontSize: 13.0, fontFamily: 'LoraFont'),),
                                Text('Viale Stazione 12', style: TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'LoraFont'),),
                                Text('Cisternino (BR) - Cap 72014', style: TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'LoraFont'),),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Column(
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
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 3.0),
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
                        IconButton(
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
                          }else if(_selectedDateTime == null){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                  content: Text('Selezionare una data di ritiro valida', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text("Indietro"),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if(_selectedTimeSlotPikup.slot == 'Seleziona Orario Ritiro'){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                  content: Text('Seleziona Orario Ritiro', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
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
                            HttpService.sendMessage(numberSantAnna,
                              buildMessageFromCartPickUp(
                                  this.widget.cartItems,
                                  _nameController.value.text,
                                  this.widget.total.toString(),
                                  getCurrentDateTime(),
                                  _selectedTimeSlotPikup.slot,
                                  _selectedDateTime),
                            );
                          }
                        }),
                      ],
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


  String buildMessageFromCartPickUp(
      List<Cart> cartItems,
      String name,
      String total,
      String date,
      String slot,
      DateTime selectedDateTime) {

    String itemList = '';

    cartItems.forEach((element) {
      itemList = itemList + "%0a" + element.numberOfItem.toString() + " x " + element.product.name;
      if(element.changes.length != 0){
        itemList = itemList + "%0a  " + element.changes.toString();
      }
    });

    String message =
        "ORDINE ASPORTO%0a" +
            "%0aOsteria Sant'Anna%0a"+
            "%0aNome: $name" +
            "%0aIndirizzo Ritiro: Viale Stazione 12" +
            "%0aCittà: Cisternino (72014)" +
            "%0aProvincia: BR" +
            "%0aData Ritiro: " + Utils.getWeekDay(selectedDateTime.day) +" ${selectedDateTime.day} " + Utils.getMonthDay(selectedDateTime.month) +
            "%0aOre Ritiro: $slot " +
            "%0a%0a-------------------------------------------------%0a"
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

class TimeSlotPickup {
  int id;
  String slot;

  TimeSlotPickup(this.id, this.slot);

  static List<TimeSlotPickup> getPickupSlots() {
    return <TimeSlotPickup>[
      TimeSlotPickup(1, 'Seleziona Orario Ritiro'),
      TimeSlotPickup(2, '19:30'),
      TimeSlotPickup(3, '20:00'),
      TimeSlotPickup(4, '20:30'),
      TimeSlotPickup(5, '21:00'),
      TimeSlotPickup(6, '21:30'),
      TimeSlotPickup(7, '22:00'),
      TimeSlotPickup(8, '22:30'),
    ];
  }
}

