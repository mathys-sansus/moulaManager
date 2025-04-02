import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum TypeDepense { Automobile, Alimentation, Logement, Autre}

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
          title: Text(AppLocalizations.of(context)!.food),
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
          title: Text(AppLocalizations.of(context)!.car),
          leading: Radio<TypeDepense>(
            value: TypeDepense.Automobile,
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
          title: Text(AppLocalizations.of(context)!.housing),
          leading: Radio<TypeDepense>(
            value: TypeDepense.Logement,
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
          title: Text(AppLocalizations.of(context)!.other),
          leading: Radio<TypeDepense>(
            value: TypeDepense.Autre,
            groupValue: _type,
            onChanged: (TypeDepense? value) {
              setState(() {
                widget.typeController.text = "";
                _type = value;
              });
            },
          ),
        ),
        if (_type == TypeDepense.Autre) Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 16),
              TextField(
                controller: widget.typeController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}