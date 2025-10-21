class Gerador {
  String id;
  String nome;
  String tipo;
  String endereco;
  double latitude;
  double longitude;

  Gerador({required this.id, required this.nome, required this.tipo, required this.endereco, required this.latitude, required this.longitude});

  factory Gerador.fromJson(Map<String, dynamic> json) => Gerador(
    id: json['id'],
    nome: json['nome'],
    tipo: json['tipo'],
    endereco: json['endereco'],
    latitude: json['latitude'],
    longitude: json['longitude'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'tipo': tipo,
    'endereco': endereco,
    'latitude': latitude,
    'longitude': longitude,
  };
}

class Coletor {
  String id;
  String nome;
  String tipo;
  String endereco;
  double latitude;
  double longitude;
  double capacidade;
  String horario;

  Coletor({required this.id, required this.nome, required this.tipo, required this.endereco, required this.latitude, required this.longitude, required this.capacidade, required this.horario});

  factory Coletor.fromJson(Map<String, dynamic> json) => Coletor(
    id: json['id'],
    nome: json['nome'],
    tipo: json['tipo'],
    endereco: json['endereco'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    capacidade: json['capacidade'],
    horario: json['horario'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'tipo': tipo,
    'endereco': endereco,
    'latitude': latitude,
    'longitude': longitude,
    'capacidade': capacidade,
    'horario': horario,
  };
}

class Coleta {
  String id;
  String geradorId;
  String coletorId;
  DateTime data;
  double quantidade;
  Map<String, double> impacto;
  String status;

  Coleta({required this.id, required this.geradorId, required this.coletorId, required this.data, required this.quantidade, required this.impacto, required this.status});

  factory Coleta.fromJson(Map<String, dynamic> json) => Coleta(
    id: json['id'],
    geradorId: json['gerador_id'],
    coletorId: json['coletor_id'],
    data: DateTime.parse(json['data']),
    quantidade: json['quantidade'],
    impacto: Map<String, double>.from(json['impacto']),
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'gerador_id': geradorId,
    'coletor_id': coletorId,
    'data': data.toIso8601String(),
    'quantidade': quantidade,
    'impacto': impacto,
    'status': status,
  };
}