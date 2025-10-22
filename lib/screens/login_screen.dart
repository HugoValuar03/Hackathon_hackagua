import 'package:flutter/material.dart';

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
                        Text(
                          'Entrar',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
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
                                // Se preferir, remova os autofillHints; às vezes dão warning no Web.
                                // autofillHints: const [AutofillHints.email],
                                validator: (v) {
                                  final s = v?.trim() ?? '';
                                  if (s.isEmpty || !s.contains('@')) {
                                    return 'Informe um e-mail válido';
                                  }
                                  return null; // válido
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
                                // autofillHints: const [AutofillHints.password],
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
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Não tem conta?',
                              style: const TextStyle(color: Color(0xFF000000)),
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

  void _onSubmit() {
    final ok = _formKey.currentState?.validate() ?? false; // evita null→bool
    if (!ok) return;

    // Aqui você faria o login real (try/catch). Para agora:
    Navigator.pushReplacementNamed(context, '/home');
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
          child: Container(
            width: 160,
            height: 6,
            decoration: BoxDecoration(
              color: color.primary.withOpacity(.12),
              borderRadius: BorderRadius.circular(999),
            ),
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
