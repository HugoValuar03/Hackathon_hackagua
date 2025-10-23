// screens/maps_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../widgets/scaffold_with_nav.dart'; // tem o ScaffoldWithNav e o enum UserRole

class MapsScreen extends StatefulWidget {
  const MapsScreen({
    super.key,
    this.role = UserRole.coletor, // ou UserRole.produtor
  });

  final UserRole role;

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  GoogleMapController? _controller;
  LatLng _initialPos = const LatLng(-10.1847, -48.3336); // Palmas-TO fallback
  bool _loading = true;

  // Detecta plataformas sem suporte ao GoogleMap (web/desktop)
  bool get _isUnsupportedPlatform {
    final p = defaultTargetPlatform;
    if (kIsWeb) return true;
    return p == TargetPlatform.windows ||
        p == TargetPlatform.linux ||
        p == TargetPlatform.macOS;
  }

  // Mock de parceiros
  final _parceiros = const [
    _Parceiro(
      id: 'r1',
      nome: 'Restaurante Verde Vida',
      bairro: 'Centro',
      endereco: 'Av. Principal, 123',
      pontosPorDoacao: 20,
      pos: LatLng(-10.1847, -48.3336),
    ),
    _Parceiro(
      id: 'r2',
      nome: 'Bistrô Sustentável',
      bairro: 'Jardins',
      endereco: 'Rua das Flores, 45',
      pontosPorDoacao: 15,
      pos: LatLng(-10.1860, -48.3305),
    ),
    _Parceiro(
      id: 'r3',
      nome: 'Cantina Orgânica',
      bairro: 'Norte',
      endereco: 'Alameda 7, QI 03',
      pontosPorDoacao: 25,
      pos: LatLng(-10.1832, -48.3369),
    ),
  ];

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  Future<void> _prepare() async {
    if (_isUnsupportedPlatform) {
      setState(() => _loading = false);
      return;
    }

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _loading = false);
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => _loading = false);
        return;
      }

      final pos = await Geolocator.getCurrentPosition();

      // Marcadores (parceiros + você)
      final partnerMarkers = _parceiros
          .map(
            (p) => Marker(
          markerId: MarkerId(p.id),
          position: p.pos,
          infoWindow: InfoWindow(
            title: p.nome,
            snippet: '${p.bairro} • até ${p.pontosPorDoacao} pts',
          ),
        ),
      )
          .toSet();

      setState(() {
        _initialPos = LatLng(pos.latitude, pos.longitude);
        _loading = false;
        _markers = {
          ...partnerMarkers,
          Marker(
            markerId: const MarkerId('minha_posicao'),
            position: _initialPos,
            infoWindow: const InfoWindow(title: 'Minha posição'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
          ),
        };
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapSection = _loading
        ? const SizedBox(
      height: 280,
      child: Center(child: CircularProgressIndicator()),
    )
        : _isUnsupportedPlatform
        ? const _MapaPlaceholder(height: 280)
        : SizedBox(
      height: 280, // mapa menor
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPos,
          zoom: 14,
        ),
        onMapCreated: (c) => _controller = c,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        markers: _markers,
      ),
    );

    return ScaffoldWithNav(
      title: 'Mapa de Parceiros',
      currentIndex: 1, // índice da aba "Mapa" na bottom nav
      role: widget.role,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          mapSection,
          const SizedBox(height: 12),

          // Filtros (placeholder)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: const Text('Restaurantes'),
                selected: true,
                onSelected: (_) {},
              ),
              FilterChip(
                label: const Text('Escolas'),
                selected: false,
                onSelected: (_) {},
              ),
              FilterChip(
                label: const Text('Condomínios'),
                selected: false,
                onSelected: (_) {},
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Lista de parceiros
          ..._parceiros.map(
                (p) => _ParceiroCard(
              parceiro: p,
              onVerNoMapa: _isUnsupportedPlatform
                  ? null
                  : () => _goTo(p.pos, title: p.nome),
              onSolicitarColeta: () {
                // TODO: integrar fluxo real
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Solicitação enviada para ${p.nome}')),
                );
              },
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: _isUnsupportedPlatform
          ? null
          : FloatingActionButton(
        tooltip: 'Centralizar em mim',
        onPressed: () => _controller?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _initialPos, zoom: 15),
          ),
        ),
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Future<void> _goTo(LatLng target, {String? title}) async {
    await _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 16),
      ),
    );
    if (title != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Centralizado em: $title')),
      );
    }
  }
}

/* ======= Widgets auxiliares ======= */

class _MapaPlaceholder extends StatelessWidget {
  const _MapaPlaceholder({this.height = 240});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Center(
        child: Text(
          'Mapa do Google (não suportado nesta plataforma)\n'
              'Use Android/iOS para ver o mapa real.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}

class _Parceiro {
  final String id;
  final String nome;
  final String bairro;
  final String endereco;
  final int pontosPorDoacao;
  final LatLng pos;

  const _Parceiro({
    required this.id,
    required this.nome,
    required this.bairro,
    required this.endereco,
    required this.pontosPorDoacao,
    required this.pos,
  });
}

class _ParceiroCard extends StatelessWidget {
  const _ParceiroCard({
    required this.parceiro,
    this.onVerNoMapa,
    this.onSolicitarColeta,
  });

  final _Parceiro parceiro;
  final VoidCallback? onVerNoMapa;
  final VoidCallback? onSolicitarColeta;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 72,
                height: 72,
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: const Icon(Icons.restaurant, size: 32, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),

            // Infos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título com quebra/reticências para evitar estouro
                  Text(
                    parceiro.nome,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  // Endereço idem
                  Text(
                    '${parceiro.bairro} • ${parceiro.endereco}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodyMedium?.copyWith(color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.stars, size: 18),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Até ${parceiro.pontosPorDoacao} pts por doação',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // >>> CORREÇÃO DO OVERFLOW: usar Wrap em vez de Row
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: onVerNoMapa,
                        icon: const Icon(Icons.map),
                        label: const Text('Ver no mapa'),
                      ),
                      FilledButton.icon(
                        onPressed: onSolicitarColeta,
                        icon: const Icon(Icons.local_shipping),
                        label: const Text('Solicitar coleta'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
