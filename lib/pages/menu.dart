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

  // Méthode pour recharger les données de BudgetInfo
  void _refreshBudgetInfo() {
    // Force la reconstruction de BudgetInfo en appelant setState
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: "moulaManager", parentContext: context),
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(child: Text('Menu')),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Action pour Item 1
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Utilisation de Builder pour forcer la reconstruction de BudgetInfo
          Builder(
            builder: (BuildContext context) {
              return BudgetInfo(
                categories: ['food', 'car', 'housing', 'other'],
                database: DepenseDatabase.instance,
              );
            },
          ),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Switch(
                      value: _switchValue,
                      onChanged: (newValue) {
                        setState(() {
                          _switchValue = newValue;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: _buildCustomButton(
                    context,
                    AppLocalizations.of(context)!.buttonAddExpense,
                        () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AjouterDepense()),
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
                        MaterialPageRoute(builder: (context) => Statistiques(database: DepenseDatabase.instance)),
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
                    AppLocalizations.of(context)!.buttonShowExpenses,
                        () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ListeDepenses(database: DepenseDatabase.instance)),
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