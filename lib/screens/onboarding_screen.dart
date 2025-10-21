import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (page) => setState(() => _currentPage = page),
        children: [
          _buildPage('Bem-vindo ao BioCycle', 'Conectamos geradores e coletores de resíduos orgânicos.', Icons.eco),
          _buildPage('Permissões', 'Precisamos de sua localização para sugerir coletas próximas.', Icons.location_on),
          _buildPage('Comece Agora', 'Cadastre geradores e solicite coletas facilmente.', Icons.check),
        ],
      ),
      bottomSheet: _currentPage == 2
          ? ElevatedButton(
              onPressed: () async {
                await Geolocator.requestPermission();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Começar'),
            )
          : TextButton(onPressed: () => Navigator.pushReplacementNamed(context, '/login'), child: const Text('Pular')),
    );
  }

  Widget _buildPage(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: Theme.of(context).primaryColor),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(subtitle, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}