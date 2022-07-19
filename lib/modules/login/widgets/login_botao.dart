// ignore_for_file: camel_case_types

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:smartvendas/app_routes.dart';
import 'package:smartvendas/app_store.dart';
import 'package:http/http.dart' as http;
import 'package:smartvendas/modules/datamodule/connection/dm.dart';
import 'package:smartvendas/shared/show_message.dart';

class sbBotaoAcessar extends StatelessWidget {
  const sbBotaoAcessar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppStore ctrlApp = Get.find<AppStore>();
    // print(ctrlApp.usuario.isNotEmpty);
    return Visibility(
      // visible: (ctrlApp.usuario.isNotEmpty && ctrlApp.senha.isNotEmpty),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.blue.shade50,
              offset: const Offset(1, 6),
              blurRadius: 20,
            ),
            const BoxShadow(
              color: Colors.blue,
              offset: Offset(1, 6),
              blurRadius: 20,
            ),
          ],
          gradient: LinearGradient(
            colors: <Color>[
              Colors.blue,
              Colors.blue.shade50,
            ],
          ),
        ),
        margin: const EdgeInsets.only(top: 10),
        child: MaterialButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.blue,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 42),
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
            onPressed: () {
              if (ctrlApp.userChaveApp.isEmpty) {
                showMessage(
                    'Sem a chave de acesso, use o botão de config.', context);
              } else {
                ctrlApp.updipServer(
                    ctrlApp.cwHost + ctrlApp.ipServerSufixo); //provisório

                if ((ctrlApp.usuarioId.value != 0) &&
                    (ctrlApp.usuarioGravado.value == ctrlApp.usuario.value) &&
                    (ctrlApp.senhaGravado.value == ctrlApp.senha.value)) {
                  DmModule.totalCounts();
                  Navigator.of(context).pushNamed(AppRoutes.menu);
                } else {
                  try {
                    loginUsuario(context, ctrlApp.loginRemoto).then((value) {
                      if (ctrlApp.usuarioId.value != 0) {
                        if (ctrlApp.usuarioId.value != 0) {
                          DmModule.totalCounts();
                          Navigator.of(context).pushNamed(AppRoutes.menu);
                        }
                      }
                    });
                  } catch (exception) {
                    Navigator.of(context).pushNamed(AppRoutes.login);
                  }
                }
              }
            }),
      ),
    );
  }

  // _login(String url) {
  //   loginUsuario(url);
  //   return ctrlApp.usuarioId.value;
  // }

  Future<List<Usuario>> loginUsuario(BuildContext context, String url) async {
    final msg = ScaffoldMessenger.of(context);
    try {
      final response = await http.get(Uri.parse(url));

      // ignore: unrelated_type_equality_checks
      if (response.statusCode == 200) {
        String data = response.body;
        // print(data);
        if (data != 'erro') {
          Iterable list = json.decode(response.body);
          return list.map((list) => Usuario.fromJson(list)).toList();

          // List<Usuario> _usuario = json.decode(response.body);
          // return _usuario
          //     .map((_usuario) => Usuario.fromJson(_usuario))
          //     .toList();
        } else {
          msg.showSnackBar(
            const SnackBar(
              content: Text('Usuário, não encontrado!'),
            ),
          );
          throw "Erro no login, response Error:" +
              response.statusCode.toString();
        }
      } else {
        msg.showSnackBar(
          SnackBar(
            content: Text("Erro no login, response Error:" +
                response.statusCode.toString()),
          ),
        );
        throw "Erro no login, response Error:" + response.statusCode.toString();
      }
    } catch (exception) {
      msg.showSnackBar(
        SnackBar(
          content:
              Text("Erro no login, exception Error:" + exception.toString()),
        ),
      );
      throw "Error on http." + exception.toString();
    }
  }
}

class Usuario {
  Usuario.fromJson(Map<String, dynamic> json) {
    _gravar(json['id'] as String, json['user'] as String);
  }
}

_gravar(String id, String nome) async {
  AppStore ctrlApp = Get.find<AppStore>();
  ctrlApp.usuarioId.value = int.parse(id);
  ctrlApp.usuario.value = nome;
  // ctrlApp.usuarioNome.value = nome;
  ctrlApp.gravarIni();
}
