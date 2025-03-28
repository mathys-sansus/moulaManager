import 'package:flutter/material.dart';

enum TypeDepense { Alimentation, Voiture, Restaurant, Autre}

class ZoneSaisieAjoutRadioButton extends StatefulWidget {
  final TextEditingController typeController;
  const ZoneSaisieAjoutRadioButton({super.key, required this.typeController,});

  @override
  State<ZoneSaisieAjoutRadioButton> createState() => _ZoneSaisieAjoutRadioButtonState();
}

class _ZoneSaisieAjoutRadioButtonState extends State<ZoneSaisieAjoutRadioButton> {
  TypeDepense? _type = TypeDepense.Alimentation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Alimentation'),
          leading: Radio<TypeDepense>(
            value: TypeDepense.Alimentation,
            groupValue: _type,
            onChanged: (TypeDepense? value) {
              setState(() {
                _type = value;
                if (_type != TypeDepense.Autre) {
                  widget.typeController.text = _type!.name;
                }
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Voiture'),
          leading: Radio<TypeDepense>(
            value: TypeDepense.Voiture,
            groupValue: _type,
            onChanged: (TypeDepense? value) {
              setState(() {
                _type = value;
                if (_type != TypeDepense.Autre) {
                  widget.typeController.text = _type!.name;
                }
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Restauration'),
          leading: Radio<TypeDepense>(
            value: TypeDepense.Restaurant,
            groupValue: _type,
            onChanged: (TypeDepense? value) {
              setState(() {
                _type = value;
                if (_type != TypeDepense.Autre) {
                  widget.typeController.text = _type!.name;
                }
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Autre'),
          leading: Radio<TypeDepense>(
            value: TypeDepense.Autre,
            groupValue: _type,
            onChanged: (TypeDepense? value) {
              setState(() {
                _type = value;
              });
            },
          ),
        ),
        if (_type == TypeDepense.Autre) TextField(
          controller: widget.typeController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            labelText: 'Type ...',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
