import 'package:flutter/material.dart';
import 'package:hackathon_hackagua/widgets/scaffold_with_nav.dart';

import '../../main.dart';

class ProdutorPerfilScreen extends StatelessWidget {
  const ProdutorPerfilScreen({super.key});

  static const _tabIndex = 3;

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithNav(
      title: 'Perfil Produtor',
      currentIndex: _tabIndex,
      role: UserRole.produtor,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
        children: [
          // Cabeçalho
          Row(
            children: [
              const CircleAvatar(
                radius: 36,
                child: Icon(Icons.person, size: 36),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nome do Usuário',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'email@exemplo.com',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: () {
                  // TODO: implementar troca de foto
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Foto'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Pontos & Selos
          Card(
            child: ListTile(
              leading: const Icon(Icons.stars),
              title: Text('Pontos disponíveis: ${AppState.pontos}'),
              trailing: TextButton(
                onPressed: () => Navigator.pushNamed(context, '/beneficios'),
                child: const Text('Ver selos'),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Mini-dashboard de impacto
          Row(
            children: const [
              _ImpactoCard(titulo: 'Água (L)', valor: '12.5'),
              SizedBox(width: 8),
              _ImpactoCard(titulo: 'CO₂ (kg)', valor: '3.1'),
              SizedBox(width: 8),
              _ImpactoCard(titulo: 'Chorume (L)', valor: '5.0'),
            ],
          ),

          const SizedBox(height: 12),

          // Ações rápidas
          GridView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.6,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            children: [
              _ActionCard(
                icon: Icons.local_shipping,
                label: 'Solicitar coleta',
                onTap: () => Navigator.pushNamed(context, '/solicitar-coleta'),
              ),
              _ActionCard(
                icon: Icons.history,
                label: 'Minhas coletas',
                onTap: () => Navigator.pushNamed(context, '/coletas'),
              ),
              _ActionCard(
                icon: Icons.map,
                label: 'Endereço / Área',
                onTap: () => Navigator.pushNamed(context, '/mapa'),
              ),
              _ActionCard(
                icon: Icons.edit,
                label: 'Editar dados',
                onTap: () {
                  // TODO: abrir formulário de edição
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Preferências
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: true,
                  onChanged: (v) {
                    // TODO: salvar preferência
                  },
                  title: const Text('Notificações'),
                  subtitle: const Text(
                    'Receber atualizações das coletas e marketplace',
                  ),
                ),
                const Divider(height: 0),
                SwitchListTile(
                  value: true,
                  onChanged: (v) {
                    // TODO: salvar preferência
                  },
                  title: const Text('Usar minha localização'),
                  subtitle: const Text('Sugerir parceiros próximos'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Sair
          OutlinedButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            child: const Text('Sair'),
          ),

          const SizedBox(height: 12),
          const Center(
            child: Text(
              'BioCycle v0.1.0 • Suporte',
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImpactoCard extends StatelessWidget {
  const _ImpactoCard({required this.titulo, required this.valor});

  final String titulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: Column(
            children: [
              Text(
                valor,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: Colors.black12),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
