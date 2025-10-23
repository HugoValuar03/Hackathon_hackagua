import 'package:flutter/material.dart';
import 'app_bottom_nav.dart';

/// Wrapper padrão para telas com AppBar + BottomNav.
class ScaffoldWithNav extends StatelessWidget {
  const ScaffoldWithNav({
    super.key,
    required this.title,
    required this.currentIndex,
    required this.body,
    this.actions,
    this.enabledNav = true,
  });

  final String title;
  final int currentIndex;
  final Widget body;
  final List<Widget>? actions;
  final bool enabledNav;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true, // título centralizado
        actions: actions,
      ),
      body: body,
      bottomNavigationBar: AppBottomNav(
        currentIndex: currentIndex,
        enabled: enabledNav,
      ),
    );
  }
}
