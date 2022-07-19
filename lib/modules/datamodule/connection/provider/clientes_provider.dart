import 'package:smartvendas/modules/datamodule/connection/dm.dart';
import 'package:smartvendas/modules/datamodule/connection/model/clientes.dart';

class ClientesProvider {
  static final List<Cliente> _items = [];

  static Future<List<Cliente>> loadClientes(String searchNome) async {
    _items.clear();
    List<Map<String, dynamic>> res;

    if (searchNome == '' || searchNome.isEmpty) {
      res = await DmModule.getTable('clientes');
    } else {
      res = await DmModule.getNearestData('clientes', 'nome', searchNome);
    }

    return setTable(res, false);
  }

  static Future<List<Map<String, dynamic>>> getClientesPedidos() async {
    _items.clear();
    List<Map<String, dynamic>> res;

    res = await DmModule.sqlQuery(
        'select a.* from clientes a, pedidos b where a.id=b.idcliente group by a.id');
    if (res.isNotEmpty) {
      return res;
    } else {
      return [];
    }
  }

  static List<Cliente> setTable(Iterable list, bool isSave) {
    // myDb.delCliente();
    // list.map((list) => Cliente.fromMap(list));

    return list.map((list) => Cliente.fromMap(list, isSave)).toList();
  }

  List<Cliente> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Cliente itemByIndex(int index) {
    return _items[index];
  }

  static void addReplaceCliente(Cliente cliente) {
    _items.add(cliente);
    DmModule.insert(
      'clientes',
      {
        'id': cliente.id,
        'nome': cliente.nome,
        'fantasia': cliente.fantasia,
        'endereco': cliente.endereco,
        'numero': cliente.numero,
        'bairro': cliente.bairro,
        'cep': cliente.cep,
        'telefone': cliente.telefone,
        'uf': cliente.uf,
        'municipio': cliente.municipio,
        'latitude': cliente.latitude,
        'longitude': cliente.longitude,
        'alterado': 1,
      },
    );
  }
}
