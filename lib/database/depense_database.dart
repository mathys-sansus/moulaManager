import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/depense.dart';
import 'dart:async'; // Importez dart:async pour StreamController

/// Implémentation du pattern Singleton pour la gestion de la base de données des notes.
/// Cette classe assure qu'une seule instance de NotesDatabase existe dans l'application.
/// Elle peut être considérée comme un contrôleur de la base de données.(Voir MVC)
class DepenseDatabase {
  /// Instance unique de NotesDatabase (partie du pattern Singleton)
  static final DepenseDatabase instance = DepenseDatabase._init();

  /// Instance unique de la base de données
  static Database? _dbInstance;

  /// Nom du fichier de la base de données
  static const String _dbFileName = 'depense.db';

  /// Nom de la table des notes
  static const String _tableDepenses = 'depenses';

  /// Contrôleur de flux pour les dépenses
  final _depensesStreamController = StreamController<List<Depense>>.broadcast();

  /// Flux de dépenses
  Stream<List<Depense>> get depensesStream => _depensesStreamController.stream;

  /// Constructeur privé pour empêcher l'instanciation directe (pattern Singleton)
  DepenseDatabase._init() {
    // Initialise le flux avec les données existantes
    _initStream();
  }

  Future<void> _initStream() async {
    _depensesStreamController.addStream(
      Stream.fromFuture(_getDepenses()),
    );
  }

  /// Getter privé pour accéder à l'instance unique de la base de données
  /// Crée la base de données si elle n'existe pas encore
  Future<Database> get database async {
    if (_dbInstance != null) return _dbInstance!;
    _dbInstance = await _initDB(_dbFileName);
    return _dbInstance!;
  }

  /// Initialise la base de données SQLite
  ///
  /// Cette méthode :
  /// 1. Récupère le chemin du répertoire de stockage de la base de données
  /// 2. Combine ce chemin avec le nom de notre fichier de base de données
  /// 3. Ouvre ou crée la base de données avec la version 1
  ///
  /// Le paramètre [filePath] correspond au nom du fichier de la base de données
  /// (défini par [_dbFileName])
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// Crée la structure initiale de la base de données
  ///
  /// Cette méthode est appelée automatiquement lors de la première création
  /// de la base de données. Elle définit la structure de notre table 'depenses'
  /// avec 5 colonnes :
  /// - id : Identifiant unique auto-incrémenté
  /// - type : Type de la depense (obligatoire)
  /// - montant : Montant de la depense (obligatoire)
  /// - description: Description de la dépenses (facultatif)
  /// - exceptionnelle : Bool qui permet de savoir si la dépense est exceptionnelle ou non
  ///
  /// Les paramètres [db] et [version] sont fournis par le package sqflite
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE depenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        montant REAL NOT NULL,
        description TEXT NOT NULL,
        exceptionnelle INTEGER NOT NULL DEFAULT 0
      );
    ''');
  }

  Future<List<Depense>> _getDepenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableDepenses);
    return List.generate(maps.length, (i) => Depense.fromMap(maps[i]));
  }

  /// Insère une nouvelle note dans la base de données
  ///
  /// Cette méthode ajoute une nouvelle note avec un titre et un contenu.
  /// Elle retourne l'ID de la note créée qui peut être utilisé pour
  /// la modifier ou la supprimer ultérieurement.
  ///
  /// Le paramètre [note] est l'objet Note à insérer dans la base de données
  Future<int> insertDepense(Depense depense) async {
    final db = await database;
    final id = await db.insert(_tableDepenses, depense.toMap());
    print("Dépense insérée, notification du Stream...");
    _depensesStreamController.add(await _getDepenses()); // Notifie le Stream
    return id;
  }

  /// Récupère toutes les notes de la base de données
  ///
  /// Cette méthode retourne une liste d'objets Note, ce qui rend le code
  /// plus type-safe et plus facile à utiliser dans l'interface utilisateur.
  /// Chaque note contient son ID, son titre et son contenu.
  Future<List<Depense>> getAllDepenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableDepenses);
    return List.generate(maps.length, (i) => Depense.fromMap(maps[i]));
  }

  /// Supprime une note de la base de données
  ///
  /// Cette méthode permet de supprimer une note en utilisant son ID.
  /// Elle est utilisée lorsque l'utilisateur clique sur le bouton de suppression
  /// dans l'interface utilisateur.
  ///
  /// Le paramètre [id] correspond à l'identifiant unique de la note à supprimer
  Future<void> deleteDepense(int id) async {
    final db = await database;
    await db.delete(_tableDepenses, where: 'id = ?', whereArgs: [id]);
    print("Dépense supprimée, notification du Stream...");
    _depensesStreamController.add(await _getDepenses()); // Notifie le Stream
  }
  /// Supprime toutes les dépenses de la base de données
  ///
  /// Cette méthode permet de supprimer toutes les dépenses.
  /// Elle est utilisée lorsque l'utilisateur clique sur le bouton de suppression
  /// dans la page qui liste ses dépenses.
  Future<void> deleteAllDepenses() async {
    final db = await database;
    await db.delete(_tableDepenses);
    print("Dépenses supprimées, notification du Stream...");
    _depensesStreamController.add(await _getDepenses()); // Notifie le Stream
  }

  /* Future<void> updateDepense(Depense depense) async {
    final db = await database;
    await db.update(
      _tableDepenses,
      depense.toMap(),
      where: 'id = ?',
      whereArgs: [depense.id],
    );
    print("Dépense mise à jour, notification du Stream...");
    _depensesStreamController.add(await _getDepenses());
  }  */
}