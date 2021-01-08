import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:santanna_app/models/product.dart';
import 'package:santanna_app/utils/round_icon_botton.dart';

class ModalDialog extends StatefulWidget {

  @override
  _ModalDialogState createState() => _ModalDialogState();
}

class _ModalDialogState extends State<ModalDialog> {
  int itemCount = 0;
  Product product;

  @override
  Widget build(BuildContext context) {
    String ingredientString = "";
    List<dynamic> dataIngredients = product.listIngredients;
    dataIngredients.forEach((ingredient) {
      ingredientString = ingredientString + ingredient + " | ";
    });
    ingredientString = ingredientString.substring(0, ingredientString.length -2);

    String allergensString = "";
    List<dynamic> dataAllergens = product.listAllergens;
    dataAllergens.forEach((allergen) {
      allergensString = allergensString + allergen + " | ";
    });
    allergensString = allergensString.substring(0, allergensString.length -2);

    return AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height - 200,
        width: MediaQuery.of(context).size.width - 50,
        child: Scaffold(
          backgroundColor: Colors.white70,
          body: SafeArea(
            child: ListView(
              children: [
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(product.name, style: TextStyle(fontSize: 20.0, fontFamily: 'LoraFont'),),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(60.0)),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black]),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(60.0)),
                          child: Image.asset(product.image),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(ingredientString, overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 13.0, fontFamily: 'LoraFont'),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Allergeni: ' +  allergensString, overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 13.0, fontFamily: 'LoraFont'),),
                      ),
                      Text('€ ' + product.price.toString(), overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 16.0, fontFamily: 'LoraFont'),),

                      /*buildChoiceChipList(product.changes),*/

                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RoundIconButton(
                              icon: FontAwesomeIcons.minus,
                              function: () {
                                setState(() {
                                  itemCount = itemCount - 1;
                                });
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(itemCount.toString()),
                            ),
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              function: () {
                                setState(() {
                                  itemCount = itemCount + 1;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          print('asdasdasd');
                        },
                        child: Text(
                          "Aggiungi al Carrello", overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 16.0, fontFamily: 'LoraFont'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
