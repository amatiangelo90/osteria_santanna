import 'package:delivery_santanna/models/calendar_manager.dart';
import 'package:delivery_santanna/models/product.dart';
import 'package:flutter/material.dart';

class Utils{

  static getIngredientsFromProduct(Product product){
    String ingredientString = "";
    List<dynamic> dataIngredients = product.listIngredients;
    dataIngredients.forEach((ingredient) {
      ingredientString = ingredientString + ingredient + " | ";
    });
    return ingredientString.substring(0, ingredientString.length -2);


  }

  static getIngredientsFromProductALaCarte(Product product){
    String ingredientString = "";
    List<dynamic> dataIngredients = product.listIngredients;

    if(dataIngredients.length == 0){
      return ingredientString;
    }

    dataIngredients.forEach((ingredient) {
      if(ingredient != ''){
        ingredientString = ingredientString + ingredient + ",";
      }
    });
    if(ingredientString.length < 1){
      return ingredientString;
    }
    ingredientString = ingredientString.replaceAll(' , ', ',');
    ingredientString = ingredientString.replaceAll(' , ', ',');
    ingredientString = ingredientString.replaceAll(' ,', ',');
    ingredientString = ingredientString.replaceAll(' ,', ',');
    ingredientString = ingredientString.replaceAll(', ', ',');
    ingredientString = ingredientString.replaceAll(', ', ',');
    ingredientString = ingredientString.replaceAll(',', ', ');
    return ingredientString.substring(0, ingredientString.length -2);


  }

  static getAllergensFromProduct(Product product){
    String allergensString = "";
    List<dynamic> dataAllergens = product.listAllergens;
    dataAllergens.forEach((allergen) {
      allergensString = allergensString + allergen + " | ";
    });
    return allergensString.substring(0, allergensString.length -2);
  }

  static List<DateTime> getUnavailableData(){
    return [
    DateTime.utc(2021,5 ,3 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,5 ,10 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,5 ,17 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,5 ,24 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,5 ,31 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,6 ,7 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,6 ,14 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,6 ,21 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,6 ,28 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,7 ,5 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,7 ,12 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,7 ,19 ,0 ,0 ,0 ,0 ,0),
    DateTime.utc(2021,7 ,26 ,0 ,0 ,0 ,0 ,0),

    ];
  }

  static List<DateTime> buildListDateActiveFromCalendarConfiguration(List<CalendarManagerClass> listCalendarConfiguration) {
    List<DateTime> dateTimeActiveList = <DateTime>[];

    print(dateTimeActiveList.length);
    listCalendarConfiguration.forEach((calendarItem) {
      if(calendarItem.isOpen){
        dateTimeActiveList.add(DateTime.fromMicrosecondsSinceEpoch(int.parse(calendarItem.date)));
      }

    });
    dateTimeActiveList.add(DateTime.utc(2021,5 ,27 ,0 ,0 ,0 ,0 ,0),);
    return dateTimeActiveList;
  }

  static String getWeekDay(int weekday) {
    switch(weekday){
      case 1:
        return "Lunedi";
      case 2:
        return "Martedi";
      case 3:
        return "Mercoledi";
      case 4:
        return "Gioverdi";
      case 5:
        return "Venerdi";
      case 6:
        return "Sabato";
      case 7:
        return "Domenica";
    }
    return "";
  }

  static String getMonthDay(int month) {
    switch(month){
      case 1:
        return "Gennaio";
      case 2:
        return "Febbraio";
      case 3:
        return "Marzo";
      case 4:
        return "Aprile";
      case 5:
        return "Maggio";
      case 6:
        return "Giugno";
      case 7:
        return "Luglio";
      case 8:
        return "Agosto";
      case 9:
        return "Settembre";
      case 10:
        return "Ottobre";
      case 11:
        return "Novembre";
      case 12:
        return "Dicembre";
    }
    return "";
  }

