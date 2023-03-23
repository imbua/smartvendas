import 'package:smartvendas/modules/datamodule/connection/dm.dart';
import 'package:smartvendas/modules/datamodule/connection/model/itens.dart';

class ItensProvider {
  static final List<Item> _items = [];

  static Future<List<Item>> loaditens(String searchNome) async {
    _items.clear();
    List<Map<String, dynamic>> res;
    res = await DmModule.getData('itens', 'idpedido', '=', searchNome);

    // res = await DmModule.getTable('itens');
    return setTable(res, false);
  }

  static String getItemId(String usuarioid) {
    // if (usuarioGravado.value != value) {
    //   usuarioId.value = 0;
    // }
    return usuarioid + DateTime.now().millisecondsSinceEpoch.toString();
  }

  static List<Item> setTable(Iterable list, bool doDb) {
    // myDb.delCliente();
    List<Item> res;
    res = list.map((list) => Item.fromMap(list, doDb)).toList();
    // list.map((list) => Cliente.fromMap(list));

    return res;
  }

  static void doSetTable(List<Item> list) {
    // myDb.delCliente();
    int i;
    for (i = 0; i < list.length; i++) {
      ItensProvider.addUpdateItem(list[i]);
    }
  }

  static Future gravaItens(String idPedido, idProduto, int qtde, double valor) {
    return DmModule.updTable(
        'update itens set qtde=$qtde,valor=$valor where idpedido="$idPedido" and idproduto="$idProduto"');
  }

  List<Item> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Item itemByIndex(int index) {
    return _items[index];
  }

  static void addUpdateItem(Item item) {
    _items.add(item);
    DmModule.insert(
      'itens',
      {
        'id': item.id,
        'idpedido': item.idpedido,
        'idproduto': item.idproduto,
        'descricao': item.descricao,
        'qtde': item.qtde,
        'qteminatacado': item.qteminatacado,
        'unidade': item.unidade,
        'valor': item.valor,
        'atacado': item.atacado,
        'totalfmt': item.totalfmt,
        'enviado': item.enviado
      },
    );
  }
}
