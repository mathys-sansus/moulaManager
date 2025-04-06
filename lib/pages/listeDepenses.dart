import 'package:flutter/material.dart';
import 'package:moula_manager/database/depense_database.dart';
import 'package:moula_manager/model/depense.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moula_manager/widgets/customAppBar.dart';
import 'package:moula_manager/variables/globals.dart';

class ListeDepenses extends StatefulWidget {
  const ListeDepenses({Key? key, required this.database}) : super(key: key);
  final DepenseDatabase database;

  @override
  State<ListeDepenses> createState() => _ListeDepensesState();
}

class _ListeDepensesState extends State<ListeDepenses> {
  List<Depense> _depenses = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDepenses();
  }

  Future<void> _loadDepenses() async {
    try {
      final depenses = await widget.database.getAllDepenses();
      setState(() {
        _depenses = depenses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "${AppLocalizations.of(context)!.errorLoadingExpenses}: $e";
        _isLoading = false;
      });
    }
  }

  // Méthode pour créer le bouton "Remove All Expenses"
  Widget _buildRemoveAllButton() {
    return ElevatedButton.icon(
      onPressed: () {
        _deleteAllDepenses();
      },
      icon: const Icon(Icons.delete_forever, color: Colors.white),
      label: Text(AppLocalizations.of(context)!.buttonRemoveAllExpenses),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Méthode pour afficher les éléments en fonction de l'état (chargement, erreur ou liste)
  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }
    if (_depenses.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noExpense));
    }
    return _buildDepenseList();
  }

  // Méthode pour afficher la liste des dépenses
  Widget _buildDepenseList() {
    return ListView.builder(
      itemCount: _depenses.length,
      itemBuilder: (context, index) {
        final depense = _depenses[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(
              '${depense.type} - ${(depense.montant * valeur_en_cour).toStringAsFixed(2)} ${boolSwitch ? "\$" : "€"}',
              style: const TextStyle(fontSize: 16),
            ),
            subtitle: Text(depense.description ?? ''),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _deleteDepense(depense.id!);
              },
            ),
          ),
        );
      },
    );
  }

  // Layout pour le mode portrait
  Widget _buildPortraitLayout() {
    return Column(
      children: [
        _buildRemoveAllButton(),
        Expanded(child: _buildContent()),
      ],
    );
  }

  // Layout pour le mode paysage
  Widget _buildLandscapeLayout() {
    return Column(
      children: [
        _buildRemoveAllButton(),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _depenses.isEmpty
              ? Center(child: Text(AppLocalizations.of(context)!.noExpense))
              : GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,  // 2 colonnes en mode paysage
              childAspectRatio: 4.5,  // Ajuste le ratio pour avoir une bonne disposition
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _depenses.length,
            itemBuilder: (context, index) {
              final depense = _depenses[index];
              return Card(
                child: Row(  // Utilisation de Row pour aligner les éléments
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Icône de type, si nécessaire
                    const SizedBox(width: 8),  // Espacement entre l'icône et le texte
                    Expanded(  // Permet au texte de prendre l'espace restant
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,  // Alignement du texte à gauche
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${AppLocalizations.of(context)!.lookup(depense.type)} - ${(depense.montant * valeur_en_cour).toStringAsFixed(2)} ${boolSwitch ? "\$" : "€"}', style: const TextStyle(fontSize: 16)),
                          Text(depense.description ?? '', style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteDepense(depense.id!);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }


  // Méthode pour supprimer une dépense
  Future<void> _deleteDepense(int id) async {
    try {
      await widget.database.deleteDepense(id);
      await _loadDepenses();  // Recharger les dépenses après suppression
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${AppLocalizations.of(context)!.errorDeletingExpense}: $e")),
      );
    }
  }

  // Méthode pour supprimer toutes les dépenses
  Future<void> _deleteAllDepenses() async {
    try {
      await widget.database.deleteAllDepenses();
      await _loadDepenses();  // Recharger les dépenses après suppression
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${AppLocalizations.of(context)!.errorDeletingExpense}: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "titleListExpenses",
        parentContext: context),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildPortraitLayout()
              : _buildLandscapeLayout();
        },
      ),
    );
  }
}

extension on AppLocalizations {
  lookup(String category) {
    switch (category) {
      case 'food': return food;
      case 'car': return car;
      case 'housing': return housing;
      case 'other': return other;
      default: return '';
    }
  }
}