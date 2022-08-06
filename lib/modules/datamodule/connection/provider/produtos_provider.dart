import 'package:flutter/material.dart';
import 'package:smartvendas/modules/datamodule/connection/dm.dart';
import 'package:smartvendas/modules/datamodule/connection/model/produtos.dart';
import 'package:smartvendas/shared/funcoes.dart';
import 'package:sqflite/sqflite.dart' as sql;

class ProdutosProvider {
  static final List<Produto> _items = [];

  static Future<List<Produto>> loadProdutos(
      String search, String filtrocategoria) async {
    _items.clear();
    List<Map<String, dynamic>> res;

    if ((filtrocategoria.isEmpty) && (Funcoes.isNumber(search))) {
      res = await DmModule.getNearestData('produtos', 'barras', search, false);
    } else {
      if (filtrocategoria.isEmpty) {
        res = await DmModule.getNearestData(
            'produtos', 'descricao', search, false);
      } else {
        res = await DmModule.sqlQuery(
            'select * from produtos where descricao like  "%' +
                search +
                '%" and idcategoria="' +
                filtrocategoria +
                '" order by descricao limit 100');
      }
    }

    return setTable(res, false);
  }

  static Future<List<Produto>> loadProdutosBarras(String search) async {
    _items.clear();
    List<Map<String, dynamic>> res;

    if (search == '' || search.isEmpty) {
      res = await DmModule.sqlQuery(
          'select * from produtos where 1<>1 order by descricao');
    } else {
      res = await DmModule.getData('produtos', 'barras', '=', search);
    }

    return setTable(res, false);
  }

  static List<Produto> setTable(Iterable list, bool isSave) {
    // myDb.delCliente();
    List<Produto> res;
    res = list.map((list) => Produto.fromMap(list, isSave)).toList();
    // list.map((list) => Cliente.fromMap(list));

    return res;
  }

  static Future<void> setRawTable(
      Iterable list, BuildContext rawContext) async {
    // myDb.delCliente();
    final db = await DmModule.database();
    List<Produto> res;
    int i;
    await db.transaction((txn) async {
      res = list.map((list) => Produto.fromMap(list, false)).toList();
      if (res.isEmpty) {
        return;
      }
      final pbProgress = Funcoes.progressBar(
          rawContext, res.length.toDouble(), 'Realizando consulta ao db...');

      await pbProgress.show();

      sql.Batch batch = txn.batch();
      i = 0;
      for (var produto in res) {
        i++;
        // print(i);
        batch.insert(
          'produtos',
          {
            'id': produto.id,
            'descricao': produto.descricao,
            'idcategoria': produto.idcategoria,
            'barras': produto.barras,
            'qte': produto.qte,
            'preco': produto.preco,
            'unidade': produto.unidade,
            'atacado': produto.atacado,
            'qteminatacado': produto.qteminatacado,
            'estoque': produto.estoque,
            'imagem': produto.imagem,
          },
          conflictAlgorithm: sql.ConflictAlgorithm.replace,
        );
        if (i % 1000 == 0) {
          pbProgress.update(
              progress: i.toDouble(),
              progressWidget: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const CircularProgressIndicator()),
              message: 'Atualizando produtos...');
          await batch.commit();
        }
      }
      if (pbProgress.isShowing()) {
        await pbProgress.hide();
      }
      await batch.commit();
    });
  }

  static Future<List<Produto>> loadProdutosConta() async {
    _items.clear();
    List<Map<String, dynamic>> res;
    res = await DmModule.getData('produtos', 'qte', '>', '0');

    return setTable(res, false);
  }

  static Future<void> resetProdutos() {
    return DmModule.updTable('update produtos set qte=0');
  }

  List<Produto> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Produto itemByIndex(int index) {
    return _items[index];
  }

  static void addReplaceProduto(Produto produto) {
    _items.add(produto);
    DmModule.insert(
      'produtos',
      {
        'id': produto.id,
        'descricao': produto.descricao,
        'idcategoria': produto.idcategoria,
        'barras': produto.barras,
        'qte': produto.qte,
        'preco': produto.preco,
        'unidade': produto.unidade,
        'atacado': produto.atacado,
        'qteminatacado': produto.qteminatacado,
        'estoque': produto.estoque,
        'imagem': produto.imagem,
      },
    );
  }
}
