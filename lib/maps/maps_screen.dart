import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  GoogleMapController? _controller;
  LatLng _initialPos = const LatLng(-10.1847, -48.3336); // Palmas-TO fallback
  bool _loading = true;
  Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('ponto_demo'),
      position: LatLng(-10.1847, -48.3336),
      infoWindow: InfoWindow(title: 'Ponto Demo', snippet: 'MVP sem API'),
    ),
  };

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  Future<void> _prepare() async {
    // No Desktop/Web, google_maps_flutter não é suportado (especialmente Windows).
    // Mostra uma mensagem amigável.
    if (kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      setState(() {
        _loading = false;
      });
      return;
    }

    // Mobile: pedir permissão e pegar localização
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _loading = false);
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => _loading = false);
        return;
      }

      final pos = await Geolocator.getCurrentPosition();
      setState(() {
        _initialPos = LatLng(pos.latitude, pos.longitude);
        _loading = false;
        _markers = {
          ..._markers,
          Marker(
            markerId: const MarkerId('minha_posicao'),
            position: _initialPos,
            infoWindow: const InfoWindow(title: 'Minha posição'),
          ),
        };
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final unsupportedDesktop =
        kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS;

    return Scaffold(
      appBar: AppBar(title: const Text('Mapa')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : unsupportedDesktop
          ? const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Este MVP usa Google Maps (plugin oficial), '
                'que não suporta Windows/Web. Rode em um emulador Android '
                'ou dispositivo físico.',
            textAlign: TextAlign.center,
          ),
        ),
      )
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPos,
          zoom: 14,
        ),
        onMapCreated: (c) => _controller = c,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        markers: _markers,
      ),
      floatingActionButton: unsupportedDesktop
          ? null
          : FloatingActionButton(
        tooltip: 'Centralizar em mim',
        onPressed: () {
          _controller?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: _initialPos, zoom: 15),
            ),
          );
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
