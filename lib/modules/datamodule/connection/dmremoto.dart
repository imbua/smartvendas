import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:smartvendas/app_store.dart';
import 'package:http/http.dart' as http;
import 'package:smartvendas/modules/datamodule/connection/dm.dart';
import 'package:smartvendas/modules/datamodule/connection/model/clientes.dart';
import 'package:smartvendas/modules/datamodule/connection/model/itens.dart';
import 'package:smartvendas/modules/datamodule/connection/model/pedido.dart';
import 'package:smartvendas/modules/datamodule/connection/model/produtos_imagem.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/categorias_provider.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/clientes_provider.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/formapgto_provider.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/fornecedores_provider.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/produtos_provider.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/produtosimagem_provider.dart';
import 'package:smartvendas/shared/funcoes.dart';

AppStore ctrlApp = Get.find<AppStore>();
// var produtosList;

getListCarga(String chave, List data, BuildContext context) async {
  List datajson = data;
  // var rest =  as List;

  int i = 0;
  Iterable dataList = [];
  for (i = 0; i < datajson.length; i++) {
    if (datajson[i][chave] != null) {
      dataList = datajson[i][chave] as List;
      break;
    }
  }
  if (dataList.isEmpty) {
    return;
  }
//processo para gravar os dados iniciais somente, pois as listas serao refeitas no decorrer do programa
  if (chave == 'formapgto') {
    FormaPgtoProvider.setTable(dataList, true);
  } else if (chave == 'cadastro') {
    ClientesProvider.setTable(dataList, true);
  } else if (chave == 'fornecedores') {
    FornecedoresProvider.setTable(dataList, true);
  } else if (chave == 'produtos') {
    await ProdutosProvider.setRawTable(dataList, context, ctrlApp.isLocal);
  } else if (chave == 'categoria') {
    CategoriasProvider.setTable(dataList, true);
  } else if (chave == 'produtos_imagem') {
    List<ProdutosImagem> produtosimagens =
        ProdutosImagemProvider.setTable(dataList, true);
//grava em produtos

    for (ProdutosImagem item in produtosimagens) {
      String _imagem = item.imagem;
      String _id = item.id;
      await DmModule.sqlQuery(
          'UPDATE produtos  SET imagem="$_imagem" WHERE id="$_id" ');
    }
  }
}

Future<void> clearToCarga() async {
  await DmModule.delTable('clientes', '', '');
  await DmModule.delTable('fornecedores', '', '');
  await DmModule.delTable('formapgto', '', '');
  await DmModule.delTable('categorias', '', '');
  await DmModule.delTable('produtos', '', '');
  await DmModule.delTable('produtosimagem', '', '');
  ctrlApp.totalClientes.value = 0;
  ctrlApp.totalProdutos.value = 0;
  ctrlApp.totalPedidos.value = 0;
}

Future<void> cargaDados(String url, BuildContext cargaContext) async {
  final pbProgress = Funcoes.progressBar(cargaContext, 1, 'Pegando a carga...');

  try {
    try {
      await clearToCarga();
      await Future.delayed(const Duration(seconds: 1));
    } catch (exception) {
      rethrow;
    }
    // if (_rows == 0) {
    // await myDb.delCategoria();
    // await myDb.delProdutos();
    await pbProgress.show();
    final response =
        await http.get(Uri.parse(url)).timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      final decoded_data = GZipCodec().decode(response.bodyBytes);
      String data = response.body;
      Map<String, String> dataheader = response.headers;
      // print(data);
      await pbProgress.hide();
      if (data != 'erro') {
        List datajson = json.decode(data);
        // setCategorias(data);

        await getListCarga("produtos", datajson, cargaContext);

        await getListCarga("categoria", datajson, cargaContext);
        await getListCarga("formapgto", datajson, cargaContext);
        await getListCarga("cadastro", datajson, cargaContext);
        await getListCarga("fornecedores", datajson, cargaContext);
        await getListCarga("produtos_imagem", datajson, cargaContext);
        DmModule.setTabelas(ctrlApp);
        ctrlApp.ultimaCarga = Jiffy().format('dd[/]MM[/]yyyy');
        ctrlApp.gravarIni();
      } else {
        throw "Erro na carga,Body Error:" + response.body;
      }
    } else {
      throw "Erro na carga, response Error:" + response.statusCode.toString();
    }
    // return true;

  } catch (exception) {
    rethrow;
    // "Error on http." + exception.toString();
  }
}

String encodeToHttp(List jsonRes) {
  var _jsResult = json.encode(jsonRes);
  var _jsUtf8 = utf8.encode(_jsResult);
  return base64.encode(_jsUtf8);
}

String encodeJsonToHttp(String jsonRes) {
  var _jsUtf8 = utf8.encode(jsonRes);
  return base64.encode(_jsUtf8);
}

