import 'package:flutter/material.dart';

class ZoneSaisieAjout extends StatelessWidget {
  final TextEditingController montantController;
  final TextEditingController descriptionController;
  final TextEditingController exceptionnelController;

  const ZoneSaisieAjout({
    super.key,
    required this.montantController,
    required this.descriptionController,
    required this.exceptionnelController
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: montantController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Size (cm)',
                hintText: 'Entre 50 et re cm',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}