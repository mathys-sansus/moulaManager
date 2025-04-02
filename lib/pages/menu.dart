import 'package:flutter/material.dart';
import 'package:moula_manager/widgets/BudgetInfo.dart';
import 'package:moula_manager/pages/ajouter_depense.dart';
import 'package:moula_manager/pages/listeDepenses.dart';
import 'package:moula_manager/pages/stats.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../database/depense_database.dart';

//Classe d'état pour le calculateur d'IMC. Elle contient les champs de saisie pour le poids et la taille, le résultat de l'IMC et son interprétation
class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool _switchInfo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //Empêche le clavier de pousser les widgets vers le haut. Le clavier passera par-dessus les widgets
      appBar: AppBar(
        title: const Text('moulaManager'),
        centerTitle: true,
      ),
      body: Column(
        children: [BudgetInfo(categories: ['food', 'car', 'housing'], database: DepenseDatabase.instance),
          Switch(value: _switchInfo, onChanged: (bool value){
            setState(() {
              _switchInfo=value;
            });
          }),
          if (_switchInfo) BudgetInfo(database: DepenseDatabase.instance, categories: ['other']),
          ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AjouterDepense()),
                );
              },
              child: Text(AppLocalizations.of(context)!.buttonAddExpense,style: TextStyle(fontSize: 30.0),)),
          ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Statistiques(database: DepenseDatabase.instance)),
                );
              },
              child: Text(AppLocalizations.of(context)!.buttonStats,style: TextStyle(fontSize: 30.0),)),
          ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListeDepenses(database: DepenseDatabase.instance)),
                );
              },
              child: Text(AppLocalizations.of(context)!.buttonShowExpenses,style: TextStyle(fontSize: 30.0),)),
        ]
      )
    );
  }
}