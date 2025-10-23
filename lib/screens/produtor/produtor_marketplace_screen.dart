import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models.dart';
import '../../widgets/scaffold_with_nav.dart';

class ProdutorMarketplaceScreen extends StatefulWidget {
  const ProdutorMarketplaceScreen({super.key});

  @override
  State<ProdutorMarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<ProdutorMarketplaceScreen> {
  static const _tabIndex = 0;
  String _filtroCategoria = 'todos';

  @override
  Widget build(BuildContext context) {
    final produtosFiltrados = _filtroCategoria == 'todos'
        ? AppState.produtos
        : AppState.produtos
              .where((p) => p.categoria == _filtroCategoria)
              .toList();

    return ScaffoldWithNav(
      title: 'Marketplace Verde',
      currentIndex: _tabIndex,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: DropdownButtonFormField<String>(
              value: _filtroCategoria,
              decoration: const InputDecoration(
                labelText: 'Filtrar por categoria',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
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
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: produtosFiltrados.length,
              itemBuilder: (context, index) {
                final produto = produtosFiltrados[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: Image.asset(
                      produto.imagemUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image),
                    ),
                    title: Text(produto.nome),
                    subtitle: Text(
                      '${produto.descricao}\nPreço: ${produto.precoPontos} pontos',
                    ),
                    isThreeLine: true,
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