Future<String> sendColetor(BuildContext cargaContext) async {
  try {
    var url = ctrlApp.urlSendColetor;
    List _itens = await DmModule.getData('produtos', 'qte', '>', '0');
    //await ClientesProvider.getClientesPedidos();
    // myDb.getToSendCliente();

    // print(_clientes.toList());
    if (_itens.isNotEmpty) {
      var _jsItm = encodeToHttp(_itens);
      final response = await http.post(Uri.parse(url), headers: {
        'Content-type': 'application/x-www-form-urlencoded'
      }, body: {
        "pHeader": "1",
        "pItens": _jsItm,
        "pCli": "1",
        "pOrigem": "COLETOR",
      });
      if (response.statusCode == 200) {
        if (response.body == 'true') {
          ProdutosProvider.resetProdutos();

          return ' processo concluido!';
        } else {
          return ' Erro no envio ';
        }
      } else {
        return ' Erro na comunicação, StatusCode:' +
            response.statusCode.toString();
      }
    }
    return ' Processo concluido!';
  } catch (exception) {
    // throw("Error on http." + exception.toString());
    rethrow;
  }
}

Future<String> sendPedidos(BuildContext cargaContext) async {
  try {
    var url = ctrlApp.urlSendPedidos;
    List _clientes = await ClientesProvider.getClientesPedidos();

    List _ped = await DmModule.getTable('pedidos');
    if (_ped.isNotEmpty) {
      List _itens = await DmModule.getTable('itens');
      //await ClientesProvider.getClientesPedidos();
      // myDb.getToSendCliente();

      // print(_clientes.toList());
      if (_itens.isNotEmpty) {
        var _jsPed = encodeToHttp(_ped);
        var _jsItm = encodeToHttp(_itens);
        var _jsCli = encodeToHttp(_clientes);
        final response = await http.post(Uri.parse(url), headers: {
          'Content-type': 'application/x-www-form-urlencoded'
        }, body: {
          "pHeader": _jsPed,
          "pItens": _jsItm,
          "pCli": _jsCli,
          "pOrigem": "PEDIDO",
        });
        if (response.statusCode == 200) {
          if (response.body == 'true') {
            DmModule.deletaPedido('');
            return ' processo concluido!';
          } else {
            return ' Erro no envio ';
          }
        } else {
          return ' Erro na comunicação, StatusCode:' +
              response.statusCode.toString();
        }
      }
      return ' Processo concluido!';
    } else {
      return ' Nenhum pedido encontrado!';
    }
  } catch (exception) {
    // throw("Error on http." + exception.toString());
    rethrow;
  }
}

Future<bool> sendDAV(BuildContext cargaContext, Cliente cliente,
    List<Pedido> pedido, List<Item> items) async {
  final msg = ScaffoldMessenger.of(cargaContext);
  try {
    var url = ctrlApp.urlSendPedidos;
    bool _bool = false;
    String _msg = '';

    //await ClientesProvider.getClientesPedidos();
    // myDb.getToSendCliente();

    // print(_clientes.toList());

    var _jsPed = encodeJsonToHttp(jsonEncode(pedido));
    var _jsItm = encodeJsonToHttp(jsonEncode(items));
    var _jsCli = encodeJsonToHttp(jsonEncode(cliente));
    final response = await http.post(Uri.parse(url), headers: {
      'Content-type': 'application/x-www-form-urlencoded'
    }, body: {
      "pHeader": _jsPed,
      "pItens": _jsItm,
      "pCli": _jsCli,
      "pOrigem": "DAV",
    });
    if (response.statusCode == 200) {
      if (response.body == 'true') {
        _bool = true;
      } else {
        _bool = false;
        _msg = response.body;
      }
    } else {
      _bool = false;
      _msg =
          'Erro na comunicação, StatusCode:' + response.statusCode.toString();
    }
    if (_bool == false) {
      msg.showSnackBar(
        SnackBar(
          content: Text(
            _msg,
          ),
        ),
      );
    }
    return _bool;
  } catch (exception) {
    msg.showSnackBar(
      SnackBar(
        content: Text(
          "Error on http." + exception.toString(),
        ),
      ),
    );
    // throw("Error on http." + exception.toString());
    return false;
  }
}


// Future<List<CategoriasModel>> setCategorias(Iterable list) async {
//   // await myDb.delCategoria();
//   return list.map((list) => CategoriasModel.fromJson(list)).toList();
// }

// Future<List<ProdutosModel>> setProdutos(Iterable list) async {
//   // await myDb.delProdutos();
//   return list.map((list) => ProdutosModel.fromJson(list)).toList();
// }

// Future<List<Cliente>> setClientes(Iterable list) async {
//   // myDb.delCliente();
//   // list.map((list) => Cliente.fromMap(list));

//   return list.map((list) => Cliente.fromMap(list, true)).toList();
// }

// print(_ped);

// print(_itens);
