import 'package:flutter/material.dart';
import '../database/depense_database.dart';
import '../model/depense.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BudgetInfo extends StatelessWidget {
  final DepenseDatabase database;
  final List<String> categories; // Ajout du paramètre pour les catégories

  const BudgetInfo({super.key, required this.database, required this.categories});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Depense>>(
      stream: database.depensesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Erreur: ${snapshot.error}");
        } else if (snapshot.hasData) {
          final depenses = snapshot.data!;
          Map<String, double> totals = {for (var cat in categories) cat: 0};

          for (var depense in depenses) {
            if (totals.containsKey(depense.type.toLowerCase())) {
              totals[depense.type.toLowerCase()] = (totals[depense.type.toLowerCase()] ?? 0) + depense.montant;
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categories.map((category) {
              return _buildBudgetCard(
                context,
                category,
                totals[category] ?? 0,
                _getMaxBudget(category),
                _getColor(category),
              );
            }).toList(),
          );
        } else {
          return Text(AppLocalizations.of(context)!.noExpense);
        }
      },
    );
  }

  Widget _buildBudgetCard(
      BuildContext context, String category, double value, double max, Color color) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Image.asset(
          'lib/images/$category.png',
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
        title: Text(
          '${AppLocalizations.of(context)!.lookup(category)} : ${value.toStringAsFixed(2)}€',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Max : ${max.toStringAsFixed(2)}€',
            style: TextStyle(fontSize: 16, color: Colors.grey[700])),
        trailing: _buildProgressIndicator(value, max, color),
      ),
    );
  }

  Widget _buildProgressIndicator(double value, double max, Color color) {
    double progress = (value / max).clamp(0.0, 1.0);
    return SizedBox(
      width: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          Text('${(progress * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  double _getMaxBudget(String category) {
    switch (category) {
      case 'food': return 250;
      case 'car': return 180;
      case 'housing': return 50;
      case 'other': return 300; // Valeur max pour 'other'
      default: return 0;
    }
  }

  Color _getColor(String category) {
    switch (category) {
      case 'food': return Colors.orange;
      case 'car': return Colors.blue;
      case 'housing': return Colors.green;
      case 'other': return Colors.red; // Couleur pour 'other'
      default: return Colors.grey;
    }
  }
}

extension on AppLocalizations {
  lookup(String category) {
    switch (category) {
      case 'food': return 'Alimentation';
      case 'car': return 'Automobile';
      case 'housing': return 'Logement';
      case 'other': return 'Autre';
      default: return '';
    }
  }
}