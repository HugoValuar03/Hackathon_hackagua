import 'package:flutter/material.dart';
import 'package:hackathon_hackagua/widgets/scaffold_with_nav.dart';

import '../main.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  static const _tabIndex = 3;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithNav(
      title: 'Perfil',
      currentIndex: _tabIndex,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 40,
                child: Icon(Icons.person, size: 40),
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Seu Perfil',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Pontos: ${AppState.pontos}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}
