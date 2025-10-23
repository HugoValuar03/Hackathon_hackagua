import 'package:flutter/material.dart';

class ColetorAppBottomNav extends StatelessWidget {
  const ColetorAppBottomNav({
    super.key,
    required this.currentIndex,
    this.enabled = true,
  });

  final int currentIndex;
  final bool enabled;

  /// Rotas em ordem do índice da barra (coletor).
  static const routes = <String>[
    '/coletor/marketplace',
    '/coletor/mapa',
    '/coletor/beneficios',
    '/coletor/perfil',
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: false,
      onTap: enabled
          ? (i) {
        if (i == currentIndex) return;
        Navigator.pushReplacementNamed(context, routes[i]);
      }
          : null,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.storefront_outlined),
          activeIcon: Icon(Icons.storefront),
          label: 'Market',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          activeIcon: Icon(Icons.map),
          label: 'Mapa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events_outlined),
          activeIcon: Icon(Icons.emoji_events),
          label: 'Benefícios',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}
