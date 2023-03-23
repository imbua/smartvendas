import 'package:smartvendas/app_store.dart';
import 'package:smartvendas/modules/datamodule/connection/dmremoto.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/categorias_provider.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/formapgto_provider.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/fornecedores_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DmModule {
  // DmModule._privateConstructor();
  // static final DmModule instance = DmModule._privateConstructor();

  static void setTabelas(AppStore ctrlApp) {
    CategoriasProvider.loadCategorias('').then((list) {
      ctrlApp.lstCategoria = [];
      for (var item in list) {
        ctrlApp.lstCategoria.add(item);
      }
    });

    FornecedoresProvider.loadFornecedores('').then((list) {
      ctrlApp.lstFornecedor = [];
      for (var item in list) {
        ctrlApp.lstFornecedor.add(item);
      }
    });

    FormaPgtoProvider.loadFormaPgto('').then((list) {
      ctrlApp.lstFormaPgto = [];
      for (var item in list) {
        ctrlApp.lstFormaPgto.add(item.descricao);
      }
    });
  }

  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'db.sqlite'),
      onCreate: (db, version) => _criarBanco(db, version),
      version: 1,
    );
  }

  static Future<void> criaBanco(sql.Database db) async {
    _criarBanco(db, 1);
  }

  static Future<void> _criarBanco(sql.Database db, int novaVersao) async {
    List<String> queryes = [
      "CREATE TABLE IF NOT EXISTS produtos (id TEXT PRIMARY KEY, descricao TEXT, idcategoria TEXT,idfornecedor TEXT, barras TEXT, unidade TEXT, custo FLOAT, preco  FLOAT, atacado  FLOAT,  qte FLOAT,  qteminatacado INTEGER, estoque FLOAT,volume TEXT, qtevolume FLOAT, imagem TEXT);",
      "CREATE TABLE IF NOT EXISTS produtosimagem (id TEXT PRIMARY KEY, imagem TEXT);",
      "CREATE TABLE IF NOT EXISTS clientes (id TEXT PRIMARY KEY,nome  TEXT,fantasia  TEXT,endereco  TEXT,numero  TEXT,bairro  TEXT,cep  TEXT,telefone  TEXT,uf  TEXT,municipio  TEXT,latitude  TEXT,longitude  TEXT, alterado  INTEGER,email TEXT);",
      "CREATE TABLE IF NOT EXISTS categorias (id TEXT PRIMARY KEY, descricao TEXT);",
      "CREATE TABLE IF NOT EXISTS fornecedores (id TEXT PRIMARY KEY, descricao TEXT);",
      "CREATE TABLE IF NOT EXISTS formapgto (id TEXT PRIMARY KEY, descricao TEXT);",
      "CREATE TABLE IF NOT EXISTS pedidos (id TEXT PRIMARY KEY, idvendedor  TEXT, nomevendedor  TEXT,idcliente  TEXT,nomecliente  TEXT,datapedido  TEXT,total  FLOAT,totalfmt  TEXT,enviado  INTEGER, formapgto TEXT, observacao TEXT);",
      "CREATE TABLE IF NOT EXISTS itens (id TEXT PRIMARY KEY ,idpedido   TEXT, idproduto   TEXT, descricao   TEXT, unidade   TEXT,qtde   float,qteminatacado INTEGER, valor   FLOAT,atacado   FLOAT, totalfmt   TEXT, enviado   INTEGER);",
      "CREATE TABLE IF NOT EXISTS cotacao (id TEXT PRIMARY KEY ,idcliente   TEXT, idproduto   TEXT, qtde   double);",
      "CREATE INDEX IF NOT EXISTS ibarras  ON produtos (barras);",
      "CREATE INDEX IF NOT EXISTS idescr  ON produtos (descricao);",
    ];

    for (String query in queryes) {
      await db.execute(query);
    }
  }

  static Future<dynamic> deletaPedido(String id) async {
    await DmModule.delTable('pedidos', 'id', id);
    await DmModule.delTable('itens', 'idpedido', id);
    ctrlApp.totalPedidos.value = await DmModule.getCount('pedidos');

    return;
  }

  static Future<int> getCount(String tabela) async {
    //database connection
    final db = await DmModule.database();
    var x = await db.rawQuery('SELECT COUNT (*) from  $tabela');
    int count = sql.Sqflite.firstIntValue(x) ?? 0;
    return count;
  }

  static Future<void> totalCounts() async {
    ctrlApp.totalClientes.value = await getCount('clientes');
    ctrlApp.totalProdutos.value = await getCount('produtos');
    ctrlApp.totalPedidos.value = await getCount('pedidos');
  }

  static Future<double> getTotal(String table, String formula) async {
    final db = await DmModule.database();
    var result = await db.rawQuery("SELECT SUM($formula) as total FROM $table");
    var value = result[0]["total"].toString();
    return double.tryParse(value) ?? 0;
  }

  static Future delTable(String table, String campo, String conteudo) async {
    final db = await DmModule.database();

    if (conteudo.isEmpty) {
      return db.transaction((txn) => txn.delete(table));
    } else {
      return db.transaction((txn) =>
          txn.delete(table, where: "$campo =  ?", whereArgs: [conteudo]));
    }
  }

  static Future updTable(String query) async {
    final db = await DmModule.database();
    return await db.transaction((txn) async {
      txn.rawUpdate(query);
    });
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DmModule.database();

    await db.transaction((txn) async {
      await txn.insert(
        table,
        data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
    });
  }

  static Future<List<Map<String, dynamic>>> getTable(String table) async {
    final db = await DmModule.database();
    return await db.transaction((txn) async {
      return await txn.query(table);
    });
  }

  static Future<List<Map<String, dynamic>>> getData(
      String table, String campo, String operador, String conteudo) async {
    final db = await DmModule.database();
    if (campo.isEmpty) {
      return await db.transaction((txn) async {
        return txn.query(table);
      });
    } else {
      return await db.transaction((txn) async {
        return txn.query(table,
            where: "$campo $operador  ?", whereArgs: [conteudo]);
      });
    }
  }

  static Future<List<Map<String, dynamic>>> getNearestData(
      String table, String campo, String conteudo, bool comecoexato) async {
    final db = await DmModule.database();
    String start = '';
    if (comecoexato == false) {
      start = '%';
    }
    return await db.transaction((txn) => txn.query(table,
        where: "$campo like  ?",
        whereArgs: ['$start$conteudo%'],
        limit: 500));
  }

  static Future<List<Map<String, dynamic>>> sqlQuery(String sqlText) async {
    final db = await DmModule.database();
    return await db.transaction((txn) async {
      return txn.rawQuery(sqlText);
    });

    // return await db.rawQuery(sqlText);
  }
}
