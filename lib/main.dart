import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hackathon_hackagua/maps/maps_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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


// =====================================
// MAIN UNIVERSAL (mobile + desktop)
// =====================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Ativa o modo FFI apenas em desktop
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // 🔹 Carrega dados globais
  await AppState.loadData();

  runApp(const BioCycleApp());
}

// =====================================
// APP
// =====================================
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
        '/coletor/mapa': (context) => const MapsScreen(),
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

// =====================================
// ESTADO GLOBAL
// =====================================
class AppState {
  static List<Gerador> geradores = [];
  static List<Coletor> coletores = [];
  static List<Coleta> coletas = [];
  static List<Produto> produtos = [];
  static int pontos = 0;

  // bump aqui para refazer seed quando mudar a lista
  static const int _dataVersion = 2;

  static Future<void> loadData({bool forceSeed = false}) async {
    final prefs = await SharedPreferences.getInstance();

    final g = prefs.getString('geradores');
    final c = prefs.getString('coletores');
    final co = prefs.getString('coletas');
    if (g != null) geradores = (jsonDecode(g) as List).map((e) => Gerador.fromJson(e)).toList();
    if (c != null) coletores = (jsonDecode(c) as List).map((e) => Coletor.fromJson(e)).toList();
    if (co != null) coletas = (jsonDecode(co) as List).map((e) => Coleta.fromJson(e)).toList();
    pontos = prefs.getInt('pontos') ?? 0;

    final storedVersion = prefs.getInt('data_version') ?? 0;

    if (forceSeed || storedVersion < _dataVersion) {
      await _seedProdutos(reset: true);
      await prefs.setInt('data_version', _dataVersion);
    }

    produtos = await DBHelper.getProdutos();

    if (produtos.isEmpty) {
      await _seedProdutos(reset: false);
      produtos = await DBHelper.getProdutos();
    }
  }

  static Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('geradores', jsonEncode(geradores.map((e) => e.toJson()).toList()));
    await prefs.setString('coletores', jsonEncode(coletores.map((e) => e.toJson()).toList()));
    await prefs.setString('coletas', jsonEncode(coletas.map((e) => e.toJson()).toList()));
    await prefs.setInt('pontos', pontos);
  }

  // chame isto manualmente caso queira um botão "Resetar catálogo"
  static Future<void> resetarProdutosComSeed() async {
    await _seedProdutos(reset: true);
    produtos = await DBHelper.getProdutos();
  }

  static Future<void> _seedProdutos({required bool reset}) async {
    debugPrint('[SEED] _seedProdutos(reset: $reset) chamado');
    if (reset) await DBHelper.clearProdutos();

    final seed = <Produto>[
      Produto(
        id: 'p0',
        nome: 'Queimador de Biogás (Fogareiro)',
        descricao: 'Queimador ajustável para uso culinário com biogás.',
        precoPontos: 25,
        imagemUrl: 'assets/equipamentos-acessorios-biogas-brasil.jpg',
      ),
      Produto(
        id: 'p4',
        nome: 'Medidor de Vazão para Biogás',
        descricao: 'Rotâmetro para monitoramento de vazão no sistema.',
        precoPontos: 35,
        imagemUrl: 'assets/images-litros.jpeg',
      ),
      Produto(
        id: 'p5',
        nome: 'Armazenador de Biogás (Gas Bag 1m³)',
        descricao: 'Bolsa flexível para armazenamento temporário de biogás.',
        precoPontos: 45,
        imagemUrl: 'assets/images-litros-2.jpeg',
      ),
      Produto(
        id: 'p1',
        nome: 'Biodigestor Residencial (80L)',
        descricao: 'Biodigestor compacto para produção de biogás doméstico.',
        precoPontos: 50,
        imagemUrl: 'assets/equipamentos-acessorios-biogas-brasil.jpg',
      ),
      Produto(
        id: 'p2',
        nome: 'Kit de Tubulações e Válvulas para Biogás',
        descricao: 'Mangueiras, conexões e válvulas para linha de gás.',
        precoPontos: 30,
        imagemUrl: 'assets/images-litros.jpeg',
      ),
      Produto(
        id: 'p3',
        nome: 'Filtro de H₂S (Scrubber) para Biogás',
        descricao: 'Mídia filtrante para remoção de sulfeto de hidrogênio.',
        precoPontos: 20,
        imagemUrl: 'assets/images-litros-2.jpeg',
      ),
    ];

    for (final p in seed) {
      await DBHelper.insertProduto(p);
    }
  }
}

