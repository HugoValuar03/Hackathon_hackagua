import 'dart:io';
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
<<<<<<< HEAD
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'biocycle.db');
=======
    String path;

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Caminho manual para desktop
      path = join(Directory.current.path, _dbName);
    } else {
      // Caminho padrão para Android/iOS
      final dbPath = await getDatabasesPath();
      path = join(dbPath, _dbName);
    }
>>>>>>> origin/master

    // 🔁 Sempre recria o banco ao iniciar o app
    await deleteDatabase(path);

    // 🔧 Criação do novo banco
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // 🧱 Tabela de produtos
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

        // 🧱 Tabela de usuários
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

  // 🧩 CRUD de produtos (mantido igual ao original)
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

  // 🧪 Utilitário opcional: listar usuários no console
  static Future<void> printUsuarios() async {
    final db = await database;
    final users = await db.query('usuarios');
    for (var u in users) {
      print('👤 ${u['nome']} (${u['email']}) - ${u['tipo']}');
    }
  }
}
