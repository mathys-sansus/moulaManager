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
  final TextEditingController _exceptionnelController = TextEditingController();

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
              exceptionnelController: _exceptionnelController,
            )
          ],
        )
      ),
    );
  }
}