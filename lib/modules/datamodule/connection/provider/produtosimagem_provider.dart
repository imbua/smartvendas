import 'package:smartvendas/modules/datamodule/connection/dm.dart';
import 'package:smartvendas/modules/datamodule/connection/model/produtos_imagem.dart';

class ProdutosImagemProvider {
  static final List<ProdutosImagem> _items = [];

  static Future<List<ProdutosImagem>> loadProdutosimagens(String search) async {
    _items.clear();
    List<Map<String, dynamic>> res;

    if (search == '' || search.isEmpty) {
      res = await DmModule.getTable('produtosimagem');
    } else {
      res = await DmModule.getNearestData(
          'produtosimagem', 'imagem', search, false);
    }

    return setTable(res, false);
  }

  static List<ProdutosImagem> setTable(Iterable list, bool isSave) {
    // myDb.delProdutosImagem();
    // list.map((list) => ProdutosImagem.fromMap(list));

    return list.map((list) => ProdutosImagem.fromMap(list, isSave)).toList();
  }

  List<ProdutosImagem> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  ProdutosImagem itemByIndex(int index) {
    return _items[index];
  }

  static void addReplaceProdutosImagem(ProdutosImagem produtosimagem) {
    _items.add(produtosimagem);
    DmModule.insert(
      'produtosimagem',
      {
        'id': produtosimagem.id,
        'imagem': produtosimagem.imagem,
      },
    );
  }
}
