import 'package:flutter/material.dart';
import 'package:hackathon_hackagua/database/user_dao.dart';
import 'package:hackathon_hackagua/database/db_helper.dart';

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
                        Image.asset('lib/assets/app_logo.png', width: 300),
                        const SizedBox(height: 8),
                        const Text(
                          'Entrar',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // FORM
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
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                  context,
                                  '/marketplace',
                                ),
                                child: Text(
                                  'Modo convidado',
                                  style: TextStyle(color: color.primary),
                                ),
                              ),
                              // 🧪 BOTÃO TEMPORÁRIO DE TESTE DO BANCO
                              ElevatedButton(
                                onPressed: () async {
                                  final db = await DBHelper.database;
                                  final result = await db.query('usuarios');

                                  if (result.isEmpty) {
                                    debugPrint('Nenhum usuário encontrado no banco.');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Nenhum usuário cadastrado.')),
                                    );
                                  } else {
                                    for (var row in result) {
                                      debugPrint('🧍 Usuário: ${row['nome']} | Email: ${row['email']} | Tipo: ${row['tipo']}');
                                    }

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${result.length} usuários encontrados (veja no console).')),
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

  // 🆕 Função atualizada para login real com SQLite
  Future<void> _onSubmit() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    final email = _email.text.trim();
    final senha = _password.text.trim();

    try {
      final usuario = await UsuarioDao.buscarPorEmailESenha(email, senha);

      if (usuario != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bem-vindo, ${usuario.nome}!')),
        );

        // Redireciona para a tela principal (marketplace)
        Navigator.pushReplacementNamed(context, '/marketplace');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('E-mail ou senha incorretos.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login: $e')),
      );
    }
  }
}

class _BottomAccent extends StatelessWidget {
  const _BottomAccent();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
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
    final color = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.topCenter,
      child: IgnorePointer(
        ignoring: true,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.38,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [color.primary.withOpacity(.10), Colors.transparent],
            ),
          ),
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
