import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hackathon_hackagua/database/user_dao.dart';

class ColetorPerfilScreen extends StatefulWidget {
  const ColetorPerfilScreen({super.key});

  @override
  State<ColetorPerfilScreen> createState() => _ColetorPerfilScreenState();
}

class _ColetorPerfilScreenState extends State<ColetorPerfilScreen> {
  String nome = "Nome do Usuário";
  String email = "email@exemplo.com";

  @override
  void initState() {
    super.initState();
    _carregarUsuarioLogado();
  }

  Future<void> _carregarUsuarioLogado() async {
    final prefs = await SharedPreferences.getInstance();
    final emailSalvo = prefs.getString('usuario_email');

    if (emailSalvo != null) {
      final usuario = await UsuarioDao.buscarPorEmail(emailSalvo);
      if (usuario != null) {
        setState(() {
          nome = usuario.nome;
          email = usuario.email;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              const Text(
                "Perfil Coletor",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),

              // 🧑‍🔧 Foto de perfil com botão embutido
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 42,
                    backgroundColor: Color(0xFFA8E6CF),
                    child: Icon(Icons.person, size: 46, color: Colors.black87),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 2,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF2F4C30),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                nome,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                email,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 22),

              // 🏅 Pontos e métricas
              Card(
                color: const Color(0xFFF2F7F3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Pontos disponíveis: 0",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Ver selos"),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Estatísticas básicas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _MetricCard(label: "Água (L)", value: "12.5"),
                  _MetricCard(label: "CO₂ (kg)", value: "3.1"),
                  _MetricCard(label: "Chorume (L)", value: "5.0"),
                ],
              ),

              const SizedBox(height: 22),

              // Botões de ações principais
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  _ActionButton(
                    icon: Icons.local_shipping_outlined,
                    label: "Solicitar coleta",
                    onPressed: () {},
                  ),
                  _ActionButton(
                    icon: Icons.history,
                    label: "Minhas coletas",
                    onPressed: () {},
                  ),
                  _ActionButton(
                    icon: Icons.map_outlined,
                    label: "Endereço / Área",
                    onPressed: () {},
                  ),
                  _ActionButton(
                    icon: Icons.edit_outlined,
                    label: "Editar dados",
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 26),

              // Notificações e localização
              SwitchListTile(
                title: const Text("Notificações"),
                subtitle: const Text(
                  "Receber atualizações das coletas e marketplace",
                ),
                value: true,
                onChanged: (_) {},
              ),
              SwitchListTile(
                title: const Text("Usar minha localização"),
                subtitle: const Text("Sugerir parceiros próximos"),
                value: true,
                onChanged: (_) {},
              ),

              const SizedBox(height: 16),

              // Botão de sair
              OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                  side: const BorderSide(color: Colors.black54),
                ),
                child: const Text("Sair"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;

  const _MetricCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF2F7F3),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}