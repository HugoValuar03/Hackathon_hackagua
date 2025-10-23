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

    final pages = <Widget>[
      _buildPage(
        'Bem-vindo ao BioCycle',
        'Conectamos geradores e coletores de resíduos orgânicos.',
        Icons.eco,
      ),
      _buildPage(
        'Permissões',
        'Precisamos de sua localização para sugerir coletas próximas.',
        Icons.location_on,
      ),
      _buildPage(
        'Comece Agora',
        'Cadastre geradores e solicite coletas facilmente.',
        Icons.check,
      ),
    ];

    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (page) => setState(() => _currentPage = page),
        children: [
          _buildPage(
            'Bem-vindo ao BioCycle',
            'Conectamos geradores e coletores de resíduos orgânicos.',
            Icons.eco,
          ),
          _buildPage(
            'Permissões',
            'Precisamos de sua localização para sugerir coletas próximas.',
            Icons.location_on,
          ),
          _buildPage(
            'Comece Agora',
            'Cadastre geradores e solicite coletas facilmente.',
            Icons.check,
          ),
        ],
      ),
      bottomSheet: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DotsIndicator(
                count: pages.length,
                index: _currentPage,
                onDotTap: (i) => _controller.animateToPage(
                  i,
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOut,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      var perm = await Geolocator.checkPermission();
                      if (perm == LocationPermission.denied) {
                        perm = await Geolocator.requestPermission();
                      }
                    } catch (e) {
                      debugPrint('Erro ao pedir permissão: $e');
                    }
                    if (!mounted) return;
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text('Começar'),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: Theme.of(context).primaryColor),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(subtitle, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({
    required this.count,
    required this.index,
    this.onDotTap,
  });

  final int count;
  final int index;
  final ValueChanged<int>? onDotTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme
        .of(context)
        .colorScheme
        .primary;
    final inactiveColor = Colors.grey.withOpacity(0.35);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == index;
        return GestureDetector(
          onTap: onDotTap == null ? null : () => onDotTap!(i),
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            height: 8,
            width: isActive ? 22 : 8,
            // vira “pill” quando ativo
            decoration: BoxDecoration(
              color: isActive ? activeColor : inactiveColor,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        );
      }),
    );
  }
}