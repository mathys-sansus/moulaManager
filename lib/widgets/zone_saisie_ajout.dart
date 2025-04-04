import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ZoneSaisieAjout extends StatelessWidget {
  final TextEditingController montantController;
  final TextEditingController descriptionController;
  final bool switchValue;

  const ZoneSaisieAjout({
    super.key,
    required this.montantController,
    required this.descriptionController,
    required this.switchValue
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: montantController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: switchValue
                    ? AppLocalizations.of(context)!.amountFieldDollar
                    : AppLocalizations.of(context)!.amountFieldEuro,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.descriptionField,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      );
  }
}