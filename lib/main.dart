import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'models.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cadastro_gerador_screen.dart';
import 'screens/cadastro_coletor_screen.dart';
import 'screens/solicitar_coleta_screen.dart';
import 'screens/detalhe_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/historico_screen.dart';
import 'screens/recompensas_screen.dart';
import 'screens/perfil_screen.dart';
import 'screens/notificacoes_screen.dart';
import 'screens/admin_mapa_screen.dart';
import 'screens/cadastro_screen.dart';

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
        // '/home': (context) => const HomeScreen(),
        '/cadastro/gerador': (context) => const CadastroGeradorScreen(),
        '/cadastro/coletor': (context) => const CadastroColetorScreen(),
        // '/solicitar': (context) => const SolicitarColetaScreen(),
        // '/detalhe/gerador': (context) => const DetalheScreen(isGerador: true),
        // '/detalhe/coletor': (context) => const DetalheScreen(isGerador: false),
        // '/dashboard': (context) => const DashboardScreen(),
        // '/historico': (context) => const HistoricoScreen(),
        // '/recompensas': (context) => const RecompensasScreen(),
        // '/perfil': (context) => const PerfilScreen(),
        // '/notificacoes': (context) => const NotificacoesScreen(),
        // '/admin/mapa': (context) => const AdminMapaScreen(),
      },
    );
  }
}

// Estado global (simplificado, use Provider ou Riverpod para produção)
class AppState {
  static List<Gerador> geradores = [];
  static List<Coletor> coletores = [];
  static List<Coleta> coletas = [];
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
  }

  static Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('geradores', jsonEncode(geradores.map((e) => e.toJson()).toList()));
    prefs.setString('coletores', jsonEncode(coletores.map((e) => e.toJson()).toList()));
    prefs.setString('coletas', jsonEncode(coletas.map((e) => e.toJson()).toList()));
    prefs.setInt('pontos', pontos);
  }
}