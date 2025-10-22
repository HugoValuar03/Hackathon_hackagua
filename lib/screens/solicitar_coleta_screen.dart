import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SolicitarColetaScreen extends StatefulWidget {
  const SolicitarColetaScreen({
    super.key,
    required this.geradores,
    required this.coletores,
  });

  final List<Map<String, dynamic>> geradores;
  final List<Map<String, dynamic>> coletores;

  @override
  State<SolicitarColetaScreen> createState() => _SolicitarColetaScreenState();
}

class _SolicitarColetaScreenState extends State<SolicitarColetaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  String? _geradorId;
  final _kgCtrl = TextEditingController(text: '10');
  DateTime? _preferredDate;

  Map<String, dynamic>? _matchPreview;

  @override
  void dispose() {
    _kgCtrl.dispose();
    super.dispose();
  }

  double? _parseDouble(String s) {
    if (s.trim().isEmpty) return null;
    return double.tryParse(s.replaceAll(',', '.'));
  }

  double _toRad(double deg) => deg * math.pi / 180.0;

  double _haversine(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0; // km
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a =
        math.pow(math.sin(dLat / 2), 2) +
        math.cos(_toRad(lat1)) *
            math.cos(_toRad(lat2)) *
            math.pow(math.sin(dLon / 2), 2);
    final c =
        2 * math.atan2(math.sqrt(a as double), math.sqrt(1 - (a as double)));
    return R * c;
  }

  Map<String, double> _calcImpact(double kg) {
    return {
      'chorume': double.parse((kg * 1.33).toStringAsFixed(2)),
      'agua': double.parse((kg * 2.0).toStringAsFixed(2)),
      'co2': double.parse((kg * 0.33).toStringAsFixed(2)),
      'pontos': (kg * 2).roundToDouble(),
    };
  }

  Map<String, dynamic>? _findNearestColetor(double lat, double lon) {
    if (widget.coletores.isEmpty) return null;
    Map<String, dynamic>? nearest;
    double best = double.infinity;
    for (final c in widget.coletores) {
      final d = _haversine(
        (c['latitude'] as num).toDouble(),
        (c['longitude'] as num).toDouble(),
        lat,
        lon,
      );
      if (d < best) {
        best = d;
        nearest = {...c, 'dist_km': best};
      }
    }
    return nearest;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 0)),
      lastDate: now.add(const Duration(days: 365)),
      initialDate: _preferredDate ?? now,
      helpText: 'Data preferida',
    );
    if (picked != null) {
      setState(() => _preferredDate = picked);
    }
  }

  void _simularMatch() {
    if (_geradorId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Escolha um gerador')));
      return;
    }
    final g = widget.geradores.firstWhere((e) => e['id'] == _geradorId);
    final nearest = _findNearestColetor(
      (g['latitude'] as num).toDouble(),
      (g['longitude'] as num).toDouble(),
    );
    if (nearest == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum coletor cadastrado')),
      );
      return;
    }
    setState(() => _matchPreview = nearest);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Match sugerido: ${nearest['nome']} • ${(nearest['dist_km'] as double).toStringAsFixed(2)} km',
        ),
      ),
    );
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final kg = _parseDouble(_kgCtrl.text)!;
    final g = widget.geradores.firstWhere((e) => e['id'] == _geradorId);
    final coletor =
        _matchPreview ??
        _findNearestColetor(
          (g['latitude'] as num).toDouble(),
          (g['longitude'] as num).toDouble(),
        );

    if (coletor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum coletor encontrado')),
      );
      return;
    }

    final impacto = _calcImpact(kg);

    final request = <String, dynamic>{
      'id': _uuid.v4(),
      'site_id': g['id'],
      // aqui usamos o id do gerador como "site_id" simplificado
      'gerador_id': g['id'],
      'coletor_id': coletor['id'],
      'status': 'aberto',
      // ou 'concluida' se quiser já criar como feita
      'est_kg': kg,
      'preferred_date': (_preferredDate ?? DateTime.now()).toIso8601String(),
      'impacto_previsto': impacto,
      'created_at': DateTime.now().toIso8601String(),
    };

    Navigator.of(context).pop(request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar Coleta')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              value: _geradorId,
              items: widget.geradores
                  .map<DropdownMenuItem<String>>(
                    (g) => DropdownMenuItem(
                      value: g['id'] as String,
                      child: Text('${g['nome']} — ${g['tipo']}'),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _geradorId = v),
              decoration: const InputDecoration(labelText: 'Gerador'),
              validator: (v) => v == null ? 'Escolha um gerador' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _kgCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Quantidade estimada (kg)',
              ),
              validator: (v) {
                final d = _parseDouble(v ?? '');
                if (d == null || d <= 0) return 'Informe um valor válido';
                return null;
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Data preferida',
                    ),
                    child: Text(
                      _preferredDate == null
                          ? 'Hoje'
                          : '${_preferredDate!.day.toString().padLeft(2, '0')}/'
                                '${_preferredDate!.month.toString().padLeft(2, '0')}/'
                                '${_preferredDate!.year}',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Escolher'),
                  onPressed: _pickDate,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _simularMatch,
                  icon: const Icon(Icons.route),
                  label: const Text('Simular match'),
                ),
                const SizedBox(width: 8),
                if (_matchPreview != null)
                  Expanded(
                    child: Text(
                      'Sugerido: ${_matchPreview!['nome']} '
                      '(${(_matchPreview!['dist_km'] as double).toStringAsFixed(2)} km)',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: const TextStyle(color: Colors.green),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _salvar,
                icon: const Icon(Icons.check),
                label: const Text('Solicitar Coleta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
