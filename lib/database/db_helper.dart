import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models.dart';

class DBHelper {
  static Database? _db;

  static const _dbName = 'biocycle.db';
  static const _dbVersion = 1;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath(); // Funciona para mobile e desktop agora
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE produtos(
            id TEXT PRIMARY KEY,
            nome TEXT,
            categoria TEXT,
            descricao TEXT,
            precoPontos INTEGER,
            imagemUrl TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE usuarios(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            email TEXT UNIQUE,
            senha TEXT,
            tipo TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertProduto(Produto produto) async {
    final db = await database;
    await db.insert(
      'produtos',
      produto.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Produto>> getProdutos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('produtos');
    return List.generate(maps.length, (i) => Produto.fromJson(maps[i]));
  }

  static Future<void> deleteAllProdutos() async {
    final db = await database;
    await db.delete('produtos');
  }

  static Future<void> printUsuarios() async {
    final db = await database;
    final result = await db.query('usuarios');
    for (final row in result) {
      print('👤 Usuário: ${row['nome']} | Email: ${row['email']} | Tipo: ${row['tipo']}');
    }
  }
}
