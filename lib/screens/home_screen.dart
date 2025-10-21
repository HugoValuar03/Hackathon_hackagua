import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LatLng? _userLocation;
  Map<String, dynamic>? _selectedItem;

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
                  ...AppState.geradores.map((g) => Marker(
                    point: LatLng(g.latitude, g.longitude),
                    builder: (ctx) => const Icon(Icons.location_on, color: Colors.green),
                    onTap: () => setState(() => _selectedItem = {'type': 'gerador', 'data': g}),
                  )),
                  ...AppState.coletores.map((c) => Marker(
                    point: LatLng(c.latitude, c.longitude),
                    builder: (ctx) => const Icon(Icons.location_on, color: Colors.blue),
                    onTap: () => setState(() => _selectedItem = {'type': 'coletor', 'data': c}),
                  )),
                ],
              ),
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