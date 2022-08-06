import 'package:flutter/material.dart';

import 'package:smartvendas/componentes/app_rodape.dart';
import 'package:smartvendas/shared/header_main.dart';
import 'widgets/login_frame.dart';

class LoginPage extends StatefulWidget {
  final String title;
  const LoginPage({Key? key, this.title = "Login"}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController loginUsuarioController = TextEditingController();
  TextEditingController loginSenhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.blue.shade50,
                  Colors.blue,
                ],
                begin: const FractionalOffset(0.5, 0.0),
                end: const FractionalOffset(0.3, 1.0),
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Stack(
                  children: const [
                    HeaderMain(
                      iconeMain: Icons.shop_2_sharp,
                      titulo: 'Smart Vendas',
                      altura: 201,
                    ),
                  ],
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: loginFrame(
                        loginPageContext: context,
                        usuarioController: loginUsuarioController,
                        senhaController: loginSenhaController),
                  ),
                ),
                const AppRodape(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
