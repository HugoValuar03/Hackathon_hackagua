import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hackathon_hackagua/maps/maps_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database/db_helper.dart';
import 'models.dart';

// ==== AUTENTICAÇÃO ====
import 'screens/auth/cadastro_screen.dart';
import 'screens/auth/login_screen.dart';

// ==== GERAIS ====
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';

// ==== PRODUTOR ====
import 'screens/produtor/produtor_beneficios_screen.dart';
import 'screens/produtor/produtor_marketplace_screen.dart';
import 'screens/produtor/produtor_perfil_screen.dart';

// ==== COLETOR ====
import 'screens/coletor/coletor_dashboard.dart';
import 'screens/coletor/coletor_marketplace_screen.dart';
import 'screens/coletor/coletor_perfil_screen.dart';


import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa sqflite para desktop
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  // Carrega dados globais
  await AppState.loadData();

  runApp(const BioCycleApp());
}


class BioCycleApp extends StatelessWidget {
  const BioCycleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(


    title: 'BioCycle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          contentTextStyle: const TextStyle(fontSize: 15),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2d8f6f)),
        scaffoldBackgroundColor: const Color(0xFFf6f8fb),
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        // ==== ROTAS GERAIS ====
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/cadastro': (context) => const CadastroScreen(),



        // ==== PRODUTOR ====
        '/produtor/beneficios': (context) => const ProdutorBeneficiosScreen(),
        '/produtor/marketplace': (context) => const ProdutorMarketplaceScreen(),
        '/produtor/perfil': (context) => const ProdutorPerfilScreen(),
        '/produtor/mapa': (context) => const MapsScreen(),


        // ==== COLETOR ====
        '/coletor/dashboard': (context) => const ColetorDashboard(),
        '/coletor/marketplace': (context) => const ColetorMarketplaceScreen(),
        '/coletor/perfil': (context) => const ColetorPerfilScreen(),
      },

      onUnknownRoute: (settings) {
        debugPrint('⚠️ Rota não encontrada: ${settings.name}');
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      },
    );
  }
}

/// ===============================================================
/// GERENCIAMENTO GLOBAL DE ESTADO (AppState)
/// ===============================================================
class AppState {
  static List<Gerador> geradores = [];
  static List<Coletor> coletores = [];
  static List<Coleta> coletas = [];
  static List<Produto> produtos = [];
  static int pontos = 0;

  /// Carrega SharedPreferences e dados locais
  static Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final g = prefs.getString('geradores');
    final c = prefs.getString('coletores');
    final co = prefs.getString('coletas');

    if (g != null) {
      geradores = (jsonDecode(g) as List)
          .map((e) => Gerador.fromJson(e))
          .toList();
    }
    if (c != null) {
      coletores = (jsonDecode(c) as List)
          .map((e) => Coletor.fromJson(e))
          .toList();
    }
    if (co != null) {
      coletas = (jsonDecode(co) as List)
          .map((e) => Coleta.fromJson(e))
          .toList();
    }

    pontos = prefs.getInt('pontos') ?? 0;

    // ==== SQLite: produtos ====
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

  /// Salva estado global
  static Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs
      ..setString('geradores',
          jsonEncode(geradores.map((e) => e.toJson()).toList()))
      ..setString('coletores',
          jsonEncode(coletores.map((e) => e.toJson()).toList()))
      ..setString(
          'coletas', jsonEncode(coletas.map((e) => e.toJson()).toList()))
      ..setInt('pontos', pontos);
  }
}
