// widgets/scaffold_with_nav.dart
import 'package:flutter/material.dart';
import 'produtor_app_bottom_nav.dart';
import 'coletor_app_bottom_nav.dart';

enum UserRole { produtor, coletor }

class ScaffoldWithNav extends StatelessWidget {
  const ScaffoldWithNav({
    super.key,
    required this.title,
    required this.currentIndex,
    required this.body,
    required this.role,
    this.actions,
    this.enabledNav = true,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  final String title;
  final int currentIndex;
  final Widget body;
  final UserRole role;
  final List<Widget>? actions;
  final bool enabledNav;

  // NOVO
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

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
      appBar: AppBar(title: Text(title), centerTitle: true, actions: actions),
      body: body,
      bottomNavigationBar: bottomNav,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation:
          floatingActionButtonLocation ?? FloatingActionButtonLocation.endFloat,
    );
  }
}
