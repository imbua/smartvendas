import 'package:smartvendas/modules/datamodule/connection/dm.dart';
import 'package:smartvendas/modules/datamodule/connection/model/fornecedores.dart';

class FornecedoresProvider {
  static final List<Fornecedor> _items = [];

  static Future<List<Fornecedor>> loadFornecedores(String search) async {
    _items.clear();
    List<Map<String, dynamic>> res;

    if (search == '' || search.isEmpty) {
      res = await DmModule.getTable('fornecedores');
    } else {
      res =
          await DmModule.getNearestData('fornecedores', 'nome', search, false);
    }

    return setTable(res, false);
  }

  static List<Fornecedor> setTable(Iterable list, bool isSave) {
    // myDb.delFornecedor();
    // list.map((list) => Fornecedor.fromMap(list));

    return list.map((list) => Fornecedor.fromMap(list, isSave)).toList();
  }

  List<Fornecedor> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Fornecedor itemByIndex(int index) {
    return _items[index];
  }

  static void addReplaceFornecedor(Fornecedor fornecedor) {
    _items.add(fornecedor);
    DmModule.insert(
      'fornecedores',
      {
        'id': fornecedor.id,
        'descricao': fornecedor.descricao,
      },
    );
  }
}
