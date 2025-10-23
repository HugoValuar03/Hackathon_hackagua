import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hackathon_hackagua/screens/Produtor/marketplace_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database/db_helper.dart';
import 'models.dart';
import 'screens/Produtor/beneficios_screen.dart';
import 'screens/auth/cadastro_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/Produtor/perfil_screen.dart';


void main() {
  runApp(const BioCycleApp());
}

class BioCycleApp extends StatelessWidget {
  const BioCycleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BioCycle',
      theme: ThemeData(
        primaryColor: const Color(0xFF2d8f6f),
        scaffoldBackgroundColor: const Color(0xFFf6f8fb),
        fontFamily: 'Inter',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/cadastro': (context) => const CadastroScreen(),
        '/beneficios': (context) => const BeneficiosScreen(),
        '/marketplace': (context) => const MarketplaceScreen(),
        '/perfil': (context) => const PerfilScreen(),
      },
    );
  }
}


class AppState {
  static List<Gerador> geradores = [];
  static List<Coletor> coletores = [];
  static List<Coleta> coletas = [];
  static List<Produto> produtos = [];
  static int pontos = 0;

  static Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final g = prefs.getString('geradores');
    final c = prefs.getString('coletores');
    final co = prefs.getString('coletas');

    if (g != null) geradores = (jsonDecode(g) as List).map((e) => Gerador.fromJson(e)).toList();
    if (c != null) coletores = (jsonDecode(c) as List).map((e) => Coletor.fromJson(e)).toList();
    if (co != null) coletas = (jsonDecode(co) as List).map((e) => Coleta.fromJson(e)).toList();
    pontos = prefs.getInt('pontos') ?? 0;

    // Carrega produtos do SQLite
    produtos = await DBHelper.getProdutos();

    if (produtos.isEmpty) {
      produtos = [
        Produto(
          id: 'p1',
          nome: 'Composto Orgânico 5kg',
          categoria: 'composto',
          descricao: 'Composto rico em nutrientes para plantas.',
          precoPontos: 50,
          imagemUrl: 'assets/images/composto.png',
        ),
        Produto(
          id: 'p2',
          nome: 'Sementes de Hortaliças',
          categoria: 'sementes',
          descricao: 'Pacote com sementes variadas.',
          precoPontos: 30,
          imagemUrl: 'assets/images/sementes.png',
        ),
        Produto(
          id: 'p3',
          nome: 'Crédito Verde (1kg CO₂)',
          categoria: 'credito',
          descricao: 'Reduza sua pegada de carbono.',
          precoPontos: 20,
          imagemUrl: 'assets/images/credito.png',
        ),
      ];

      for (var p in produtos) {
        await DBHelper.insertProduto(p);
      }
    }
  }

  static Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('geradores', jsonEncode(geradores.map((e) => e.toJson()).toList()));
    prefs.setString('coletores', jsonEncode(coletores.map((e) => e.toJson()).toList()));
    prefs.setString('coletas', jsonEncode(coletas.map((e) => e.toJson()).toList()));
    prefs.setInt('pontos', pontos);
  }
}
