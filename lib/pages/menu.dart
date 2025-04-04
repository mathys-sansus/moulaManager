import 'package:flutter/material.dart';
import 'package:moula_manager/widgets/BudgetInfo.dart';
import 'package:moula_manager/pages/ajouter_depense.dart';
import 'package:moula_manager/pages/listeDepenses.dart';
import 'package:moula_manager/pages/stats.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moula_manager/widgets/customAppBar.dart';
import 'package:moula_manager/widgets/custom_button.dart';
import 'package:moula_manager/variables/globals.dart';
import '../database/depense_database.dart';
import 'package:moula_manager/pages/modifier_max.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  void _refreshBudgetInfo() {
    setState(() {});
  }

  void _toggleCurrency(bool newValue) {
    setState(() {
      boolSwitch = newValue;
      valeur_en_cour = boolSwitch ? valeur_dollar : valeur_euro;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: "moulaManager",
        parentContext: context,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Partie haute scrollable si besoin
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    BudgetInfo(
                        categories: ['food', 'car', 'housing', 'other'],
                        database: DepenseDatabase.instance
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            // Partie basse (fixe en bas)
            Column(
              children: [
                // Le Switch fixé en bas
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Switch(
                        value: boolSwitch,
                        onChanged: _toggleCurrency,
                      ),
                      SizedBox(width: 5),
                      Text(
                        boolSwitch ? "\$" : "€",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                // Les boutons sous le Switch
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      CustomButton(
                        label: AppLocalizations.of(context)!.buttonAddExpense,
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AjouterDepense()),
                          );
                          _refreshBudgetInfo();
                        },
                      ),
                      SizedBox(height: 10),
                      CustomButton(
                        label: AppLocalizations.of(context)!.buttonStats,
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Statistiques(
                                database: DepenseDatabase.instance,
                              ),
                            ),
                          );
                          _refreshBudgetInfo();
                        },
                      ),
                      SizedBox(height: 10),
                      CustomButton(
                        label: AppLocalizations.of(context)!.buttonShowExpenses,
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListeDepenses(
                                database: DepenseDatabase.instance,
                              ),
                            ),
                          );
                          _refreshBudgetInfo();
                        },
                      ),
                      SizedBox(height: 10),
                      CustomButton(
                        label: AppLocalizations.of(context)!.setLimits,
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ModifierMax(
                                database: DepenseDatabase.instance,
                              ),
                            ),
                          );
                          _refreshBudgetInfo();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}