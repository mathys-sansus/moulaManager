import 'package:flutter/material.dart';
import 'package:moula_manager/pages/ajouter_depense.dart';
import 'package:moula_manager/pages/listeDepenses.dart';
import 'package:moula_manager/pages/menu.dart';
import 'package:moula_manager/pages/stats.dart';
import '../database/depense_database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moula_manager/pages/modifier_max.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final BuildContext parentContext;
  final String title;// Ajout du contexte parent

  const CustomAppBar({super.key, required this.parentContext, required this.title});

  String _getTranslatedTitle(BuildContext context) {
    switch (title) {
      case "addExpense":
        return AppLocalizations.of(context)!.addExpense;
      case "titleStats":
        return AppLocalizations.of(context)!.titleStats;
      case "titleListExpenses":
        return AppLocalizations.of(context)!.titleListExpenses;
      case "setLimits":
        return AppLocalizations.of(context)!.setLimits;
      default:
        return title; // Fallback si la clé n'existe pas
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // empêche Flutter de mettre une flèche par défaut
      title: Text(_getTranslatedTitle(context), style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.deepPurple,
      leading: title == "moulaManager"
          ? null
          : IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          if (Navigator.canPop(parentContext)) {
            Navigator.pop(parentContext);
          }
        },
      ),


    //Actions à droite
      actions: [
        // Bouton Accueil
        IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {
            // Rediriger vers la page d'accueil
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Menu())
            );
          },
        ),

        //Menu Hamburgeur
        PopupMenuButton<String>(
          icon: const Icon(Icons.menu, color: Colors.white), // Icône hamburger
          onSelected: (value) {
            if (value == "addExpense") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AjouterDepense()),
              );
            } else if (value == "titleStats") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Statistiques(
                    database: DepenseDatabase.instance,
                )),
              );
            } else if (value == "titleListExpenses") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListeDepenses(
                    database: DepenseDatabase.instance
              )));
            } else if (value == "setLimits") {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ModifierMax(
                      database: DepenseDatabase.instance
                  )));
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
            PopupMenuItem(
              value: "setLimits",
              child: Text(AppLocalizations.of(context)!.setLimits),
            ),
          ],
        ),
      ],
    );

  }
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}