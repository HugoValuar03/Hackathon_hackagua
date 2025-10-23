import 'package:flutter/material.dart';
import 'produtor_app_bottom_nav.dart';
import 'coletor_app_bottom_nav.dart';

enum UserRole { produtor, coletor }

/// Wrapper padrão para telas com AppBar + BottomNav.
class ScaffoldWithNav extends StatelessWidget {
  const ScaffoldWithNav({
    super.key,
    required this.title,
    required this.currentIndex,
    required this.body,
    this.actions,
    this.enabledNav = true,
    required this.role, // <<< escolha de barra
  });

  final String title;
  final int currentIndex; // 0..3
  final Widget body;
  final List<Widget>? actions;
  final bool enabledNav;
  final UserRole role;

  @override
  Widget build(BuildContext context) {
    final bottomNav = switch (role) {
      UserRole.produtor => ProdutorAppBottomNav(
        currentIndex: currentIndex,
        enabled: enabledNav,
      ),
      UserRole.coletor => ColetorAppBottomNav(
        currentIndex: currentIndex,
        enabled: enabledNav,
      ),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: actions,
      ),
      body: body,
      bottomNavigationBar: bottomNav,
    );
  }
}
