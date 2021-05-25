import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:delivery_santanna/dao/crud_model.dart';
import 'package:delivery_santanna/models/calendar_manager.dart';
import 'package:delivery_santanna/utils/costants.dart';
import 'package:delivery_santanna/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarManager extends StatefulWidget {

  static String id = 'calendar_manager';

  @override
  _CalendarManagerState createState() => _CalendarManagerState();
}

class _CalendarManagerState extends State<CalendarManager> {
  final _datePikerController = DatePickerController();
  CRUDModel crudModel;
  DateTime _currentDateTime;
  CalendarManagerClass _currentCalendarManagerClass;
  bool _isClosed = true;
  bool _isOpen = false;
  bool _isLunchTime = false;
  bool _isDinnerTime = false;

  @override
  void initState() {
    _currentDateTime = DateTime.now();
    crudModel = CRUDModel(calendarSettings);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Gestione Calendario',style: TextStyle(color: Colors.white, fontSize: 20.0,)),
          backgroundColor: Colors.black,
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: FutureBuilder(
                        initialData: <Widget>[Column(
                          children: [
                            Center(child: CircularProgressIndicator()),
                            SizedBox(),
                            Center(child: Text('Caricamento menù..',
                              style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'LoraFont'),
                            ),),
                          ],
                        )],
                        future: createBodyCalendarManager(),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            return Padding(
                              padding: EdgeInsets.all(8.0),
                              child: ListView(
                                primary: false,
                                shrinkWrap: true,
                                children: snapshot.data,
                              ),
                            );
                          }else{
                            return CircularProgressIndicator();
                          }
                        },
                      )
                  ),


                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Widget>> createBodyCalendarManager() async {

    List<Widget> futureList = <Widget>[];
    List<CalendarManagerClass> listCalendarConfiguration = await crudModel.fetchCalendarConfiguration();

    _currentCalendarManagerClass = retrieveCurrentCalendarConfigurationBySelectedDate(_currentDateTime, listCalendarConfiguration);

    print(_currentCalendarManagerClass.toString());

    if(_currentCalendarManagerClass != null){
      _isClosed = _currentCalendarManagerClass.isClosed;
      _isOpen = _currentCalendarManagerClass.isOpen;
      _isLunchTime = _currentCalendarManagerClass.isLunchTime;
      _isDinnerTime = _currentCalendarManagerClass.isDinnerTime;
    }

    futureList.add(Container(
      child: Column(
        children: [
          DatePicker(
            DateTime.now(),
            initialSelectedDate: DateTime.now(),
            /*activeDates: buildListDateActiveFromCalendarConfiguration(listCalendarConfiguration),*/
            dateTextStyle: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),
            dayTextStyle: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),
            monthTextStyle: TextStyle(color: Colors.black, fontSize: 12.0, fontFamily: 'LoraFont'),
            selectionColor: OSTERIA_GOLD,
            deactivatedColor: Colors.grey,
            selectedTextColor: Colors.white,
            daysCount: 50,
            locale: 'it',
            controller: _datePikerController,
            onDateChange: (date) {
              setSelectedDate(date, listCalendarConfiguration);
            },
          ),
          Text(_currentDateTime.toUtc().toString()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                child: Text(_isOpen ? 'Aperto' : 'Apri', style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'LoraFont')),
                color: _isOpen ? Colors.green : Colors.grey,
                elevation: 5.0,
                onPressed: (){
                  setState(() {
                    _isOpen = true;
                    _isClosed = false;
                  });
                },
              ),
              RaisedButton(
                child: Text(_isClosed ? 'Chiuso' : 'Chiudi' ,style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'LoraFont')),
                color: _isClosed ? Colors.red : Colors.grey,
                elevation: 5.0,
                onPressed: (){
                  if(_currentCalendarManagerClass != null){
                    crudModel.removeCalendar(_currentCalendarManagerClass.id);
                  }
                  setState(() {
                    _isClosed = true;
                    _isOpen = false;
                    _isLunchTime = false;
                    _isDinnerTime = false;
                  });
                },
              ),
            ],
          ),
          _isOpen ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                child: Text('Pranzo',style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'LoraFont')),
                color: _isLunchTime ? Colors.blue : Colors.grey,
                elevation: 5.0,
                onPressed: (){
                  setState(() {
                    if(_isLunchTime){
                      _isLunchTime = false;
                    }else{
                      _isLunchTime = true;
                    }
                  });
                },
              ),
              RaisedButton(
                child: Text('Cena',style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'LoraFont')),
                color: _isDinnerTime ? Colors.blue : Colors.grey,
                elevation: 5.0,
                onPressed: (){
                  setState(() {
                    if(_isDinnerTime){
                      _isDinnerTime = false;
                    }else{
                      _isDinnerTime = true;
                    }
                  });
                },
              ),
            ],
          ) : SizedBox(width: 0,),
          RaisedButton(
            child: Text('Salva configurazione',style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: 'LoraFont')),
            color: Colors.green ,
            elevation: 5.0,
            onPressed: (){
              if(_isOpen){
                if(!_isLunchTime && !_isDinnerTime){
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(backgroundColor: Colors.red.shade500 ,
                      content: Text('Per aprire il locale selezionare almeno una fascia oraria (Pranzo/Cena)')));
                }else{
                  if(retrieveCurrentCalendarConfigurationBySelectedDate(_currentDateTime, listCalendarConfiguration) == null){
                    crudModel.addCalendarConfiguration(CalendarManagerClass(
                        _currentDateTime.millisecondsSinceEpoch.toString(),
                        _currentDateTime.millisecondsSinceEpoch.toString(),
                        _isOpen,
                        _isClosed,
                        _isLunchTime,
                        _isDinnerTime
                    ));
                  }
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(backgroundColor: Colors.green.shade500 ,
                    content: Text('Configurazione salvata per il giorno ' + Utils.getWeekDay(_currentDateTime.weekday) +" ${_currentDateTime.day} " + Utils.getMonthDay(_currentDateTime.month)
                    ),
                  ),
                  );
                }
              }else{
                if(_currentCalendarManagerClass != null){
                  crudModel.removeCalendar(_currentCalendarManagerClass.id);
                }
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(backgroundColor: Colors.orangeAccent,
                  content: Text('Chiusura programmata per il giorno ' + Utils.getWeekDay(_currentDateTime.weekday) +" ${_currentDateTime.day} " + Utils.getMonthDay(_currentDateTime.month)
                  ),
                ),
                );
              }
            },
          ),
        ],
      ),
    ),
    );
    return futureList;
  }

  buildListDateActiveFromCalendarConfiguration(List<CalendarManagerClass> listCalendarConfiguration) {
    List<DateTime> dateTimeActiveList = <DateTime>[];
    listCalendarConfiguration.forEach((calendarItem) {
      if(calendarItem.isOpen){
        dateTimeActiveList.add(DateTime.fromMillisecondsSinceEpoch(int.parse(calendarItem.date)));
      }
    });
    return dateTimeActiveList;
  }

  void setSelectedDate(DateTime date, List<CalendarManagerClass> listCalendarConfiguration ) {

    setState(() {
      _currentDateTime = date;

      if(retrieveCurrentCalendarConfigurationBySelectedDate(_currentDateTime, listCalendarConfiguration) == null){
        _isClosed = true;
        _isOpen = false;
        _isLunchTime = false;
        _isDinnerTime = false;
      }
    });
  }

  CalendarManagerClass retrieveCurrentCalendarConfigurationBySelectedDate(
      DateTime currentDateTime,
      List<CalendarManagerClass> listCalendarConfiguration) {

    CalendarManagerClass calendarManagerClass;

    if(listCalendarConfiguration != null){
      if(listCalendarConfiguration.length != 0){
        listCalendarConfiguration.forEach((element) {
          if(DateTime.fromMillisecondsSinceEpoch(int.parse(element.date)).day == _currentDateTime.day &&
          DateTime.fromMillisecondsSinceEpoch(int.parse(element.date)).month == _currentDateTime.month &&
          DateTime.fromMillisecondsSinceEpoch(int.parse(element.date)).year == _currentDateTime.year){
            calendarManagerClass = element;
            return calendarManagerClass;
          }
        });
      }
    }
    return calendarManagerClass;
  }
}