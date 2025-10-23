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
    final dbPath = await getDatabasesPath(); // Funciona para mobile e desktop agora
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: 1,
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
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            email TEXT UNIQUE,
            senha TEXT,
            tipo TEXT
          )
        ''');

        final usuariosIniciais = [
          {'nome': 'Eco Restaurante', 'email': 'eco@restaurante.com', 'senha': '123456', 'tipo': 'Produtor'},
          {'nome': 'Verde Escola', 'email': 'verde@escola.com', 'senha': '123456', 'tipo': 'Produtor'},
          {'nome': 'AgroVida', 'email': 'agrovida@bio.com', 'senha': '123456', 'tipo': 'Produtor'},
          {'nome': 'Natureza Viva', 'email': 'natureza@viva.com', 'senha': '123456', 'tipo': 'Produtor'},
          {'nome': 'BioSabor', 'email': 'biosabor@comida.com', 'senha': '123456', 'tipo': 'Produtor'},

          {'nome': 'EcoColeta', 'email': 'eco@coleta.com', 'senha': '123456', 'tipo': 'Coletor'},
          {'nome': 'ReciclaMais', 'email': 'recicla@mais.com', 'senha': '123456', 'tipo': 'Coletor'},
          {'nome': 'BioTrans', 'email': 'biotrans@eco.com', 'senha': '123456', 'tipo': 'Coletor'},
          {'nome': 'VerdeLog', 'email': 'verdelog@coleta.com', 'senha': '123456', 'tipo': 'Coletor'},
          {'nome': 'CleanWaste', 'email': 'clean@waste.com', 'senha': '123456', 'tipo': 'Coletor'},
        ];

        for (var u in usuariosIniciais) {
          await db.insert('usuarios', u);
        }
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
    final users = await db.query('usuarios');
    for (var u in users) {
      print('👤 ${u['nome']} (${u['email']}) - ${u['tipo']}');
    }
  }
}
