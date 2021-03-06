import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:delivery_santanna/dao/crud_model.dart';
import 'package:delivery_santanna/models/calendar_manager.dart';
import 'package:delivery_santanna/models/cart.dart';
import 'package:delivery_santanna/models/promoclass.dart';
import 'package:delivery_santanna/models/timeslot.dart';
import 'package:delivery_santanna/services/http_service.dart';
import 'package:delivery_santanna/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:delivery_santanna/utils/costants.dart';

class PickupScreen extends StatefulWidget {

  final List<Cart> cartItems;
  final double total;
  final Promo promo;
  final String uniqueId;
  final List<CalendarManagerClass> listCalendarConfiguration;

  PickupScreen({@required this.cartItems, this.total, this.promo,@required this.uniqueId, @required this.listCalendarConfiguration});

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {

  DateTime _selectedDateTime;
  final _datePikerController = DatePickerController();

  List<TimeSlotPickup> _slotsPicker = TimeSlotPickup.getTimeSlots();
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    child: Text('Indietro', style: TextStyle(color: Colors.black, fontSize: 17.0, fontFamily: 'LoraFont'),),
                                    onTap: () => Navigator.of(context).pop(false),
                                  ),
                                ],
                              ),
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
                                activeDates: _buildActiveDateListFromConfigurationList(this.widget.listCalendarConfiguration),
                                dateTextStyle: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),
                                dayTextStyle: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),
                                monthTextStyle: TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'LoraFont'),

                                selectionColor: OSTERIA_GOLD,
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
                            iconSize: 90.0, onPressed: () async {
                          try{
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
                            } else if(_selectedDateTime.day == DateTime.now().day && DateTime.now().hour == 20) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Attenzione', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                    content: Text('Non ci è possibile garantire la preparazione degli ordini asporto se effettuati dopo le ore 20, cercheremo di soddisfarla se è nelle nostre possibilità. Inoltri la richiesta d\'ordine e le risponderemo al più presto', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: (){
                                            HttpService.sendMessage(numberSantAnna,
                                                buildMessageFromCartPickUp(
                                                    this.widget.cartItems,
                                                    _nameController.value.text,
                                                    this.widget.total.toString(),
                                                    getCurrentDateTime(),
                                                    _selectedTimeSlotPikup.slot,
                                                    _selectedDateTime,
                                                    this.widget.promo),
                                                _nameController.value.text,
                                                this.widget.total.toString(),
                                                getCurrentDateTime(),
                                                this.widget.cartItems,
                                                this.widget.uniqueId,
                                                PICKUP_TYPE,
                                                Utils.getWeekDay(_selectedDateTime.weekday) +" ${_selectedDateTime.day} " + Utils.getMonthDay(_selectedDateTime.month),
                                                _selectedTimeSlotPikup.slot,
                                                EMPTY_STRING,
                                                EMPTY_STRING
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
                            } else {
                              HttpService.sendMessage(
                                  numberSantAnna,
                                  buildMessageFromCartPickUp(
                                      this.widget.cartItems,
                                      _nameController.value.text,
                                      this.widget.total.toString(),
                                      getCurrentDateTime(),
                                      _selectedTimeSlotPikup.slot,
                                      _selectedDateTime,
                                      this.widget.promo),
                                  _nameController.value.text,
                                  this.widget.total.toString(),
                                  getCurrentDateTime(),
                                  this.widget.cartItems,
                                  this.widget.uniqueId,
                                  PICKUP_TYPE,
                                  Utils.getWeekDay(_selectedDateTime.weekday) +" ${_selectedDateTime.day} " + Utils.getMonthDay(_selectedDateTime.month),
                                  _selectedTimeSlotPikup.slot,
                                  EMPTY_STRING,
                                  EMPTY_STRING
                              );
                            }
                          }catch(e){
                            CRUDModel crudModel = CRUDModel('errors-report');
                            await crudModel.addException(
                                'Error report',
                                e.toString(),
                                DateTime.now().toString());
                          }
                        }
                        ),
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
      DateTime selectedDateTime,
      Promo promo) {

    String itemList = '';

    cartItems.forEach((element) {
      itemList = itemList + "%0a" + element.numberOfItem.toString() + " x " + element.product.name;
      if(element.changes.length != 0){
        itemList = itemList + "%0a  " + element.changes.toString();
      }
    });

    String message;
    if(promo.isPromoApplied){
      message =
          "ORDINE ASPORTO%0a" +
              "%0aOsteria Sant'Anna%0a"+
              "%0aNome: $name" +
              "%0aIndirizzo Ritiro: Viale Stazione 12" +
              "%0aCittà: Cisternino (72014)" +
              "%0aProvincia: BR" +
              "%0aData Ritiro: " + Utils.getWeekDay(selectedDateTime.weekday) +" ${selectedDateTime.day} " + Utils.getMonthDay(selectedDateTime.month) +
              "%0aOre Ritiro: $slot " +
              "%0a%0a-------------------------------------------------%0a" +
              itemList + "%0a"

              "%0a%0aCodice promo applicato [" + this.widget.promo.code + "]" +
              /*"%0aSconto Applicato: " + this.widget.promo.discount.toString() + " " +*/
              "%0a"
              + "%0aTot. " + total + " € ";
    }else{
      message =
          "ORDINE ASPORTO%0a" +
              "%0aOsteria Sant'Anna%0a"+
              "%0aNome: $name" +
              "%0aIndirizzo Ritiro: Viale Stazione 12" +
              "%0aCittà: Cisternino (72014)" +
              "%0aProvincia: BR" +
              "%0aData Ritiro: " + Utils.getWeekDay(selectedDateTime.weekday) +" ${selectedDateTime.day} " + Utils.getMonthDay(selectedDateTime.month) +
              "%0aOre Ritiro: $slot " +
              "%0a%0a-------------------------------------------------%0a"
              + itemList + "%0a"
              + "%0aTot. " + total + " € ";
    }
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

    setState(() {
      switch(_retrieveServiceConfigurationByDateAndConfList(_selectedDateTime, this.widget.listCalendarConfiguration)){
        case 'Dinner':
          print('Dinner');
          _dropdownTimeSlotPickup = buildDropdownSlotPickup(TimeSlotPickup.getDinnerSlots());
          _selectedTimeSlotPikup = _dropdownTimeSlotPickup[0].value;
          break;
        case 'Lunch':
          print('Lunch');
          _dropdownTimeSlotPickup = buildDropdownSlotPickup(TimeSlotPickup.getTimeLunchSlots());
          _selectedTimeSlotPikup = _dropdownTimeSlotPickup[0].value;
          break;
        case 'AllDay':
          print('AllDay');
          _dropdownTimeSlotPickup = buildDropdownSlotPickup(TimeSlotPickup.getTimeSlots());
          _selectedTimeSlotPikup = _dropdownTimeSlotPickup[0].value;
          break;
      }
    });
  }

  _buildActiveDateListFromConfigurationList(List<CalendarManagerClass> listCalendarConfiguration) {
    List<DateTime> activeDateList = <DateTime>[];
    if(listCalendarConfiguration == null){
      return activeDateList;
    }
    if(listCalendarConfiguration != null && listCalendarConfiguration.length == 0){
      return activeDateList;
    }
    listCalendarConfiguration.forEach((element) {
      activeDateList.add(DateTime.fromMillisecondsSinceEpoch(int.parse(element.date)));
    });

    return activeDateList;
  }

  String _retrieveServiceConfigurationByDateAndConfList(
      DateTime date,
      List<CalendarManagerClass> listCalendarConfiguration) {

    String currentConfiguration = 'AllDay';
    listCalendarConfiguration.forEach((element) {

      if(date.year == DateTime.fromMillisecondsSinceEpoch(int.parse(element.date)).year &&
          date.month == DateTime.fromMillisecondsSinceEpoch(int.parse(element.date)).month &&
          date.day == DateTime.fromMillisecondsSinceEpoch(int.parse(element.date)).day){
        print(element.toString());
        if(!element.isDinnerTime){
          currentConfiguration = 'Lunch';
        }
        if(!element.isLunchTime){
          currentConfiguration = 'Dinner';
        }
      }
    });
    return currentConfiguration;
  }
}

