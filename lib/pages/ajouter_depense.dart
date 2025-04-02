import 'package:flutter/material.dart';
import 'package:moula_manager/widgets/zone_saisie_ajout.dart';
import 'package:moula_manager/widgets/zone_saisie_ajout_radio_button.dart';
import 'package:moula_manager/model/depense.dart';
import 'package:moula_manager/database/depense_database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AjouterDepense extends StatefulWidget {
  const AjouterDepense({super.key});

  @override
  State<AjouterDepense> createState() => _AjouterDepenseState();
}

class _AjouterDepenseState extends State<AjouterDepense> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _montantController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _supp() async {
    setState(() async {
      for (int i = 0; i < 100; i++) {
        await DepenseDatabase.instance.deleteDepense(i);
      }
    });
  }

  Future<void> _addDepense() async {
    if (_typeController.text.isEmpty || _montantController.text.isEmpty) {
      return;
    }

    double? montant = double.tryParse(_montantController.text);
    if (montant == null) {
      return;
    }

    final depense = Depense(
      type: _typeController.text,
      montant: montant,
      description: _descriptionController.text,
    );

    await DepenseDatabase.instance.insertDepense(depense);
    _typeController.clear();
    _montantController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.addExpense)),
      body: Column(
        children: [
          ZoneSaisieAjoutRadioButton(
            typeController: _typeController,
          ),
          ZoneSaisieAjout(
            montantController: _montantController,
            descriptionController: _descriptionController,
          ),
          ElevatedButton(
            onPressed: _addDepense,
            child: Text(AppLocalizations.of(context)!.confirm, style: TextStyle(fontSize: 30.0)),
          ),
        ],
      ),
    );
  }
}