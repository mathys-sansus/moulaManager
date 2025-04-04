import 'package:flutter/material.dart';
import '../database/depense_database.dart';
import '../model/depense.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moula_manager/variables/globals.dart';

class BudgetInfo extends StatefulWidget {
  final DepenseDatabase database;
  final List<String> categories;

  const BudgetInfo({super.key, required this.database, required this.categories});

  @override
  State<BudgetInfo> createState() => _BudgetInfoState();
}

class _BudgetInfoState extends State<BudgetInfo> {
  List<Depense> _depenses = [];
  bool _isLoading = true;
  String _errorMessage = "";

  double _foodMax = 0;
  double _carMax = 0;
  double _housingMax = 0;
  double _otherMax = 0;

  @override
  void initState() {
    super.initState();
    _loadDepenses();
    _loadMaxValues();
  }

  // Charger les valeurs max depuis la base de données
  Future<void> _loadMaxValues() async {
    final maxValues = await widget.database.getMax();
    final multiplicateur = boolSwitch ? valeur_dollar : 1;

    setState(() {
      _foodMax = (maxValues[0] * multiplicateur);   // food
      _carMax = (maxValues[1] * multiplicateur);   // car
      _housingMax = (maxValues[2] * multiplicateur); // housing
      _otherMax = (maxValues[3] * multiplicateur);  // other
    });
  }

  @override
  void didUpdateWidget(covariant BudgetInfo oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Vérifie si les catégories ont changé
    if (oldWidget.categories != widget.categories) {
      _loadDepenses();
      _loadMaxValues();
    }
  }

  Future<void> _loadDepenses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });
    try {
      final depenses = await widget.database.getAllDepenses();
      setState(() {
        _depenses = depenses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    } else {
      Map<String, double> totals = {for (var cat in widget.categories) cat: 0};

      for (var depense in _depenses) {
        if (totals.containsKey(depense.type.toLowerCase())) {
          totals[depense.type.toLowerCase()] = (totals[depense.type.toLowerCase()] ?? 0) + depense.montant;
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.categories.map((category) {
          return _buildBudgetCard(
            context,
            category,
            totals[category] ?? 0,
            _getMaxBudget(category),
            _getColor(category),
          );
        }).toList(),
      );
    }
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
          '${AppLocalizations.of(context)!.lookup(category)} : ${(value * valeur_en_cour).toStringAsFixed(2)} ${boolSwitch ? "\$" : "€"}',
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${AppLocalizations.of(context)!.lookup(category)} : ${(max).toStringAsFixed(2)} ${boolSwitch ? "\$" : "€"}',
            style: TextStyle(fontSize: 14, color: Colors.grey[700])),
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
      case 'food': return _foodMax;
      case 'car': return _carMax;
      case 'housing': return _housingMax;
      case 'other': return _otherMax;
      default: return 0;
    }
  }

  Color _getColor(String category) {
    switch (category) {
      case 'food': return Colors.orange;
      case 'car': return Colors.blue;
      case 'housing': return Colors.green;
      case 'other': return Colors.red;
      default: return Colors.grey;
    }
  }
}

extension on AppLocalizations {
  lookup(String category) {
    switch (category) {
      case 'food': return food;
      case 'car': return car;
      case 'housing': return housing;
      case 'other': return other;
      default: return '';
    }
  }
}