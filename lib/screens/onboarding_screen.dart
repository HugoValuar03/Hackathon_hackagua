import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;
  bool _requestingPermission = false;

  final _pages = const [
    _OnbContent(
      title: 'Bem-vindo ao BioCycle',
      subtitle:
      'Conecte geradores e coletores de resíduos orgânicos com rotas eficientes e impacto medido em tempo real.',
      icon: Icons.eco,
      bullets: [
        'Encontre parceiros próximos',
        'Acompanhe coletas e impactos',
        'Ganhe créditos verdes'
      ],
    ),
    _OnbContent(
      title: 'Sua localização melhora as sugestões',
      subtitle:
      'Usamos sua posição apenas para sugerir coletas e rotas por perto. Você controla isso nas configurações.',
      icon: Icons.location_on,
      bullets: [
        'Permissão opcional e revogável',
        'Usada apenas durante o uso',
        'Sem compartilhamento com terceiros'
      ],
      showPermissionCTA: true,
    ),
    _OnbContent(
      title: 'Pronto para começar?',
      subtitle:
      'Cadastre um gerador ou solicite sua primeira coleta. Leva menos de 1 minuto.',
      icon: Icons.check_circle,
      bullets: ['Cadastro simples', 'Mapa interativo', 'Suporte no app'],
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleLocationPermission() async {
    setState(() => _requestingPermission = true);
    try {
      var status = await Geolocator.checkPermission();
      if (status == LocationPermission.denied) {
        status = await Geolocator.requestPermission();
      }
      if (status == LocationPermission.deniedForever) {
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Permissão necessária'),
            content: const Text(
              'A permissão de localização foi negada permanentemente. '
                  'Você pode ativá-la nas configurações do sistema para receber sugestões próximas.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Agora não'),
              ),
              FilledButton.tonal(
                onPressed: () {
                  Navigator.pop(context);
                  Geolocator.openAppSettings();
                },
                child: const Text('Abrir configurações'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível solicitar a permissão. ($e)')),
      );
    } finally {
      if (mounted) setState(() => _requestingPermission = false);
    }
  }

  void _goNext() {
    if (_index < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _goPrev() {
    if (_index > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = _pages.length;
    final isLast = _index == total - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar com “Pular”
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  // Voltar só aparece a partir da página 1
                  if (_index > 0)
                    IconButton(
                      tooltip: 'Voltar',
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _goPrev,
                    )
                  else
                    const SizedBox(width: 48),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text('Pular'),
                  ),
                ],
              ),
            ),

            // Indicador de progresso linear (percepção de avanço)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: (_index + 1) / total,
                  minHeight: 6,
                  semanticsLabel: 'Progresso do onboarding',
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Conteúdo paginado
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: total,
                onPageChanged: (i) => setState(() => _index = i),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, i) {
                  final page = _pages[i];
                  return _OnboardingPage(
                    content: page,
                    onRequestPermission: _handleLocationPermission,
                    requestingPermission: _requestingPermission,
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // CTA principal persistente
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Dots(count: total, index: _index, onTap: (i) {
              _controller.animateToPage(
                i,
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOut,
              );
            }),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _goNext,
                child: Text(isLast ? 'Começar' : 'Avançar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.content,
    required this.onRequestPermission,
    required this.requestingPermission,
  });

  final _OnbContent content;
  final VoidCallback onRequestPermission;
  final bool requestingPermission;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.colorScheme.primary;

    return Semantics(
      label: content.title,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTall = constraints.biggest.height > 560;
            return Column(
              mainAxisAlignment:
              isTall ? MainAxisAlignment.center : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(content.icon, size: 112, color: iconColor),
                const SizedBox(height: 20),
                Text(
                  content.title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  content.subtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                if (content.bullets != null)
                  Column(
                    children: content.bullets!
                        .map(
                          (b) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check, size: 18),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                b,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        .toList(),
                  ),
                if (content.showPermissionCTA) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 340,
                    child: FilledButton.tonalIcon(
                      onPressed: requestingPermission ? null : onRequestPermission,
                      icon: requestingPermission
                          ? const SizedBox(
                          width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.my_location),
                      label: Text(
                        requestingPermission
                            ? 'Solicitando permissão...'
                            : 'Ativar localização',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Você pode ativar depois em Configurações.'),
                        ),
                      );
                    },
                    child: const Text('Agora não'),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OnbContent {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String>? bullets;
  final bool showPermissionCTA;

  const _OnbContent({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.bullets,
    this.showPermissionCTA = false,
  });
}

class _Dots extends StatelessWidget {
  const _Dots({
    required this.count,
    required this.index,
    required this.onTap,
  });

  final int count;
  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final active = Theme.of(context).colorScheme.primary;
    final inactive = Colors.grey.withOpacity(0.35);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == index;
        return InkWell(
          onTap: () => onTap(i),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            height: 8,
            width: isActive ? 22 : 8,
            decoration: BoxDecoration(
              color: isActive ? active : inactive,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        );
      }),
    );
  }
}
