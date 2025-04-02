import 'package:flutter/material.dart';
import '../database/depense_database.dart';
import '../model/depense.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ZoneInfoDepensesClassiques extends StatefulWidget {
  const ZoneInfoDepensesClassiques({super.key, required this.database});
  final DepenseDatabase database;

  @override
  State<ZoneInfoDepensesClassiques> createState() => _ZoneInfoDepensesClassiquesState();
}

class _ZoneInfoDepensesClassiquesState extends State<ZoneInfoDepensesClassiques> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Depense>>(
      stream: widget.database.depensesStream, // Écoute le Stream
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Affiche un indicateur de chargement initial
        } else if (snapshot.hasError) {
          return Text("Erreur: ${snapshot.error}");
        } else if (snapshot.hasData) {
          final depenses = snapshot.data!;
          double alimentation = 0;
          double automobile = 0;
          double logement = 0;

          for (var depense in depenses) {
            switch (depense.type) {
              case 'Alimentation':
                alimentation += depense.montant;
                break;
              case 'Automobile':
                automobile += depense.montant;
                break;
              case 'Logement':
                logement += depense.montant;
                break;
            }
          }

          return Column(
            children: [
              Text(
                '${AppLocalizations.of(context)!.food} : ${alimentation.toStringAsFixed(2)}€ (max : 250€)',
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '${AppLocalizations.of(context)!.car} : ${automobile.toStringAsFixed(2)}€ (max : 180€)',
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '${AppLocalizations.of(context)!.housing} : ${logement.toStringAsFixed(2)}€ (max : 50€)',
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        } else {
          return Text(AppLocalizations.of(context)!.noExpense); // Gère le cas où il n'y a pas de données initiales
        }
      },
    );
  }
}