import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LatLng? _userLocation;
  Map<String, dynamic>? _selectedItem;
  final List<Map<String, dynamic>> geradores = [];
  final List<Map<String, dynamic>> coletores = [];
  String selectedGerador = '';

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    final position = await Geolocator.getCurrentPosition();
    setState(() => _userLocation = LatLng(position.latitude, position.longitude));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: _userLocation ?? const LatLng(-7.1245, -35.1240),
              zoom: 14.0,
            ),
            children: [
              TileLayer(urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'),
              MarkerLayer(
                markers: [
                  ...geradores.map((g) => Marker(
                    point: LatLng(
                      (g['latitude'] as num).toDouble(),
                      (g['longitude'] as num).toDouble(),
                    ),
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () => setState(() => selectedGerador = g['id'] as String),
                      child: const Icon(Icons.location_on, color: Colors.green),
                    ),
                  )),

                  ...coletores.map((c) => Marker(
                    point: LatLng(
                      (c['latitude'] as num).toDouble(),
                      (c['longitude'] as num).toDouble(),
                    ),
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () {
                        // ação que quiser ao tocar no coletor
                      },
                      child: const Icon(Icons.location_on, color: Colors.blue),
                    ),
                  )),
                ],
              )

            ],
          ),
          if (_selectedItem != null) _buildBottomSheet(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMenu(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBottomSheet() {
    final item = _selectedItem!;
    final data = item['data'];
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(data.nome, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(data.tipo),
            Text(data.endereco),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/solicitar'), child: const Text('Solicitar Coleta')),
          ],
        ),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: const Text('Cadastrar Gerador'), onTap: () => Navigator.pushNamed(context, '/cadastro/gerador')),
          ListTile(title: const Text('Cadastrar Coletor'), onTap: () => Navigator.pushNamed(context, '/cadastro/coletor')),
          ListTile(title: const Text('Solicitar Coleta'), onTap: () => Navigator.pushNamed(context, '/solicitar')),
        ],
      ),
    );
  }
}