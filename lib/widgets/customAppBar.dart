import 'package:flutter/material.dart';
import 'package:moula_manager/pages/ajouter_depense.dart';
import 'package:moula_manager/pages/listeDepenses.dart';
import 'package:moula_manager/pages/menu.dart';
import 'package:moula_manager/pages/stats.dart';
import '../database/depense_database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final BuildContext parentContext;
  final String title;// Ajout du contexte parent
  final double valeurUnite;
  final bool boolSwitch;

  const CustomAppBar({super.key, required this.parentContext, required this.title, required this.valeurUnite, required this.boolSwitch});

  String _getTranslatedTitle(BuildContext context) {
    switch (title) {
      case "addExpense":
        return AppLocalizations.of(context)!.addExpense;
      case "titleStats":
        return AppLocalizations.of(context)!.titleStats;
      case "titleListExpenses":
        return AppLocalizations.of(context)!.titleListExpenses;
      default:
        return title; // Fallback si la clé n'existe pas
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(_getTranslatedTitle(context), style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.deepPurple,

      // 🔙 Bouton retour à gauche
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white,),
        onPressed: () {
          if (Navigator.canPop(parentContext)) {
            Navigator.pop(parentContext); // 🔙 Retour à la page précédente
          }
        },
      ),

      // 📌 Actions à droite
      actions: [
        // 🏠 Bouton Accueil
        IconButton(
          icon: Icon(Icons.home, color: Colors.white),
          onPressed: () {
            // Rediriger vers la page d'accueil
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Menu())
            );
          },
        ),

        // 🍔 Menu Hamburger sous forme de PopupMenuButton
        PopupMenuButton<String>(
          icon: Icon(Icons.menu, color: Colors.white), // Icône hamburger
          onSelected: (value) {
            if (value == "addExpense") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AjouterDepense(
                    valeurUnite: valeurUnite,
                    boolSwitch: boolSwitch
                )),
              );
            } else if (value == "titleStats") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Statistiques(
                    database: DepenseDatabase.instance,
                    valeurUnite: valeurUnite,
                    boolSwitch: boolSwitch)),
              );
            } else if (value == "titleListExpenses") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListeDepenses(
                  database: DepenseDatabase.instance,
                  valeurUnite: valeurUnite,
                  boolSwitch: boolSwitch)),
              );
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: "addExpense",
              child: Text(AppLocalizations.of(context)!.addExpense),
            ),
            PopupMenuItem(
              value: "titleStats",
              child: Text(AppLocalizations.of(context)!.titleStats),
            ),
            PopupMenuItem(
              value: "titleListExpenses",
              child: Text(AppLocalizations.of(context)!.titleListExpenses),
            ),
          ],
        ),
      ],
    );

  }
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}