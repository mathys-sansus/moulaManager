import 'package:flutter/material.dart';
import 'package:moula_manager/database/depense_database.dart';
import 'package:moula_manager/model/depense.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.titleListExpenses),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : Column(  // Utilisation d'une Column pour organiser le bouton et la liste
        children: [
          ElevatedButton.icon(
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
          ),
          Expanded(  // Utilisation de Expanded pour que la liste prenne l'espace restant
            child: _depenses.isEmpty
                ? Center(child: Text(AppLocalizations.of(context)!.noExpense))
                : ListView.builder(
              itemCount: _depenses.length,
              itemBuilder: (context, index) {
                final depense = _depenses[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('${depense.type} - ${depense.montant.toStringAsFixed(2)}€'),
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
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDepense(int id) async {
    try {
      await widget.database.deleteDepense(id);
      // Recharger les dépenses après la suppression
      await _loadDepenses();
    } catch (e) {
      // Gérer l'erreur de suppression (par exemple, afficher un SnackBar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${AppLocalizations.of(context)!.errorDeletingExpense}: $e")),
      );
    }
  }

  Future<void> _deleteAllDepenses() async {
    try {
      await widget.database.deleteAllDepenses();
      // Recharger les dépenses après la suppression
      await _loadDepenses();
    } catch (e) {
      // Gérer l'erreur de suppression (par exemple, afficher un SnackBar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${AppLocalizations.of(context)!.errorDeletingExpense}: $e")),
      );
    }
  }
}