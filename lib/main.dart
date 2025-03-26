import 'package:flutter/material.dart';
import 'pages/menu.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Imc Calculator',
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent, //Permet de fixer la couleur de la barre d'application directement depuis le thème
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const Menu(), //Définit la page d'accueil de l'application
    );
  }
}