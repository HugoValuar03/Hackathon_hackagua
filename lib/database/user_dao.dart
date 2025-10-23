import 'package:sqflite/sqflite.dart';
import 'db_helper.dart';

class Usuario {
  final int? id;
  final String nome;
  final String email;
  final String senha;
  final String tipo;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.tipo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'tipo': tipo,
    };
  }

  static Usuario fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      senha: map['senha'],
      tipo: map['tipo'],
    );
  }
}

class UsuarioDao {
  // Inserir novo usuário
  static Future<void> inserirUsuario(Usuario usuario) async {
    final db = await DBHelper.database;
    await db.insert(
      'usuarios',
      usuario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Buscar usuário por e-mail e senha (para login)
  static Future<Usuario?> buscarPorEmailESenha(String email, String senha) async {
    final db = await DBHelper.database;
    final result = await db.query(
      'usuarios',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );

    if (result.isNotEmpty) {
      return Usuario.fromMap(result.first);
    }
    return null;
  }
}
