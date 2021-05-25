import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:delivery_santanna/dao/crud_model.dart';
import 'package:delivery_santanna/models/calendar_manager.dart';
import 'package:delivery_santanna/models/timeslot.dart';
import 'package:delivery_santanna/screens/menu/a_la_carte_screen.dart';
import 'package:delivery_santanna/services/http_service.dart';
import 'package:delivery_santanna/utils/costants.dart';
import 'package:delivery_santanna/utils/round_icon_botton.dart';
import 'package:delivery_santanna/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class TableReservationScreen extends StatefulWidget {

  static String id = 'reservation';

  final List<CalendarManagerClass> listCalendarConfiguration;

  TableReservationScreen({@required this.listCalendarConfiguration});

  @override
  _TableReservationScreenState createState() => _TableReservationScreenState();
}

class _TableReservationScreenState extends State<TableReservationScreen> {

  DateTime _selectedDateTime;
  final _datePikerController = DatePickerController();
  int _covers = 1;

  List<TimeSlotPickup> _slotsPicker = TimeSlotPickup.getTimeSlots();
  List<DropdownMenuItem<TimeSlotPickup>> _dropdownTimeSlotPickup;
  TimeSlotPickup _selectedTimeSlotPikup;

  final _nameController = TextEditingController();
  final _detailsReservationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _detailsReservationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print(this.widget.listCalendarConfiguration);
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
                                    child: Text('Vai al Menù', style: TextStyle(color: Colors.black, fontSize: 17.0, fontFamily: 'LoraFont'),),
                                    onTap: ()=> Navigator.pushNamed(context, ALaCarteMenuScreen.id),
                                  ),
                                ],
                              ),
                              Center(child: Text('Richiesta Prenotazione', style: TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'LoraFont'),),),

                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Card(
                            elevation: 0.0,
                            child: Column(
                              children: [
                                Text('Osteria Sant\'Anna', style: TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'LoraFont'),),
                                Text('Viale Stazione 12', style: TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'LoraFont'),),
                                Text('Cisternino (BR) - Cap 72014', style: TextStyle(color: Colors.black, fontSize: 15.0, fontFamily: 'LoraFont'),),
                              ],
                            ),
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
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RoundIconButton(
                                icon: FontAwesomeIcons.minus,
                                function: () {
                                  setState(() {
                                    if(_covers > 1)
                                      _covers = _covers - 1;
                                  });
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Coperti : ' + _covers.toString(), style: TextStyle(fontSize: 20.0, fontFamily: 'LoraFont'),),
                              ),
                              RoundIconButton(
                                icon: FontAwesomeIcons.plus,
                                function: () {
                                  setState(() {
                                    _covers = _covers + 1;
                                  });
                                },
                              ),
                            ],
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
                                  _setSelectedDate(date);
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                          child: Center(
                            child: Card(
                              child: TextField(
                                controller: _detailsReservationController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Note',
                                ),
                                maxLines: 4,
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
                                    content: Text('Selezionare la data per la prenotazione', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text("Indietro"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else if(_selectedTimeSlotPikup.slot == 'Seleziona Orario'){
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                    content: Text('Seleziona Orario', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text("Indietro"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              HttpService.sendMessage(numberSantAnna,
                                  buildMessageReservation(
                                      _nameController.value.text,
                                      getCurrentDateTime(),
                                      _selectedTimeSlotPikup.slot,
                                      _selectedDateTime,
                                      _covers.toString(),
                                      _detailsReservationController.value.text),
                                  _nameController.value.text,
                                  '0',
                                  getCurrentDateTime(),
                                  null,
                                  '',
                                  '',
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


  String buildMessageReservation(
      String name,
      String date,
      String slot,
      DateTime selectedDateTime,
      String coperti,
      String detailsReservation
      ) {


    String message =
        "RICHIESTA PRENOTAZIONE%0a" +
            "%0aOsteria Sant'Anna%0a"+
            "%0aNome: $name%0a" +
            "%0aIndirizzo: Viale Stazione 12" +
            "%0aCittà: Cisternino(BR) (72014)" +
            "%0a" +
            "%0aData Prenotazione: " + Utils.getWeekDay(selectedDateTime.weekday) +" ${selectedDateTime.day} " + Utils.getMonthDay(selectedDateTime.month) +

            "%0aOre: $slot " +
            "%0aCoperti : $coperti"
                "%0a%0aNote : $detailsReservation"
    ;

    message = message.replaceAll('&', '%26');
    return message;

  }


  String getCurrentDateTime() {
    var now = new DateTime.now();
    var formatter = new DateFormat.yMd().add_jm();
    return formatter.format(now);
  }

  _setSelectedDate(DateTime date) {
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

