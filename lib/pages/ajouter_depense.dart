import 'package:flutter/material.dart';
import 'package:moula_manager/widgets/zone_saisie_ajout.dart';
import 'package:moula_manager/widgets/zone_saisie_ajout_radio_button.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter une dépense')),
      body: Center(
          child: Column(
            children: [
              ZoneSaisieAjoutRadioButton(
                typeController: _typeController,
              ),
              ZoneSaisieAjout(
                montantController: _montantController,
                descriptionController: _descriptionController,
              ),
              Switch(value: _switchExceptionnelle, onChanged: (bool value){
                setState(() {
                  _switchExceptionnelle=value;
                });
              }),
              ElevatedButton(
                  onPressed: (){

                  },
                  child: Text('Valider',style: TextStyle(fontSize: 30.0),)
              )
            ],
          )
      ),
    );
  }
}