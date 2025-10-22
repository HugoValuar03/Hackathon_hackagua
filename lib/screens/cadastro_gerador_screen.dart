import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

import '../models.dart';

class CadastroGeradorScreen extends StatefulWidget {
  const CadastroGeradorScreen({super.key});

  @override
  State<CadastroGeradorScreen> createState() => _CadastroGeradorScreenState();
}

class _CadastroGeradorScreenState extends State<CadastroGeradorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _latController = TextEditingController();
  final _lonController = TextEditingController();
  String _tipo = 'restaurante';
  final List<Gerador> geradores = [];

  Future<void> _getLocation() async {
    final position = await Geolocator.getCurrentPosition();
    _latController.text = position.latitude.toString();
    _lonController.text = position.longitude.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Gerador')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
              ),
              DropdownButtonFormField<String>(
                value: _tipo,
                items: const [
                  DropdownMenuItem(
                    value: 'restaurante',
                    child: Text('Restaurante'),
                  ),
                  DropdownMenuItem(value: 'feira', child: Text('Feira')),
                  DropdownMenuItem(value: 'escola', child: Text('Escola')),
                  DropdownMenuItem(
                    value: 'condominio',
                    child: Text('Condomínio'),
                  ),
                ],
                onChanged: (v) => setState(() => _tipo = v!),
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(labelText: 'Endereço'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _latController,
                      decoration: const InputDecoration(labelText: 'Latitude'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _lonController,
                      decoration: const InputDecoration(labelText: 'Longitude'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.my_location),
                    onPressed: _getLocation,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final gerador = Gerador(
                      id: const Uuid().v4(),
                      nome: _nomeController.text.trim(),
                      tipo: _tipo,
                      endereco: _enderecoController.text.trim(),
                      latitude: double.parse(
                        _latController.text.replaceAll(',', '.'),
                      ),
                      longitude: double.parse(
                        _lonController.text.replaceAll(',', '.'),
                      ),
                    );

                    setState(() {
                      geradores.add(gerador);
                    });

                    // Mostra confirmação
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gerador cadastrado com sucesso!'),
                      ),
                    );

                    // Volta para a tela anterior
                    Navigator.pop(context);
                  }
                },
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _enderecoController.dispose();
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }
}
