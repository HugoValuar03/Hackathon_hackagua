import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProdutorPerfilScreen extends StatefulWidget {
  const ProdutorPerfilScreen({super.key});

  @override
  State<ProdutorPerfilScreen> createState() => _ProdutorPerfilScreenState();
}

class _ProdutorPerfilScreenState extends State<ProdutorPerfilScreen> {
  String nome = '';
  String email = '';
  String tipo = '';
  String? fotoPerfil;

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  Future<void> _carregarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nome = prefs.getString('user_nome') ?? 'Nome do Estabelecimento';
      email = prefs.getString('user_email') ?? 'email@exemplo.com';
      tipo  = prefs.getString('user_tipo') ?? 'Produtor';
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs   = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Produtor', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1) Cabeçalho anatômico (avatar + identificação) dentro de um card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Semantics(
                          label: 'Foto de perfil',
                          child: CircleAvatar(
                            radius: 56,
                            backgroundColor: cs.secondaryContainer,
                            backgroundImage: (fotoPerfil != null) ? AssetImage(fotoPerfil!) : null,
                            child: fotoPerfil == null
                                ? Icon(Icons.person, size: 56, color: cs.onSecondaryContainer)
                                : null,
                          ),
                        ),
                        Tooltip(
                          message: 'Alterar foto',
                          child: Material(
                            color: cs.primary,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Alterar foto (em breve)')),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Icon(Icons.camera_alt_rounded, color: cs.onPrimary, size: 20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      nome,
                      style: text.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: cs.onSurface),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: ShapeDecoration(
                        color: cs.tertiaryContainer,
                        shape: StadiumBorder(side: BorderSide(color: cs.outlineVariant)),
                      ),
                      child: Text(
                        tipo,
                        style: text.labelLarge?.copyWith(color: cs.onTertiaryContainer, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 2) Informações gerais (texto explicativo) — mantém conteúdo, melhora legibilidade
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader(title: 'Informações Gerais', icon: Icons.info_outline),
                    const SizedBox(height: 8),
                    Text(
                      'Gerencie suas informações de produtor, pontos acumulados e benefícios disponíveis.',
                      style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 3) Pontos — destaque visual com cor do tema e tipografia
            Card(
              color: cs.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
                child: Column(
                  children: [
                    Text('Seus Pontos',
                        style: text.titleMedium?.copyWith(
                          color: cs.onPrimary,
                          fontWeight: FontWeight.w700,
                        )),
                    const SizedBox(height: 6),
                    Text('1200 pts',
                        style: text.headlineMedium?.copyWith(
                          color: cs.onPrimary,
                          fontWeight: FontWeight.w800,
                        )),
                    const SizedBox(height: 6),
                    Text(
                      'Troque por benefícios no marketplace!',
                      style: text.bodyMedium?.copyWith(color: cs.onPrimary.withOpacity(.85)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 4) Ações principais — hierarquia: primário (Filled), secundário (Tonal)
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/produtor/marketplace'),
                    icon: const Icon(Icons.shopping_bag),
                    label: const Text('Marketplace'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: () => Navigator.pushNamed(context, '/produtor/beneficios'),
                    icon: const Icon(Icons.redeem_rounded),
                    label: const Text('Benefícios'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 5) Histórico — em card, com divisores e toque maior
            _SectionHeader(title: 'Histórico de Coletas', icon: Icons.history),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 1,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: _mockHistorico.length,
                separatorBuilder: (_, __) => Divider(height: 1, color: cs.outlineVariant),
                itemBuilder: (_, i) {
                  final h = _mockHistorico[i];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundColor: cs.secondaryContainer,
                      child: Icon(Icons.recycling, color: cs.onSecondaryContainer),
                    ),
                    title: Text(h.titulo),
                    subtitle: Text(h.data),
                    trailing: Text(
                      h.pontos,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onTap: () {}, // preserva espaço para navegação futura
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // 6) Ação destrutiva (logout) — previsível e com contraste
            OutlinedButton.icon(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                if (!mounted) return;
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: Icon(Icons.logout_rounded, color: cs.error),
              label: Text('Sair', style: TextStyle(color: cs.error)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                side: BorderSide(color: cs.error),
                foregroundColor: cs.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Componentes de apoio (anatomia) ----------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tx = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(icon, color: cs.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: tx.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}

// estrutura simples para o histórico (mantém conteúdo original)
class _HistoricoItem {
  final String titulo;
  final String data;
  final String pontos;
  _HistoricoItem(this.titulo, this.data, this.pontos);
}

final _mockHistorico = <_HistoricoItem>[
  _HistoricoItem('Coleta nº 1043', '10 de Outubro de 2025', '+50 pts'),
  _HistoricoItem('Coleta nº 1032', '28 de Setembro de 2025', '+80 pts'),
];
