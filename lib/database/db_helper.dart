import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'biocycle.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // 🟩 Tabela de produtos (já existente)
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

        // 🟩 Tabela de usuários (necessária para o cadastro/login)
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

  // 🧩 Inserir produto
  static Future<void> insertProduto(Produto produto) async {
    final db = await database;
    await db.insert(
      'produtos',
      produto.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 🧩 Buscar produtos
  static Future<List<Produto>> getProdutos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('produtos');
    return List.generate(maps.length, (i) => Produto.fromJson(maps[i]));
  }

  // 🧩 Deletar todos os produtos
  static Future<void> deleteAllProdutos() async {
    final db = await database;
    await db.delete('produtos');
  }
}
