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
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
              child: TextField(
                controller: usuarioController,
                onChanged: ctrlApp.updUsuario,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  icon: const Icon(
                    FontAwesomeIcons.user,
                    color: Colors.black,
                    size: 22,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Usuário',
                  hintStyle: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Obx(
                () => TextField(
                  obscureText: ctrlApp.showSenha.isTrue,
                  controller: senhaController,
                  onChanged: ctrlApp.updSenha,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    icon: const Icon(
                      FontAwesomeIcons.key,
                      color: Colors.black,
                      size: 22,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Senha',
                    hintStyle:
                        const TextStyle(fontSize: 16, color: Colors.white),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const Spacer(),
                sbBotaoAcessar(
                    loginContext: loginPageContext), //loginPageContext
                const Spacer(),
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
      ],
    );
  }
}
