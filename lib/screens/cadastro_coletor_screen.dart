// cadastro_coletor_screen.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
// Se você instalou geolocator, descomente a linha abaixo e o botão "Usar minha localização"
// import 'package:geolocator/geolocator.dart';

class CadastroColetorScreen extends StatefulWidget {
  const CadastroColetorScreen({super.key});

  @override
  State<CadastroColetorScreen> createState() => _CadastroColetorScreenState();
}

class _CadastroColetorScreenState extends State<CadastroColetorScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeCtrl = TextEditingController();
  final _enderecoCtrl = TextEditingController();
  final _latCtrl = TextEditingController();
  final _lonCtrl = TextEditingController();
  final _foneCtrl = TextEditingController();

  String _tipo = 'cooperativa';
  final _uuid = const Uuid();

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _enderecoCtrl.dispose();
    _latCtrl.dispose();
    _lonCtrl.dispose();
    _foneCtrl.dispose();
    super.dispose();
  }

  double? _parseDouble(String s) {
    if (s.trim().isEmpty) return null;
    return double.tryParse(s.replaceAll(',', '.'));
  }

  Future<void> _usarMinhaLocalizacao() async {
    // === Se NÃO for usar geolocator, remova este método e o botão que o chama. ===
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Serviço de localização desativado.')),
        );
        return;
      }
      LocationPermission p = await Geolocator.checkPermission();
      if (p == LocationPermission.denied) {
        p = await Geolocator.requestPermission();
      }
      if (p == LocationPermission.denied || p == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permissão negada.')),
        );
        return;
      }
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _latCtrl.text = pos.latitude.toStringAsFixed(6);
      _lonCtrl.text = pos.longitude.toStringAsFixed(6);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao obter localização: $e')));
    }
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final lat = _parseDouble(_latCtrl.text);
    final lon = _parseDouble(_lonCtrl.text);

    final novo = <String, dynamic>{
      'id': _uuid.v4(),
      'nome': _nomeCtrl.text.trim(),
      'tipo': _tipo, // 'cooperativa' | 'fazenda' | 'startup'
      'endereco': _enderecoCtrl.text.trim(),
      'telefone': _foneCtrl.text.trim().isEmpty ? null : _foneCtrl.text.trim(),
      'latitude': lat,
      'longitude': lon,
      'created_at': DateTime.now().toIso8601String(),
    };

    Navigator.of(context).pop(novo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Coletor / Compostador'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nomeCtrl,
              decoration: const InputDecoration(labelText: 'Nome'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Informe o nome' : null,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _tipo,
              items: const [
                DropdownMenuItem(value: 'cooperativa', child: Text('Cooperativa')),
                DropdownMenuItem(value: 'fazenda', child: Text('Fazenda Urbana')),
                DropdownMenuItem(value: 'startup', child: Text('Startup Verde')),
              ],
              onChanged: (v) => setState(() => _tipo = v ?? 'cooperativa'),
              decoration: const InputDecoration(labelText: 'Tipo'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _enderecoCtrl,
              decoration: const InputDecoration(labelText: 'Endereço'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _latCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    decoration: const InputDecoration(labelText: 'Latitude (ex.: -7.123456)'),
                    validator: (v) {
                      final d = _parseDouble(v ?? '');
                      if (d == null || d.isNaN || d < -90 || d > 90) return 'Latitude inválida';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _lonCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    decoration: const InputDecoration(labelText: 'Longitude (ex.: -35.123456)'),
                    validator: (v) {
                      final d = _parseDouble(v ?? '');
                      if (d == null || d.isNaN || d < -180 || d > 180) return 'Longitude inválida';
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _foneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Telefone (opcional)'),
            ),
            const SizedBox(height: 12),

            // Se usar geolocator, reative o botão abaixo
            // OutlinedButton.icon(
            //   icon: const Icon(Icons.my_location),
            //   label: const Text('Usar minha localização'),
            //   onPressed: _usarMinhaLocalizacao,
            // ),

            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Salvar'),
                onPressed: _salvar,
              ),
            )
          ],
        ),
      ),
    );
  }
}
