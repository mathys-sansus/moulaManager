import 'package:flutter/material.dart';
import 'package:moula_manager/database/depense_database.dart';
import 'package:moula_manager/widgets/customAppBar.dart';
import 'package:moula_manager/widgets/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moula_manager/variables/globals.dart';

class ModifierMax extends StatefulWidget {
  final DepenseDatabase database;

  const ModifierMax({Key? key, required this.database}) : super(key: key);

  @override
  State<ModifierMax> createState() => _ModifierMaxState();
}

class _ModifierMaxState extends State<ModifierMax> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _alimController = TextEditingController();
  final TextEditingController _autoController = TextEditingController();
  final TextEditingController _logementController = TextEditingController();
  final TextEditingController _autreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMaxValues(); // Charger les valeurs depuis la BDD
  }

  // Charger les valeurs max depuis la base de données
  Future<void> _loadMaxValues() async {
    final maxValues = await widget.database.getMax();
    final multiplicateur = boolSwitch ? valeur_dollar : 1;

    setState(() {
      _alimController.text = (maxValues[0] * multiplicateur).toStringAsFixed(2);   // food
      _autoController.text = (maxValues[1] * multiplicateur).toStringAsFixed(2);   // car
      _logementController.text = (maxValues[2] * multiplicateur).toStringAsFixed(2); // housing
      _autreController.text = (maxValues[3] * multiplicateur).toStringAsFixed(2);  // other
    });
  }

  // Fonction pour modifier les valeurs max dans la base de données
  void _modifierMax() {
    if (_formKey.currentState!.validate()) {
      // Vérifier si boolSwitch est true et définir le diviseur en conséquence
      final diviseur = boolSwitch ? 1.11 : 1.0;

      // Diviser les valeurs et arrondir à deux décimales
      final food = (double.parse(_alimController.text) / diviseur).toStringAsFixed(2);
      final car = (double.parse(_autoController.text) / diviseur).toStringAsFixed(2);
      final housing = (double.parse(_logementController.text) / diviseur).toStringAsFixed(2);
      final other = (double.parse(_autreController.text) / diviseur).toStringAsFixed(2);

      // Convertir les chaînes arrondies en double pour les insérer dans la base de données
      widget.database.modifMax(
        double.parse(food),
        double.parse(car),
        double.parse(housing),
        double.parse(other),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.valuesUpdated)),
      );
    }
  }

  // Widget pour créer chaque champ de saisie
  Widget _buildBloc(String label, TextEditingController controller) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return AppLocalizations.of(context)!.requiredField;
                final numValue = double.tryParse(value);
                if (numValue == null || numValue < 0) return AppLocalizations.of(context)!.messageEnterValidValue;
                return null;
              },
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.messageEnterValue,
                suffixText: boolSwitch ? '\$' : '€',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "setLimits",
        parentContext: context,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildBloc(AppLocalizations.of(context)!.food, _alimController),
              _buildBloc(AppLocalizations.of(context)!.car, _autoController),
              _buildBloc(AppLocalizations.of(context)!.housing, _logementController),
              _buildBloc(AppLocalizations.of(context)!.other, _autreController),
              const SizedBox(height: 20),
              CustomButton(
                label: AppLocalizations.of(context)!.confirm,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  _modifierMax();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}