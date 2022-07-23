import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smartvendas/app_store.dart';
import 'package:http/http.dart' as http;
import 'package:smartvendas/modules/datamodule/connection/dm.dart';
import 'package:smartvendas/modules/datamodule/connection/dmremoto.dart';
import 'package:smartvendas/shared/botao_customizado.dart';
import 'package:smartvendas/shared/funcoes.dart';
import 'package:smartvendas/shared/header_main.dart';

class ConfigWidget extends StatefulWidget {
  const ConfigWidget({Key? key}) : super(key: key);

  @override
  State<ConfigWidget> createState() => _ConfigWidgetState();
}

class _ConfigWidgetState extends State<ConfigWidget> {
  final TextEditingController txtChaveApp = TextEditingController();
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    AppStore ctrlApp = Get.find<AppStore>();
    txtChaveApp.text = ctrlApp.userChaveApp.value;
    return Scaffold(
      body: Column(
        children: [
          const HeaderMain(
            iconeMain: Icons.settings,
            titulo: 'Configurações',
            altura: 100,
          ),
          // ItemList(
          //   titulo: 'Opçoes teste',
          //   subTitulo: 'subOpçoes teste',
          //   cor: Colors.blue,
          //   iconeItemList: Icons.settings,
          //   item: Switch(
          //       value: checked,
          //       onChanged: (bool value) {
          //         setState(() {
          //           checked = value;
          //         });
          //       }),
          // ),
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: TextFormField(
              controller: txtChaveApp,
              onChanged: (value) async {
                ctrlApp.userChaveApp.value = value;
                ctrlApp.gravarIni();
              },
              textInputAction: TextInputAction.next,
              style: const TextStyle(fontSize: 12, color: Colors.blue),
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                    width: 0,
                  ),
                ),
                icon: Icon(
                  Icons.satellite,
                  color: Colors.blue,
                  size: 35,
                ),
                hintText: 'Chave do app',
                hintStyle: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),

          Expanded(child: Container()),
          BotaoInfo(
            caption: 'OK',
            iconeBotaoBackGround: FontAwesomeIcons.circleUser,
            onPress: () {
              ctrlApp.userChaveApp.value = txtChaveApp.text;
              getClientesWeb(context, ctrlApp.cwHostConnection).then((value) {
                if (value == true) {
                  ctrlApp.usuarioId.value = 0;
                  DmModule.delTable('clientes', '', '');
                  DmModule.delTable('categorias', '', '');
                  DmModule.delTable('produtos', '', '');
                  DmModule.delTable('produtosimagem', '', '');
                  ctrlApp.gravarIni();
                  Navigator.of(context).pop();
                }
              });

              // DmModule.sqlQuery('drop table pedidos;');
              // DmModule.database().then((value) {
              // DmModule.criaBanco(value);
              // }
              // );
            },
          ),
        ],
      ),
    );
  }
}

Future<bool> getClientesWeb(BuildContext context, String url) async {
  final msg = ScaffoldMessenger.of(context);
  var _bool = true;
  try {
    // int i;
    // final response = await http.get(Uri.parse(url));
    final response = await http.post(Uri.parse('http://' + url),
        headers: {'Content-type': 'application/x-www-form-urlencoded'},
        body: Funcoes.doXmlGetChaveAmazon(ctrlApp.userChaveApp.value));

    if (response.statusCode == 200) {
      String data = response.body;
      // print(data);
      if (data != 'erro') {
        List listjsn = json.decode(response.body);
        if (listjsn.isNotEmpty) {
          // for (i = 0; i < list.length; i++) {
          // list[i];
          // }
          // listjsn[0].map((list) {
          ctrlApp.cwHost = listjsn[0]['clientesweb'][0]['host'];
          // ctrlApp.cwHostUser = listjsn[0]['clientesweb'][0]['user'];
          // ctrlApp.cwHostPassword = listjsn[0]['clientesweb'][0]['password'];
          ctrlApp.cwHostDb =
              listjsn[0]['clientesweb'][0]['db_name']; //['database_autocom']
          ctrlApp.cwHostDbFinan = listjsn[0]['clientesweb'][0]['db_name_ex'];
        }

        // List<Usuario> _usuario = json.decode(response.body);
        // return _usuario
        //     .map((_usuario) => Usuario.fromJson(_usuario))
        //     .toList();
      } else {
        _bool = false;
        msg.showSnackBar(
          const SnackBar(
            content: Text('Chave, não encontrado!'),
          ),
        );
      }
    } else {
      _bool = false;
      msg.showSnackBar(
        SnackBar(
          content: Text("Erro no config, response Error:" +
              response.statusCode.toString()),
        ),
      );
      throw "Erro no config, response Error:" + response.statusCode.toString();
    }
  } catch (exception) {
    _bool = false;
    msg.showSnackBar(
      SnackBar(
        content: Text("Error on http." + exception.toString()),
      ),
    );
    throw "Error on http." + exception.toString();
  }
  return _bool;
}

class ItemList extends StatelessWidget {
  final Widget item;
  final Color cor;
  final String titulo;
  final String subTitulo;
  final IconData iconeItemList;

  const ItemList({
    Key? key,
    required this.item,
    this.cor = Colors.blue,
    required this.titulo,
    this.subTitulo = '',
    required this.iconeItemList,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        iconeItemList,
        color: cor,
        size: 35,
      ),
      title: Text(
        titulo,
        style: TextStyle(color: cor, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subTitulo,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      trailing: Transform.scale(
        scale: 1.2,
        child: item,
      ),
    );
  }
}
