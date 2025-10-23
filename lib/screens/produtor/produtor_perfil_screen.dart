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
      tipo = prefs.getString('user_tipo') ?? 'Produtor';
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil do Produtor',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: cs.primary,     // antes: Color(0xFF6CB40C)
        foregroundColor: cs.onPrimary,   // garante contraste
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ========================
            // TOPO DO PERFIL
            // ========================
            Stack(
              children: [
                Semantics(
                  label: 'Foto de perfil',
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: cs.secondaryContainer, // antes: 0xFFDDEED2
                    backgroundImage: (fotoPerfil != null)
                        ? AssetImage(fotoPerfil!)
                        : null,
                    child: fotoPerfil == null
                        ? Icon(
                      Icons.person,
                      size: 55,
                      color: cs.onSecondaryContainer, // antes: Colors.black45
                    )
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: Tooltip(
                    message: 'Alterar foto',
                    child: Material(
                      color: cs.primary, // antes: 0xFF2F4C30
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Alterar foto (em breve)')),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: cs.onPrimary, // antes: Colors.white
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              nome,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: cs.onSurface, // antes: Colors.black87
              ),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: TextStyle(
                fontSize: 15,
                color: cs.onSurfaceVariant, // antes: Colors.grey
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tipo,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: cs.primary, // antes: 0xFF2F4C30
              ),
            ),
            const SizedBox(height: 30),

            // ==============================================================
            // RESTANTE DA TELA ORIGINAL DO PERFIL (mantido)
            // ==============================================================
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informações Gerais',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: cs.primary, // antes: 0xFF2F4C30
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Gerencie suas informações de produtor, pontos acumulados e benefícios disponíveis.',
                      style: TextStyle(color: cs.onSurfaceVariant), // antes: Colors.black54
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Seção de pontos
            Card(
              color: cs.primary, // antes: 0xFF6CB40C
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  children: [
                    Text(
                      'Seus Pontos',
                      style: TextStyle(
                        fontSize: 18,
                        color: cs.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '1200 pts',
                      style: TextStyle(
                        fontSize: 26,
                        color: cs.onPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Troque por benefícios no marketplace!',
                      style: TextStyle(
                        color: cs.onPrimary.withOpacity(.8), // antes: Colors.white70
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Botões de ação
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/produtor/marketplace'),
                  icon: const Icon(Icons.shopping_bag),
                  label: const Text('Marketplace'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,   // antes: 0xFF2F4C30
                    foregroundColor: cs.onPrimary,
                    minimumSize: const Size(140, 44),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/produtor/beneficios'),
                  icon: const Icon(Icons.redeem_rounded),
                  label: const Text('Benefícios'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.secondary, // antes: 0xFF6CB40C
                    foregroundColor: cs.onSecondary,
                    minimumSize: const Size(140, 44),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Seção de histórico
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Histórico de Coletas',
                style: TextStyle(
                  fontSize: 18,
                  color: cs.primary, // antes: 0xFF2F4C30
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ListTile(
                  leading: Icon(Icons.recycling, color: cs.primary, size: 28),
                  title: const Text('Coleta nº 1043'),
                  subtitle: const Text('10 de Outubro de 2025'),
                  trailing: Text(
                    '+50 pts',
                    style: TextStyle(
                      color: cs.primary, // antes: 0xFF6CB40C
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.recycling, color: cs.primary, size: 28),
                  title: const Text('Coleta nº 1032'),
                  subtitle: const Text('28 de Setembro de 2025'),
                  trailing: Text(
                    '+80 pts',
                    style: TextStyle(
                      color: cs.primary, // antes: 0xFF6CB40C
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Botão de logout
            ElevatedButton.icon(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                if (!mounted) return;
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Sair'),
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.error,   // antes: Colors.redAccent.shade700
                foregroundColor: cs.onError,
                minimumSize: const Size(160, 48),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
