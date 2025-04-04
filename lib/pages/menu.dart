import 'package:flutter/material.dart';
import 'package:moula_manager/widgets/BudgetInfo.dart';
import 'package:moula_manager/pages/ajouter_depense.dart';
import 'package:moula_manager/pages/listeDepenses.dart';
import 'package:moula_manager/pages/stats.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moula_manager/widgets/customAppBar.dart';

import '../database/depense_database.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool _switchValue = false;
  double _valeur_dollar = 1.11;
  double _valeur_euro = 1.00;
  double _valeur_en_cour = 1.00; // Par défaut en euros

  // Méthode pour recharger les données de BudgetInfo
  void _refreshBudgetInfo() {
    // Force la reconstruction de BudgetInfo en appelant setState
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: "moulaManager",
        parentContext: context,
        valeurUnite: _valeur_en_cour,
        boolSwitch: _switchValue
      ),
      body: Column(
        children: [
          Builder(
            builder: (BuildContext context) {
              return BudgetInfo(
                categories: ['food', 'car', 'housing', 'other'],
                database: DepenseDatabase.instance,
                valeurUnite: _valeur_en_cour,
                boolSwitch: _switchValue,
              );
            },
          ),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                // Modification ici : Utilisation de Row et Align
                Row(
                  mainAxisAlignment: MainAxisAlignment.start, // Aligner les éléments à gauche
                  children: [
                    Align(
                      alignment: Alignment.centerLeft, // Aligner le switch à gauche
                      child: Switch(
                        value: _switchValue,
                        onChanged: (newValue) {
                          setState(() {
                            _switchValue = newValue;
                            _valeur_en_cour = _switchValue ? _valeur_dollar : _valeur_euro;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 5), // Espacement entre le switch et le label
                    Text(
                      "\$",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Fin de la modification
                SizedBox(
                  width: double.infinity,
                  child: _buildCustomButton(
                    context,
                    AppLocalizations.of(context)!.buttonAddExpense,
                        () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AjouterDepense(
                          valeurUnite: _valeur_en_cour,
                          boolSwitch: _switchValue,
                        )),
                      );
                      _refreshBudgetInfo(); // Rafraîchir BudgetInfo après le retour
                    },
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: _buildCustomButton(
                    context,
                    AppLocalizations.of(context)!.buttonStats,
                        () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Statistiques(
                            database: DepenseDatabase.instance,
                            valeurUnite: _valeur_en_cour,
                            boolSwitch: _switchValue,)
                      ));
                      _refreshBudgetInfo(); // Rafraîchir BudgetInfo après le retour
                    },
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: _buildCustomButton(
                    context,
                    AppLocalizations.of(context)!.buttonShowExpenses,
                        () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ListeDepenses(
                          database: DepenseDatabase.instance,
                          valeurUnite: _valeur_en_cour,
                          boolSwitch: _switchValue,)),
                      );
                      _refreshBudgetInfo(); // Rafraîchir BudgetInfo après le retour
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomButton(BuildContext context, String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
        textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      child: Text(label),
    );
  }
}