import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColetorPerfilScreen extends StatefulWidget {
  const ColetorPerfilScreen({super.key});

  @override
  State<ColetorPerfilScreen> createState() => _ColetorPerfilScreenState();
}

class _ColetorPerfilScreenState extends State<ColetorPerfilScreen> {
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
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil do Produtor',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF6CB40C),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: const Color(0xFFDDEED2),
                  backgroundImage: (fotoPerfil != null)
                      ? AssetImage(fotoPerfil!)
                      : null,
                  child: fotoPerfil == null
                      ? const Icon(
                          Icons.person,
                          size: 55,
                          color: Colors.black45,
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF2F4C30),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              nome,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              tipo,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2F4C30),
              ),
            ),
            const SizedBox(height: 30),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Informações Gerais',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F4C30),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Gerencie suas informações de produtor, pontos acumulados e benefícios disponíveis.',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Exemplo de seção de pontos
            Card(
              color: const Color(0xFF6CB40C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  children: const [
                    Text(
                      'Seus Pontos',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '1200 pts',
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Troque por benefícios no marketplace!',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
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
                    backgroundColor: const Color(0xFF2F4C30),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(140, 44),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/produtor/beneficios'),
                  icon: const Icon(Icons.redeem_rounded),
                  label: const Text('Benefícios'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6CB40C),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(140, 44),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Exemplo de seção de histórico
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Histórico de Coletas',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF2F4C30),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                ListTile(
                  leading: Icon(
                    Icons.recycling,
                    color: Color(0xFF2F4C30),
                    size: 28,
                  ),
                  title: Text('Coleta nº 1043'),
                  subtitle: Text('10 de Outubro de 2025'),
                  trailing: Text(
                    '+50 pts',
                    style: TextStyle(
                      color: Color(0xFF6CB40C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.recycling,
                    color: Color(0xFF2F4C30),
                    size: 28,
                  ),
                  title: Text('Coleta nº 1032'),
                  subtitle: Text('28 de Setembro de 2025'),
                  trailing: Text(
                    '+80 pts',
                    style: TextStyle(
                      color: Color(0xFF6CB40C),
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
                backgroundColor: Colors.redAccent.shade700,
                foregroundColor: Colors.white,
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
