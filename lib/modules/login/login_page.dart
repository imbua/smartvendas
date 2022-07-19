import 'package:flutter/material.dart';

import 'package:smartvendas/componentes/app_rodape.dart';
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
                Padding(
                  padding: const EdgeInsets.only(top: 30, right: 5, left: 5),
                  child: Row(children: [
                    const Icon(Icons.shopify_outlined, size: 120),
                    Column(
                      children: const [
                        Text(
                          'Smart',
                          style: TextStyle(
                              fontSize: 48, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Vendas',
                          style: TextStyle(
                              fontSize: 48, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ]),
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: loginFrame(
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
