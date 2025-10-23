import 'package:flutter/material.dart';
import 'package:hackathon_hackagua/database/user_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        child: Center(
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
                              '/produtor/marketplace',
                            ),
                            child: Text(
                              'Modo convidado',
                              style: TextStyle(color: color.primary),
                            ),
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
      ),
    );
  }

  Future<void> _onSubmit() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    final email = _email.text.trim();
    final senha = _password.text.trim();

    try {
      final usuario = await UsuarioDao.buscarPorEmailESenha(email, senha);

      if (usuario != null) {
        // Salva o usuário logado localmente
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', usuario.id ?? 0);
        await prefs.setString('user_nome', usuario.nome);
        await prefs.setString('user_email', usuario.email);
        await prefs.setString('user_tipo', usuario.tipo);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bem-vindo, ${usuario.nome}!')),
        );

        if (usuario.tipo == 'Produtor') {
          Navigator.pushReplacementNamed(context, '/produtor/perfil');
        } else if (usuario.tipo == 'Coletor') {
          Navigator.pushReplacementNamed(context, '/coletor/perfil');
        }
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