  static bool twoListContainsSameElements(List<String> changes, List<String> changesFromModal) {
    bool output = true;
    if(changes.length != changesFromModal.length){
      return false;
    }
    changes.forEach((elementChanges) {
      if(!changesFromModal.contains(elementChanges)){
        output = false;
      }
    });

    if(output){
      return true;
    }else{
      return false;
    }
  }

  static Widget buildInfoAlertDialog(context) {
    return AlertDialog(
      elevation: 2.0,
      title: Center(child: const Text('Informazioni', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),)),
      content: Container(
        child: Column(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              child: Row(
                children: [
                  Text('Ordini per il Delivery fino alle ',
                    style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                  Text('18.00',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0, fontFamily: 'LoraFont'),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
              child: Row(
                children: [
                  Text('Ordini per l\'Asporto fino alle ',
                    style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                  Text('20.00',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0, fontFamily: 'LoraFont'),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
              child: Row(
                children: [
                  Text('Consegna dalle ',
                    overflow: TextOverflow.visible ,style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                  Text('19.30',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0, fontFamily: 'LoraFont'),),
                  Text(' alle ',
                    overflow: TextOverflow.visible ,style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                  Text('21.30',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0, fontFamily: 'LoraFont'),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
              child: Row(
                children: [
                  Text('Per delivery ordine minimo: ',
                    overflow: TextOverflow.visible, style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                  Text('30 €',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0, fontFamily: 'LoraFont'),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
              child: Row(
                children: [
                  Text('Costo delivery: ',
                    overflow: TextOverflow.visible, style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                  Text('3 €',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0, fontFamily: 'LoraFont'),),
                ],
              ),
            ),
            Row(
              children: [
                Text(' (Gratis per ordini superiori a 50 €)',
                  overflow: TextOverflow.visible, style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(''),
            ),
            const Text('Inviaci la richiesta d’ordine, ti risponderemo al più presto dopo aver verificato la disponibilità',
              overflow: TextOverflow.visible, style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  child: const Text('Grazie per averci scelto',
                    overflow: TextOverflow.visible, style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Indietro"),
        ),
      ],
    );
  }

  static Widget buildAlertDialog(BuildContext context) {
    return AlertDialog(
      elevation: 2.0,
      title: Center(child: const Text('Informazioni', style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),)),
      content: Container(
        child: Column(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /*Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              child: Row(
                children: [
                  Text('Ordini per il Delivery fino alle ',
                    style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                  Text('18.00',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0, fontFamily: 'LoraFont'),),
                ],
              ),
            ),*/
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
              child: Row(
                children: [
                  Text('Ordini per l\'Asporto fino alle ',
                    style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                  Text('20.00',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0, fontFamily: 'LoraFont'),),
                ],
              ),
            ),
            /*Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
              child: Row(
                children: [
                  Text('Consegna dalle ',
                    overflow: TextOverflow.visible ,style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                  Text('19.30',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0, fontFamily: 'LoraFont'),),
                  Text(' alle ',
                    overflow: TextOverflow.visible ,style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                  Text('21.30',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0, fontFamily: 'LoraFont'),),
                ],
              ),
            ),*/
            /*Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
              child: Row(
                children: [
                  Text('Costo delivery: ',
                    overflow: TextOverflow.visible, style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
                  Text('3 €',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.0, fontFamily: 'LoraFont'),),
                ],
              ),
            ),*/
            /*Row(
              children: [
                Text(' (Gratis per ordini superiori a 50 €)',
                  overflow: TextOverflow.visible, style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
              ],
            ),*/
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(''),
            ),
            const Text('Inviaci la richiesta d’ordine, ti risponderemo al più presto dopo aver verificato la disponibilità',
              overflow: TextOverflow.visible, style: TextStyle(color: Colors.black, fontSize: 14.0, fontFamily: 'LoraFont'),),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  child: const Text('Grazie per averci scelto',
                    overflow: TextOverflow.visible, style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'LoraFont'),),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Indietro"),
        ),
      ],
    );
  }
}