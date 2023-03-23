import 'package:smartvendas/modules/datamodule/connection/provider/clientes_provider.dart';

class Cliente {
  String id = '';
  String nome = '';
  String fantasia = '';
  String endereco = '';
  String numero = '';
  String bairro = '';
  String cep = '';
  String telefone = '';
  String uf = '';
  String municipio = '';
  String latitude = '';
  String longitude = '';
  String email = '';
  int alterado = 0;

  Cliente(
    this.id,
    this.nome,
    this.fantasia,
    this.endereco,
    this.numero,
    this.bairro,
    this.cep,
    this.telefone,
    this.uf,
    this.municipio,
    this.latitude,
    this.longitude,
    this.email,
  );
  Map toJson() => {
        'id': id,
        'nome': nome,
        'fantasia': fantasia,
        'endereco': endereco,
        'numero': numero,
        'bairro': bairro,
        'cep': cep,
        'telefone': telefone,
        'uf': uf,
        'municipio': municipio,
        'latitude': latitude,
        'longitude': longitude,
        'email': email,
      };
  factory Cliente.fromMap(Map<String, dynamic> dados, bool toDb) {
    Cliente cliente = Cliente(
      dados['id'],
      dados['nome'],
      dados['fantasia'],
      dados['endereco'],
      dados['numero'],
      dados['bairro'],
      dados['cep'],
      dados['telefone'],
      dados['uf'],
      dados['municipio'],
      dados['latitude'],
      dados['longitude'],
      dados['email'],
    );
    if (toDb) {
      ClientesProvider.addReplaceCliente(cliente);
    }
    return cliente;
  }

  Map<String, dynamic> toMap() {
    var dados = <String, dynamic>{};
    dados['id'] = id;
    dados['nome'] = nome;
    dados['fantasia'] = fantasia;
    dados['endereco'] = endereco;
    dados['numero'] = numero;
    dados['bairro'] = bairro;
    dados['cep'] = cep;
    dados['telefone'] = telefone;
    dados['uf'] = uf;
    dados['municipio'] = municipio;
    dados['latitude'] = latitude;
    dados['longitude'] = longitude;
    dados['alterado'] = alterado;
    dados['email'] = email;
    return dados;
  }

  Cliente.mapToModel(Map<String, dynamic> dados) {
    id = dados['id'];
    nome = dados["nome"];
    cep = dados["cep"] ?? '00.000-00';
    endereco = dados["endereco"];
    fantasia = dados["fantasia"] ?? dados["nome"];
    municipio = dados["municipio"] ?? '';
    telefone = dados["telefone"] ?? '';
    numero = dados["numero"] ?? 'S/N';
    bairro = dados["bairro"] ?? '';
    uf = dados["uf"] ?? '';
    latitude = dados["latitude"] ?? '';
    longitude = dados["longitude"] ?? '';
    email = dados["email"] ?? '';
    alterado = 0;
  }

  Cliente.addmapToModel(Map<String, dynamic> dados) {
    id = dados['id'];
    nome = dados["nome"];
    cep = dados["cep"] ?? '00.000-00';
    endereco = dados["endereco"];
    fantasia = dados["fantasia"] ?? dados["nome"];
    municipio = dados["municipio"] ?? '';
    telefone = dados["telefone"] ?? '';
    numero = dados["numero"] ?? 'S/N';
    bairro = dados["bairro"] ?? '';
    uf = dados["uf"] ?? '';
    latitude = dados["latitude"] ?? '';
    longitude = dados["longitude"] ?? '';
    email = dados["email"] ?? '';
    alterado = 0;
  }
}
