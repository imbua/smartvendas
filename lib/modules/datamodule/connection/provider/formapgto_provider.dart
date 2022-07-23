import 'package:smartvendas/modules/datamodule/connection/dm.dart';
import 'package:smartvendas/modules/datamodule/connection/model/formapgto.dart';

class FormaPgtoProvider {
  static final List<FormaPgto> _items = [];

  static Future<List<FormaPgto>> loadFormaPgto(String search) async {
    _items.clear();
    List<Map<String, dynamic>> res;

    if (search == '' || search.isEmpty) {
      res = await DmModule.getTable('formapgto');
    } else {
      res =
          await DmModule.getNearestData('formapgto', 'descricao', search, true);
    }

    return setTable(res, false);
  }

  static List<FormaPgto> setTable(Iterable list, bool isSave) {
    // myDb.delFormaPgto();
    // list.map((list) => FormaPgto.fromMap(list));

    return list.map((list) => FormaPgto.fromMap(list, isSave)).toList();
  }

  List<FormaPgto> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  FormaPgto itemByIndex(int index) {
    return _items[index];
  }

  static void addReplaceFormaPgto(FormaPgto formapgto) {
    _items.add(formapgto);
    DmModule.insert(
      'formapgto',
      {
        'id': formapgto.id,
        'descricao': formapgto.descricao,
      },
    );
  }
}
