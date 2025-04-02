import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages/menu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moula Manager',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate, // Pour traduire les widgets Material
        GlobalWidgetsLocalizations.delegate, // Pour traduire les widgets génériques
        GlobalCupertinoLocalizations.delegate, // Pour traduire les widgets iOS (Cupertino)
      ],
      //AppLocalizations.localizationsDelegates,
      supportedLocales: [
      Locale('en'), // Anglais (par défaut)
      Locale('fr'), // Français
      ],
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