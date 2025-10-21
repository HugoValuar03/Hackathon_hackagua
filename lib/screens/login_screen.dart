import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextFormField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Senha'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => Navigator.pushReplacementNamed(context, '/home'), child: const Text('Entrar')),
            TextButton(onPressed: () => Navigator.pushReplacementNamed(context, '/home'), child: const Text('Modo Convidado')),
          ],
        ),
      ),
    );
  }
}