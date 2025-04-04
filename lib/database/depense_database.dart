import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/depense.dart';
import 'dart:async'; // Importez dart:async pour StreamController
class DepenseDatabase {
  static final DepenseDatabase instance = DepenseDatabase._init();

  static Database? _dbInstance;

  static const String _dbFileName = 'depense.db';

  static const String _tableDepenses = 'depenses';

  final _depensesStreamController = StreamController<List<Depense>>.broadcast();

  Stream<List<Depense>> get depensesStream => _depensesStreamController.stream;

  DepenseDatabase._init() {
    // Initialise le flux avec les données existantes
    _initStream();
  }

  Future<void> _initStream() async {
    _depensesStreamController.addStream(
      Stream.fromFuture(_getDepenses()),
    );
  }

  Future<Database> get database async {
    if (_dbInstance != null) return _dbInstance!;
    _dbInstance = await _initDB(_dbFileName);
    return _dbInstance!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE depenses (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT NOT NULL,
      montant REAL NOT NULL,
      description TEXT NOT NULL
    );
  ''');

    await db.execute('''
    CREATE TABLE maximumDepense (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nom TEXT NOT NULL,
      maxDepense REAL NOT NULL
    );
  ''');

    // Insertion des valeurs de base
    await db.insert('maximumDepense', {'nom': 'food', 'maxDepense': 200});
    await db.insert('maximumDepense', {'nom': 'car', 'maxDepense': 200});
    await db.insert('maximumDepense', {'nom': 'housing', 'maxDepense': 200});
    await db.insert('maximumDepense', {'nom': 'other', 'maxDepense': 200});
  }

  Future<void> modifMax(double food, double car, double housing, double other) async {
    final db = await database;

    await db.update(
      'maximumDepense',
      {'maxDepense': food},
      where: 'nom = ?',
      whereArgs: ['food'],
    );

    await db.update(
      'maximumDepense',
      {'maxDepense': car},
      where: 'nom = ?',
      whereArgs: ['car'],
    );

    await db.update(
      'maximumDepense',
      {'maxDepense': housing},
      where: 'nom = ?',
      whereArgs: ['housing'],
    );

    await db.update(
      'maximumDepense',
      {'maxDepense': other},
      where: 'nom = ?',
      whereArgs: ['other'],
    );
  }

  Future<List<double>> getMax() async {
    final db = await database;

    final List<String> noms = ['food', 'car', 'housing', 'other'];
    final List<double> result = [];

    for (String nom in noms) {
      final List<Map<String, dynamic>> res = await db.query(
        'maximumDepense',
        where: 'nom = ?',
        whereArgs: [nom],
        limit: 1,
      );

      if (res.isNotEmpty) {
        result.add(res.first['maxDepense']);
      } else {
        result.add(0.0); // Valeur par défaut si l'entrée est absente
      }
    }
    return result;
  }

  Future<List<Depense>> _getDepenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableDepenses);
    return List.generate(maps.length, (i) => Depense.fromMap(maps[i]));
  }

  Future<int> insertDepense(Depense depense) async {
    final db = await database;
    final id = await db.insert(_tableDepenses, depense.toMap());
    print("Dépense insérée, notification du Stream...");
    _depensesStreamController.add(await _getDepenses()); // Notifie le Stream
    return id;
  }

  Future<List<Depense>> getAllDepenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableDepenses);
    return List.generate(maps.length, (i) => Depense.fromMap(maps[i]));
  }

  Future<void> deleteDepense(int id) async {
    final db = await database;
    await db.delete(_tableDepenses, where: 'id = ?', whereArgs: [id]);
    _depensesStreamController.add(await _getDepenses()); // Notifie le Stream
  }

  Future<void> deleteAllDepenses() async {
    final db = await database;
    await db.delete(_tableDepenses);
    _depensesStreamController.add(await _getDepenses()); // Notifie le Stream
  }

  void dispose() {
    _depensesStreamController.close();
  }

  Future<void> deleteDatabaseManually() async {
    // Récupère le chemin de la base de données
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'depense.db');

    // Supprime la base de données si elle existe
    try {
      await deleteDatabase(path);
      print("Base de données supprimée.");
    } catch (e) {
      print("Erreur lors de la suppression de la base de données: $e");
    }
  }
}