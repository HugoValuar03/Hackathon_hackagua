// screens/coletor/coletor_marketplace_screen.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../main.dart';
import '../../models.dart';
import '../../widgets/scaffold_with_nav.dart';

class ColetorMarketplaceScreen extends StatefulWidget {
  const ColetorMarketplaceScreen({super.key});

  @override
  State<ColetorMarketplaceScreen> createState() =>
      _ColetorMarketplaceScreenState();
}

class _ColetorMarketplaceScreenState extends State<ColetorMarketplaceScreen> {
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
      role: UserRole.coletor,
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
                contentPadding:
                EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(
                    value: 'todos', child: Text('Todas as Categorias')),
                DropdownMenuItem(value: 'composto', child: Text('Composto')),
                DropdownMenuItem(value: 'sementes', child: Text('Sementes')),
                DropdownMenuItem(value: 'credito', child: Text('Créditos')),
              ],
              onChanged: (v) => setState(() => _filtroCategoria = v!),
            ),
          ),
          const SizedBox(height: 8),

          // Lista estilo OLX
          Expanded(
            child: ListView.builder(
              itemCount: produtosFiltrados.length,
              itemBuilder: (context, index) {
                final produto = produtosFiltrados[index];
                return _ProdutoOlxCard(
                  produto: produto,
                  onComprar: () => _comprarProduto(produto),
                );
              },
            ),
          ),
        ],
      ),

      // Botão flutuante: cria novo post
      floatingActionButton: FloatingActionButton(
        onPressed: _novoPost,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _novoPost() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: SafeArea(
                top: false,
                child: _NovoPostSheet(scrollController: scrollController),
              ),
            );
          },
        );
      },
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pontos insuficientes!')),
      );
    }
  }
}

/// Card estilo OLX: foto grande, título, preço e descrição breve
class _ProdutoOlxCard extends StatelessWidget {
  const _ProdutoOlxCard({
    required this.produto,
    this.onTap,
    this.onComprar,
  });

  final Produto produto;
  final VoidCallback? onTap;
  final VoidCallback? onComprar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final precoText = '${produto.precoPontos} pontos';

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              offset: const Offset(0, 2),
              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto grande
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                produto.imagemUrl,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 180,
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              produto.nome,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              precoText,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              produto.descricao,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: onComprar,
                child: const Text('Comprar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet simples de "Novo post" com Título, Preço, Descrição e Imagem
class _NovoPostSheet extends StatefulWidget {
  const _NovoPostSheet({this.scrollController});
  final ScrollController? scrollController;

  @override
  State<_NovoPostSheet> createState() => _NovoPostSheetState();
}

class _NovoPostSheetState extends State<_NovoPostSheet> {
  final _tituloCtrl = TextEditingController();
  final _precoCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _picker = ImagePicker();

  Uint8List? _imageBytes;
  String? _imageName;

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _precoCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final x = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (x == null) return;
    final bytes = await x.readAsBytes();
    setState(() {
      _imageBytes = bytes;
      _imageName = x.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Compensa o teclado e elimina overflow
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final previewHeight = bottomInset > 0 ? 120.0 : 180.0;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: ListView(
        controller: widget.scrollController,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const Text(
            'Novo post',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          // Imagem + preview
          OutlinedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.image),
            label: Text(
              _imageName == null ? 'Selecionar imagem' : 'Trocar imagem',
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              height: previewHeight,
              color: Colors.grey.shade100,
              alignment: Alignment.center,
              child: _imageBytes == null
                  ? const Text(
                'Preview da imagem',
                style: TextStyle(color: Colors.black54),
              )
                  : Image.memory(
                _imageBytes!,
                height: previewHeight,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 12),
          TextField(
            controller: _tituloCtrl,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Título',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _precoCtrl,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Preço (em pontos)',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _descCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Descrição breve',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                // TODO: validar e salvar (AppState/DB/Storage)
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post criado!')),
                );
              },
              child: const Text('Publicar'),
            ),
          ),
        ],
      ),
    );
  }
}