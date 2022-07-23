// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smartvendas/app_routes.dart';
import 'package:smartvendas/app_store.dart';

import 'login_botao.dart';

class loginFrame extends StatelessWidget {
  final TextEditingController usuarioController;
  final TextEditingController senhaController;
  final BuildContext loginPageContext;

  const loginFrame(
      {Key? key,
      required this.usuarioController,
      required this.senhaController,
      required this.loginPageContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppStore ctrlApp = Get.find<AppStore>();
    usuarioController.text = ctrlApp.usuario.value;
    senhaController.text = ctrlApp.senha.value;

    return Column(
      children: <Widget>[
        Card(
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: SizedBox(
            width: 400,
            height: 230,
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: TextField(
                    controller: usuarioController,
                    onChanged: ctrlApp.updUsuario,
                    style: const TextStyle(fontSize: 16, color: Colors.blue),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(
                        FontAwesomeIcons.user,
                        color: Colors.black,
                        size: 22,
                      ),
                      hintText: 'Usuário',
                      hintStyle: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(
                  width: double.infinity,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Obx(
                    () => TextField(
                      obscureText: ctrlApp.showSenha.isTrue,
                      controller: senhaController,
                      onChanged: ctrlApp.updSenha,
                      style: const TextStyle(fontSize: 16, color: Colors.blue),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: const Icon(
                          FontAwesomeIcons.key,
                          color: Colors.black,
                          size: 22,
                        ),
                        hintText: 'Senha',
                        hintStyle:
                            const TextStyle(fontSize: 16, color: Colors.black),
                        suffixIcon: GestureDetector(
                          onTap: ctrlApp.isShowSenha,
                          child: Icon(
                            ctrlApp.showSenha.value
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeSlash,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: double.infinity,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.config);
                      },
                      icon: const Icon(Icons.settings),
                      iconSize: 30,
                      // color: Colors.white,
                    ),
                    const SizedBox(
                      width: 21,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        sbBotaoAcessar(loginContext: loginPageContext),
      ],
    );
  }
}
