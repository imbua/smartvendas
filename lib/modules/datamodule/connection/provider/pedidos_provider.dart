import 'package:smartvendas/modules/datamodule/connection/dm.dart';
import 'package:smartvendas/modules/datamodule/connection/model/pedido.dart';

class PedidosProvider {
  static final List<Pedido> _items = [];
  static List<Pedido> pedido = [];

  static Future<List<Pedido>> loadPedidos(String searchNome) async {
    _items.clear();
    List<Map<String, dynamic>> res;

    if (searchNome == '' || searchNome.isEmpty) {
      res = await DmModule.getTable('pedidos');
    } else {
      res = await DmModule.getNearestData('pedidos', 'descricao', searchNome);
    }
    return setTable(res, false);
  }

  static Future<List<Pedido>> getQueryPedido(String id) async {
    _items.clear();
    List<Map<String, dynamic>> res;
    res = await DmModule.getNearestData('pedidos', 'id', id);
    pedido = setTable(res, false);
    return pedido;
  }

  static Pedido getPedido(Iterable list) {
    // myDb.delCliente();
    List<Pedido> res;
    res = list.map((list) => Pedido.fromMap(list, true)).toList();
    // list.map((list) => Cliente.fromMap(list));

    return res[0];
  }

  static List<Pedido> setTable(Iterable list, bool isSave) {
    // myDb.delCliente();
    List<Pedido> res;
    res = list.map((list) => Pedido.fromMap(list, isSave)).toList();
    // list.map((list) => Cliente.fromMap(list));

    return res;
  }

  static Future gravaItens(String idPedido) {
    return DmModule.updTable(
        ' insert into itens (idPedido,idProduto,descricao,unidade,qtde,qteminatacado,valor,atacado,totalfmt,enviado)'
        ' select "$idPedido", id,descricao,unidade,qte,qteminatacado,preco,atacado,(qte*preco) as total,0 from produtos where qte>0  ');
  }

  static Future<void> resetProdutos() {
    return DmModule.updTable('update produtos set qte=0');
  }

  List<Pedido> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Pedido itemByIndex(int index) {
    return _items[index];
  }

  static void addUpdatePedido(Pedido pedido) {
    _items.add(pedido);
    DmModule.insert(
      'pedidos',
      {
        'id': pedido.id,
        'idvendedor': pedido.idvendedor,
        'nomevendedor': pedido.nomevendedor,
        'idcliente': pedido.idcliente,
        'nomecliente': pedido.nomecliente,
        'datapedido': pedido.datapedido,
        'total': pedido.total,
        'totalfmt': pedido.totalfmt,
        'enviado': pedido.enviado,
      },
    );
  }
}
