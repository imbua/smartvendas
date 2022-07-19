import 'package:smartvendas/modules/datamodule/connection/dm.dart';
import 'package:smartvendas/modules/datamodule/connection/model/categoria.dart';

class CategoriasProvider {
  static final List<Categoria> _items = [];

  static Future<List<Categoria>> loadCategorias(String search) async {
    _items.clear();
    List<Map<String, dynamic>> res;

    if (search == '' || search.isEmpty) {
      res = await DmModule.getTable('categorias');
    } else {
      res = await DmModule.getNearestData('categorias', 'descricao', search);
    }

    return setTable(res, false);
  }

  static List<Categoria> setTable(Iterable list, bool isSave) {
    // myDb.delCategoria();
    // list.map((list) => Categoria.fromMap(list));

    return list.map((list) => Categoria.fromMap(list, isSave)).toList();
  }

  List<Categoria> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Categoria itemByIndex(int index) {
    return _items[index];
  }

  static void addReplaceCategoria(Categoria categoria) {
    _items.add(categoria);
    DmModule.insert(
      'categorias',
      {
        'id': categoria.id,
        'descricao': categoria.descricao,
      },
    );
  }
}
