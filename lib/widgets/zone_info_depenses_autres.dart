import 'package:flutter/material.dart';

class ZoneInfoDepensesExceptionnelles extends StatelessWidget {
  const ZoneInfoDepensesExceptionnelles({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
          const Text(
            'Exceptionnel : 200€ (max : 250€)',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ]
    );
  }
}