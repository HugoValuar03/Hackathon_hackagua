import 'package:flutter/material.dart';
import '../main.dart';
import '../models.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String _filtroCategoria = 'todos';

  @override
  Widget build(BuildContext context) {
    final produtosFiltrados = _filtroCategoria == 'todos'
        ? AppState.produtos
        : AppState.produtos
              .where((p) => p.categoria == _filtroCategoria)
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace Verde'),
        actions: [
          Text(
            'Pontos: ${AppState.pontos}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/beneficios');
            },
            child: Text('Benefícios'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _filtroCategoria,
              items: const [
                DropdownMenuItem(
                  value: 'todos',
                  child: Text('Todas as Categorias'),
                ),
                DropdownMenuItem(value: 'composto', child: Text('Composto')),
                DropdownMenuItem(value: 'sementes', child: Text('Sementes')),
                DropdownMenuItem(value: 'credito', child: Text('Créditos')),
              ],
              onChanged: (v) => setState(() => _filtroCategoria = v!),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: produtosFiltrados.length,
              itemBuilder: (context, index) {
                final produto = produtosFiltrados[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.asset(
                      produto.imagemUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(produto.nome),
                    subtitle: Text(
                      '${produto.descricao}\nPreço: ${produto.precoPontos} pontos',
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => _comprarProduto(produto),
                      child: const Text('Comprar'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _comprarProduto(Produto produto) {
    if (AppState.pontos >= produto.precoPontos) {
      setState(() => AppState.pontos -= produto.precoPontos.toInt());
      AppState.saveData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Compra realizada: ${produto.nome}!')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pontos insuficientes!')));
    }
  }
}
