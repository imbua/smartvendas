import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartvendas/app_store.dart';
import 'package:http/http.dart' as http;
import 'package:smartvendas/modules/datamodule/connection/dm.dart';
import 'package:smartvendas/modules/datamodule/connection/model/clientes.dart';
import 'package:smartvendas/modules/datamodule/connection/model/formapgto.dart';
import 'package:smartvendas/modules/datamodule/connection/model/itens.dart';
import 'package:smartvendas/modules/datamodule/connection/model/pedido.dart';
import 'package:smartvendas/modules/datamodule/connection/model/produtos_imagem.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/categorias_provider.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/clientes_provider.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/formapgto_provider.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/produtos_provider.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/produtosimagem_provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

AppStore ctrlApp = Get.find<AppStore>();
// var produtosList;

getListCarga(int index, String chave, List data, ProgressDialog prProgress) {
  List datajson = data;
  // var rest =  as List;
  if (!datajson.asMap().containsKey(index)) {
    return;
  }

  Iterable dataList = datajson[index][chave] as List;
//processo para gravar os dados iniciais somente, pois as listas serao refeitas no decorrer do programa
  if (chave == 'formapgto') {
    final List<FormaPgto> _resFormaPgto =
        FormaPgtoProvider.setTable(dataList, true);
    ctrlApp.lstFormaPgto.clear;
    for (var item in _resFormaPgto) {
      ctrlApp.lstFormaPgto.add(item.descricao);
    }
  } else if (chave == 'cadastro') {
    ClientesProvider.setTable(dataList, true);
  } else if (chave == 'produtos') {
    ProdutosProvider.setRawTable(dataList, prProgress);
  } else if (chave == 'categoria') {
    ctrlApp.lstCategoria = CategoriasProvider.setTable(dataList, true);
  } else if (chave == 'produtos_imagem') {
    List<ProdutosImagem> produtosimagens =
        ProdutosImagemProvider.setTable(dataList, true);
//grava em produtos

    for (ProdutosImagem item in produtosimagens) {
      String _imagem = item.imagem;
      String _id = item.id;
      DmModule.sqlQuery(
          'UPDATE produtos  SET imagem="$_imagem" WHERE id="$_id" ');
    }
  }
}

Future<void> cargaDados(String url, BuildContext cargaContext) async {
  try {
    try {
      await DmModule.delTable('clientes', '', '');
      await DmModule.delTable('formapgto', '', '');
      await DmModule.delTable('categorias', '', '');
      await DmModule.delTable('produtos', '', '');
      await DmModule.delTable('produtosimagem', '', '');
      await Future.delayed(const Duration(seconds: 1));
    } catch (exception) {
      rethrow;
    }
    // if (_rows == 0) {
    // await myDb.delCategoria();
    // await myDb.delProdutos();
    final ProgressDialog prProgress = ProgressDialog(context: cargaContext);
    prProgress.update(value: 0, msg: 'Conectando ao servidor...');
    final response =
        await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      String data = response.body;
      // print(data);
      if (data != 'erro') {
        List datajson = json.decode(data);
        // setCategorias(data);

        prProgress.update(value: 0, msg: 'Atualizando produtos...');
        getListCarga(0, "produtos", datajson, prProgress);
        prProgress.update(value: 0, msg: 'Atualizando categoria...');
        getListCarga(1, "categoria", datajson, prProgress);
        prProgress.update(value: 0, msg: 'Atualizando Forma Pgto...');
        getListCarga(2, "formapgto", datajson, prProgress);
        prProgress.update(value: 0, msg: 'Atualizando clientes...');
        getListCarga(3, "cadastro", datajson, prProgress);
        prProgress.update(value: 0, msg: 'Atualizando imagens...');
        getListCarga(4, "produtos_imagem", datajson, prProgress);
        prProgress.close();
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
