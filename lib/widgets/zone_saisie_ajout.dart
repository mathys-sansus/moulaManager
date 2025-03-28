import 'package:flutter/material.dart';

class ZoneSaisieAjout extends StatelessWidget {
  final TextEditingController montantController;
  final TextEditingController descriptionController;

  const ZoneSaisieAjout({
    super.key,
    required this.montantController,
    required this.descriptionController,
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
              decoration: const InputDecoration(
                labelText: 'montant (en €)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Description (facultatif)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      );
  }
}