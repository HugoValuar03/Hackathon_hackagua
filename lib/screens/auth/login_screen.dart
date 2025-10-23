import 'package:flutter/material.dart';
import 'package:hackathon_hackagua/database/db_helper.dart';
import 'package:hackathon_hackagua/database/user_dao.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const _TopBackdrop(),
            const _BottomAccent(),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        Image.asset('lib/assets/app_logo.png', width: 260),
                        const SizedBox(height: 8),
                        const Text(
                          'Realizar Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ================= FORM =================
                        Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _FieldLabel('Email'),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _email,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) {
                                  final s = v?.trim() ?? '';
                                  if (s.isEmpty || !s.contains('@')) {
                                    return 'Informe um e-mail válido';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Digite seu e-mail',
                                ),
                              ),

                              const SizedBox(height: 16),
                              const _FieldLabel('Senha'),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _password,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _onSubmit(),
                                obscureText: _obscure,
                                validator: (v) {
                                  final s = v ?? '';
                                  if (s.length < 6) {
                                    return 'A senha deve ter no mínimo 6 caracteres';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Digite sua senha',
                                  suffixIcon: IconButton(
                                    onPressed: () =>
                                        setState(() => _obscure = !_obscure),
                                    icon: Icon(
                                      _obscure
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),
                              FilledButton(
                                onPressed: _onSubmit,
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size.fromHeight(48),
                                  backgroundColor: const Color(0xFF2F4C30),
                                ),
                                child: const Text('Entrar'),
                              ),

                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                  context,
                                  '/produtor/marketplace',
                                ),
                                child: Text(
                                  'Modo convidado',
                                  style: TextStyle(color: color.primary),
                                ),
                              ),

                              // Botão opcional de debug
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () async {
                                  final db = await DBHelper.database;
                                  final result = await db.query('usuarios');

                                  if (result.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Nenhum usuário cadastrado.'),
                                      ),
                                    );
                                  } else {
                                    debugPrint('📋 Usuários encontrados:');
                                    for (var row in result) {
                                      debugPrint(
                                          '🧍 ${row['nome']} | ${row['email']} | ${row['tipo']}');
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            '${result.length} usuários listados no console.'),
                                      ),
                                    );
                                  }
                                },
                                child: const Text('🔍 Testar Banco (Listar Usuários)'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Não tem conta?',
                              style: TextStyle(color: Color(0xFF000000)),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushReplacementNamed(
                                context,
                                '/cadastro',
                              ),
                              child: const Text('Cadastre-se'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // LOGIN REAL
  // ===============================================================
  Future<void> _onSubmit() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    final email = _email.text.trim();
    final senha = _password.text.trim();
    final messenger = ScaffoldMessenger.of(context);

    try {
      final usuario = await UsuarioDao.buscarPorEmailESenha(email, senha);

      if (usuario != null) {
        // ✅ Mensagem de sucesso
        messenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 10),
                Text('Bem-vindo, ${usuario.nome}!'),
              ],
            ),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 800));

        // 🔀 Redireciona conforme o tipo de usuário
        if (usuario.tipo == 'Produtor') {
          Navigator.pushReplacementNamed(context, '/produtor/marketplace');
        } else if (usuario.tipo == 'Coletor') {
          Navigator.pushReplacementNamed(context, '/coletor/marketplace');
        } else {
          messenger.showSnackBar(
            SnackBar(
              content: Row(
                children: const [
                  Icon(Icons.warning_amber_rounded, color: Colors.white),
                  SizedBox(width: 10),
                  Text('Tipo de usuário desconhecido.'),
                ],
              ),
              backgroundColor: Colors.orange.shade700,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        // ❌ E-mail ou senha incorretos
        messenger.showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 10),
                Text('E-mail ou senha incorretos.'),
              ],
            ),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 10),
              Text('Erro ao fazer login: $e'),
            ],
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

// ===============================================================
// VISUAIS
// ===============================================================

class _BottomAccent extends StatelessWidget {
  const _BottomAccent();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: IgnorePointer(
        ignoring: true,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 16,
          ),
        ),
      ),
    );
  }
}

class _TopBackdrop extends StatelessWidget {
  const _TopBackdrop();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: IgnorePointer(
        ignoring: true,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.38,
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(.65),
          fontWeight: FontWeight.w700,
          letterSpacing: .2,
        ),
      ),
    );
  }
}
