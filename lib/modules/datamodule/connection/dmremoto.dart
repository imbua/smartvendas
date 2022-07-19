import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:smartvendas/app_store.dart';
import 'package:http/http.dart' as http;
import 'package:smartvendas/modules/datamodule/connection/dm.dart';
import 'package:smartvendas/modules/datamodule/connection/model/produtos_imagem.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/categorias_provider.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/clientes_provider.dart';
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
  if (chave == 'cadastro') {
    ClientesProvider.setTable(dataList, true);
  } else if (chave == 'produtos') {
    ProdutosProvider.setRawTable(dataList, prProgress);
  } else if (chave == 'categoria') {
    CategoriasProvider.setTable(dataList, true);
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

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String data = response.body;
      // print(data);
      if (data != 'erro') {
        List datajson = json.decode(data);
        // setCategorias(data);

        getListCarga(0, "produtos", datajson, prProgress);
        prProgress.update(value: 0, msg: 'Atualizando categoria...');
        getListCarga(1, "categoria", datajson, prProgress);
        prProgress.update(value: 0, msg: 'Atualizando clientes...');
        getListCarga(2, "cadastro", datajson, prProgress);
        prProgress.update(value: 0, msg: 'Atualizando imagens...');
        getListCarga(3, "produtos_imagem", datajson, prProgress);
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
        final response = await http.post(Uri.parse(url),
            headers: {'Content-type': 'application/x-www-form-urlencoded'},
            body: {"pHeader": _jsPed, "pItens": _jsItm, "pCli": _jsCli});
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
