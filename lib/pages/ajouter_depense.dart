import 'package:flutter/material.dart';
import 'package:moula_manager/widgets/zone_saisie_ajout.dart';
import 'package:moula_manager/widgets/zone_saisie_ajout_radio_button.dart';
import 'package:moula_manager/model/depense.dart';
import 'package:moula_manager/database/depense_database.dart';

class AjouterDepense extends StatefulWidget {
  const AjouterDepense({super.key});

  @override
  State<AjouterDepense> createState() => _AjouterDepenseState();
}

class _AjouterDepenseState extends State<AjouterDepense> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _montantController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _switchExceptionnelle = false;
  List<Depense> _depenses = [];

  @override
  void initState() {
    super.initState();
    _loadDepenses();
  }

  Future<void> _loadDepenses() async {
    final depenses = await DepenseDatabase.instance.getAllDepenses();
    setState(() {
      _depenses = depenses;
    });
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
      exceptionnel: _switchExceptionnelle ? 1 : 0,
    );

    await DepenseDatabase.instance.insertDepense(depense);
    _typeController.clear();
    _montantController.clear();
    _descriptionController.clear();
    _switchExceptionnelle = false;
    _loadDepenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter une dépense')),
      body: Column(
        children: [
          ZoneSaisieAjoutRadioButton(
            typeController: _typeController,
          ),
          ZoneSaisieAjout(
            montantController: _montantController,
            descriptionController: _descriptionController,
          ),
          Switch(
            value: _switchExceptionnelle,
            onChanged: (bool value) {
              setState(() {
                _switchExceptionnelle = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: _addDepense,
            child: Text('Valider', style: TextStyle(fontSize: 30.0)),
          ),
          ElevatedButton(
            onPressed: _supp,
            child: Text('Tous supprimer (1 à 100 en brute)', style: TextStyle(fontSize: 10.0)),
          ),
          Expanded(
            child: _depenses.isEmpty
                ? Center(child: Text("Aucune dépense enregistrée"))
                : ListView.builder(
              itemCount: _depenses.length,
              itemBuilder: (context, index) {
                final depense = _depenses[index];
                return ListTile(
                  title: Text(depense.id.toString()),
                  subtitle: Text("Montant: ${depense.montant}€"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}