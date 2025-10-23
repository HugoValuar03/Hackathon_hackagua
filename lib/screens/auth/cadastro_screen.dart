import 'package:flutter/material.dart';
import 'package:hackathon_hackagua/database/user_dao.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen>
    with TickerProviderStateMixin {
  bool _showProdutor = false;
  bool _showColetor = false;

  final _tiposGerador = const [
    'Instituição de Ensino',
    'Restaurante',
    'Lanchonete',
  ];

  String? _tipoGerador;

  final _nomeProdutor = TextEditingController();
  final _emailProdutor = TextEditingController();
  final _senhaProdutor = TextEditingController(); // 🆕 Campo de senha produtor

  final _nomeColetor = TextEditingController();
  final _areaColetor = TextEditingController();
  final _senhaColetor = TextEditingController(); // 🆕 Campo de senha coletor

  @override
  void dispose() {
    _nomeProdutor.dispose();
    _emailProdutor.dispose();
    _senhaProdutor.dispose(); // 🆕
    _nomeColetor.dispose();
    _areaColetor.dispose();
    _senhaColetor.dispose(); // 🆕
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    Image.asset('lib/assets/app_logo.png', width: 260),
                    const SizedBox(height: 8),
                    Text(
                      'Cadastrar-se',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 28),

                    LayoutBuilder(
                      builder: (context, c) {
                        final isWide = c.maxWidth >= 760;

                        final produtorCard = _PerfilCard(
                          titulo: 'Produtor',
                          botaoLabel: _showProdutor
                              ? 'Fechar'
                              : 'Cadastrar Produtor',
                          onBotao: () =>
                              setState(() => _showProdutor = !_showProdutor),
                          child: _ProdutorForm(
                            show: _showProdutor,
                            nomeCtrl: _nomeProdutor,
                            emailCtrl: _emailProdutor,
                            senhaCtrl: _senhaProdutor,
                            // 🆕
                            tipos: _tiposGerador,
                            selectedTipo: _tipoGerador,
                            onChangedTipo: (v) =>
                                setState(() => _tipoGerador = v),
                            onSubmit: () async {
                              if (_tipoGerador == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Selecione o tipo do produtor',
                                    ),
                                  ),
                                );
                                return;
                              }

                              final usuario = Usuario(
                                nome: _nomeProdutor.text.trim(),
                                email: _emailProdutor.text.trim(),
                                senha: _senhaProdutor.text.trim(),
                                tipo: 'Produtor',
                              );

                              // Opcional: capture referências antes do await
                              final messenger = ScaffoldMessenger.of(context);
                              final navigator = Navigator.of(context);

                              try {
                                await UsuarioDao.inserirUsuario(usuario);

                                if (!mounted) return;
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Produtor cadastrado (${_tipoGerador})!',
                                    ),
                                  ),
                                );

                                if (navigator.canPop()) {
                                  navigator.pop();
                                } else {
                                  navigator.pushReplacementNamed('/cadastro');
                                }
                              } catch (e) {
                                if (!mounted) return;
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text('Erro ao cadastrar: $e'),
                                  ),
                                );
                              }
                            },
                          ),
                        );

                        final coletorCard = _PerfilCard(
                          titulo: 'Coletor',
                          botaoLabel: _showColetor
                              ? 'Fechar'
                              : 'Cadastrar Coletor',
                          onBotao: () =>
                              setState(() => _showColetor = !_showColetor),
                          child: _ColetorForm(
                            show: _showColetor,
                            nomeCtrl: _nomeColetor,
                            areaCtrl: _areaColetor,
                            senhaCtrl: _senhaColetor,
                            // 🆕
                            onSubmit: () async {
                              final usuario = Usuario(
                                nome: _nomeColetor.text.trim(),
                                email: _areaColetor.text.trim(),
                                // ⚠️ ideal ter um campo de e-mail real
                                senha: _senhaColetor.text.trim(),
                                tipo: 'Coletor',
                              );

                              final messenger = ScaffoldMessenger.of(context);
                              final navigator = Navigator.of(context);

                              try {
                                await UsuarioDao.inserirUsuario(usuario);

                                if (!mounted) return;
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text('Coletor cadastrado!'),
                                  ),
                                );

                                // <<< AQUI entra a navegação >>>
                                if (navigator.canPop()) {
                                  navigator.pop();
                                } else {
                                  navigator.pushReplacementNamed(
                                    '/login',
                                  ); // ou '/marketplace'
                                }
                              } catch (e) {
                                if (!mounted) return;
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text('Erro ao cadastrar: $e'),
                                  ),
                                );
                              }
                            },
                          ),
                        );

                        if (!isWide) {
                          return Column(
                            children: [
                              produtorCard,
                              const SizedBox(height: 16),
                              coletorCard,
                            ],
                          );
                        }

                        return IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: produtorCard),
                              const VerticalDivider(width: 28, thickness: 1.2),
                              Expanded(child: coletorCard),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Já tem conta?',
                          style: TextStyle(color: Color(0xFF000000)),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, '/login'),
                          child: const Text('Logar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ---------- Widgets auxiliares ---------- */

class _PerfilCard extends StatelessWidget {
  const _PerfilCard({
    required this.titulo,
    required this.botaoLabel,
    required this.onBotao,
    required this.child,
  });

  final String titulo;
  final String botaoLabel;
  final VoidCallback onBotao;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              titulo,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onBotao,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2F4C30),
                minimumSize: const Size.fromHeight(44),
              ),
              child: Text(
                botaoLabel,
                style: TextStyle(color: theme.colorScheme.onPrimary),
              ),
            ),

            // Área expansível com os campos
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProdutorForm extends StatelessWidget {
  const _ProdutorForm({
    required this.show,
    required this.nomeCtrl,
    required this.emailCtrl,
    required this.senhaCtrl, // 🆕
    required this.tipos,
    required this.selectedTipo,
    required this.onChangedTipo,
    required this.onSubmit,
  });

  final bool show;
  final TextEditingController nomeCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController senhaCtrl; // 🆕

  final List<String> tipos;
  final String? selectedTipo;
  final ValueChanged<String?> onChangedTipo;

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();

    final safeValue = tipos.contains(selectedTipo) ? selectedTipo : null;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          TextFormField(
            controller: nomeCtrl,
            decoration: const InputDecoration(
              labelText: 'Nome do estabelecimento',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: safeValue,
            items: tipos
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: onChangedTipo,
            decoration: const InputDecoration(
              labelText: 'Tipo de estabelecimento',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            validator: (v) => v == null ? 'Selecione um tipo' : null,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'E-mail',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: senhaCtrl,
            decoration: const InputDecoration(
              labelText: 'Senha',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
              isDense: true,
            ),
            obscureText: true,
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onSubmit,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
              backgroundColor: const Color(0xFF6CB40C),
            ),
            child: const Text('Salvar Produtor'),
          ),
        ],
      ),
    );
  }
}

class _ColetorForm extends StatelessWidget {
  const _ColetorForm({
    required this.show,
    required this.nomeCtrl,
    required this.areaCtrl,
    required this.senhaCtrl, // 🆕
    required this.onSubmit,
  });

  final bool show;
  final TextEditingController nomeCtrl;
  final TextEditingController areaCtrl;
  final TextEditingController senhaCtrl; // 🆕
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          TextFormField(
            controller: nomeCtrl,
            decoration: const InputDecoration(
              labelText: 'Nome da operação',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: areaCtrl,
            decoration: const InputDecoration(
              labelText: 'Área de atendimento',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: senhaCtrl,
            decoration: const InputDecoration(
              labelText: 'Senha',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
              isDense: true,
            ),
            obscureText: true,
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onSubmit,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
              backgroundColor: Color(0xFF6CB40C),
            ),
            child: const Text('Salvar Coletor'),
          ),
        ],
      ),
    );
  }
}
