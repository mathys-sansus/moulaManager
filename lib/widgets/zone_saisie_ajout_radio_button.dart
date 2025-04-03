import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum TypeDepense { Car, Food, Housing, Other}

class ZoneSaisieAjoutRadioButton extends StatefulWidget {
  final TextEditingController typeController;
  const ZoneSaisieAjoutRadioButton({super.key, required this.typeController,});

  @override
  State<ZoneSaisieAjoutRadioButton> createState() => _ZoneSaisieAjoutRadioButtonState();
}

class _ZoneSaisieAjoutRadioButtonState extends State<ZoneSaisieAjoutRadioButton> {
  TypeDepense? _type = TypeDepense.Food;

  @override
  void initState() {
    super.initState();
    widget.typeController.text = TypeDepense.Food.name;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(AppLocalizations.of(context)!.food),
          leading: Radio<TypeDepense>(
            value: TypeDepense.Food,
            groupValue: _type,
            onChanged: (TypeDepense? value) {
              setState(() {
                _type = value;
                widget.typeController.text = _type!.name;
              });
            },
          ),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.car),
          leading: Radio<TypeDepense>(
            value: TypeDepense.Car,
            groupValue: _type,
            onChanged: (TypeDepense? value) {
              setState(() {
                _type = value;
                widget.typeController.text = _type!.name;
              });
            },
          ),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.housing),
          leading: Radio<TypeDepense>(
            value: TypeDepense.Housing,
            groupValue: _type,
            onChanged: (TypeDepense? value) {
              setState(() {
                _type = value;
                widget.typeController.text = _type!.name;
              });
            },
          ),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.other),
          leading: Radio<TypeDepense>(
            value: TypeDepense.Other,
            groupValue: _type,
            onChanged: (TypeDepense? value) {
              setState(() {
                _type = value;
                widget.typeController.text = _type!.name;
              });
            },
          ),
        ),
      ],
    );
  }
}