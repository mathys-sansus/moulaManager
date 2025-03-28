import 'package:flutter/material.dart';

class ZoneInfoDepensesClassiques extends StatelessWidget {
  const ZoneInfoDepensesClassiques({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
          const Text(
            'Alimentation : 200€ (max : 250€)',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Automobile : 150€ (max : 180€)',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Logement : 40€ (max : 50€)',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          const SizedBox(height: 24),
        ]
    );
  }
}