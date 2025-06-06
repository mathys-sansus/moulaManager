import 'package:flutter/material.dart';
import 'package:moula_manager/widgets/zone_saisie_ajout.dart';
import 'package:moula_manager/widgets/zone_saisie_ajout_radio_button.dart';
import 'package:moula_manager/model/depense.dart';
import 'package:moula_manager/database/depense_database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moula_manager/widgets/customAppBar.dart';
import 'package:moula_manager/widgets/custom_button.dart';
import 'package:moula_manager/variables/globals.dart';

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

  Future<void> _addDepense() async {
    if (_typeController.text.isEmpty || _montantController.text.isEmpty) {
      return;
    }

    double? montant = double.tryParse(_montantController.text);
    if (montant == null) {
      return;
    }
    montant = montant / (boolSwitch ? valeur_dollar : 1);

    final depense = Depense(
      type: _typeController.text,
      montant: montant,
      description: _descriptionController.text,
    );

    try {
      await DepenseDatabase.instance.insertDepense(depense);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.addExpenseSuccess)),
      );
    } catch (e) {
      //Gérer l'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${AppLocalizations.of(context)!.errorAddingExpense}: $e")),
      );
    }
    _typeController.clear();
    _montantController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
          title: "addExpense",
          parentContext: context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(
          children: [
            ZoneSaisieAjoutRadioButton(
              typeController: _typeController,
            ),
            ZoneSaisieAjout(
              montantController: _montantController,
              descriptionController: _descriptionController,
              switchValue: boolSwitch,
            ),
            CustomButton(
                label: AppLocalizations.of(context)!.confirm,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  _addDepense();
                }
            ),
          ],
        ),
      ),
    );
  }
}