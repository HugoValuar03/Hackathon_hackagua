// screens/produtor/produtor_marketplace_screen.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../main.dart';
import '../../models.dart';
import '../../widgets/scaffold_with_nav.dart';

/// Mapeamento fixo: categoria -> imagem do assets/
const kAssetPorCategoria = <String, String>{
  'composto': 'assets/substrato.jpeg',
  'sementes': 'assets/images.jpeg',
  'credito':  'assets/biogas.jpg',
};
const kAssetDefault = 'assets/biogas.jpg';

class ProdutorMarketplaceScreen extends StatefulWidget {
  const ProdutorMarketplaceScreen({super.key});

  @override
  State<ProdutorMarketplaceScreen> createState() =>
      _ProdutorMarketplaceScreenState();
}

class _ProdutorMarketplaceScreenState extends State<ProdutorMarketplaceScreen> {
  static const _tabIndex = 0;
  String _filtroCategoria = 'todos';

  // ---------- Preço em R$ + faixas de desconto ----------
  // Regras:
  // 30–64,99  => 35%
  // 65–90     => 40%
  // >90       => 45%
  // <30       => 0%
  double _discountRateForPrice(double priceBRL) {
    if (priceBRL >= 30 && priceBRL < 65) return 0.35;
    if (priceBRL >= 65 && priceBRL <= 90) return 0.40;
    if (priceBRL > 90) return 0.45;
    return 0.0;
  }

  String _formatBRL(num v) {
    final s = v.toStringAsFixed(2);
    return 'R\$ ${s.replaceAll('.', ',')}';
  }

  /// Retorna o caminho do asset para o produto (por categoria)
  String _assetPara(Produto p) {
    return kAssetPorCategoria[p.categoria] ?? kAssetDefault;
  }

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
      role: UserRole.produtor,
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
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: 'todos', child: Text('Todas as Categorias')),
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

                // Usaremos "precoPontos" como valor em R$ agora.
                final double precoBase = produto.precoPontos.toDouble();
                final double rate = _discountRateForPrice(precoBase);
                final double precoFinal = precoBase * (1 - rate);

                return _ProdutoOlxCard(
                  produto: produto,
                  descontoPercent: rate,
                  precoBaseReais: precoBase,
                  precoFinalReais: precoFinal,
                  imagemAsset: _assetPara(produto), // sempre asset
                  onComprar: () => _comprarProduto(produto, precoFinal),
                  formatBRL: _formatBRL,
                );
              },
            ),
          ),
        ],
      ),

      // Botão flutuante: novo post
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

  // Agora é só informativo (não mexe em pontos), preço em R$
  void _comprarProduto(Produto produto, double precoFinal) {
    final precoFmt = _formatBRL(precoFinal);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Compra iniciada: ${produto.nome} por $precoFmt')),
    );
  }
}

/// Card estilo OLX (carrega SEMPRE imagem de assets, preço em R$)
class _ProdutoOlxCard extends StatelessWidget {
  const _ProdutoOlxCard({
    required this.produto,
    required this.descontoPercent,
    required this.precoBaseReais,
    required this.precoFinalReais,
    required this.imagemAsset,
    required this.formatBRL,
    this.onTap,
    this.onComprar,
  });

  final Produto produto;
  final double descontoPercent;   // 0.0, 0.35, 0.40, 0.45
  final double precoBaseReais;
  final double precoFinalReais;
  final String imagemAsset;       // caminho em assets/
  final String Function(num) formatBRL;
  final VoidCallback? onTap;
  final VoidCallback? onComprar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final temDesconto = descontoPercent > 0;
    final descontoLabel = '-${(descontoPercent * 100).toInt()}%';

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
            // IMAGEM DO ASSET
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                (imagemAsset.trim().isEmpty) ? kAssetDefault : imagemAsset,
                height: 180,
                width: double.infinity,
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
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),

            // Preço com/sem desconto (em R$)
            if (temDesconto) ...[
              Row(
                children: [
                  Text(
                    formatBRL(precoBaseReais),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formatBRL(precoFinalReais),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(descontoLabel),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    side: BorderSide.none,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                  ),
                ],
              ),
            ] else ...[
              Text(
                formatBRL(precoBaseReais),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],

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
                child: Text(
                  temDesconto
                      ? 'Comprar por ${formatBRL(precoFinalReais)}'
                      : 'Comprar',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== Bottom sheet de "Novo post" (mantido; preview opcional) =====
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

          OutlinedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.image),
            label: Text(_imageName == null ? 'Selecionar imagem (preview opcional)' : 'Trocar imagem'),
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
                  ? const Text('Preview da imagem', style: TextStyle(color: Colors.black54))
                  : Image.memory(_imageBytes!, height: previewHeight, width: double.infinity, fit: BoxFit.cover),
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
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Preço (R\$)',
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
