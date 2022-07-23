import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartvendas/app_routes.dart';
import 'package:smartvendas/app_store.dart';
import 'package:smartvendas/modules/menu/menu_item.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({Key? key}) : super(key: key);

  // get GoogleFonts => null;

  @override
  Widget build(BuildContext context) {
    AppStore ctrlApp = Get.find<AppStore>();

    return Scaffold(
      backgroundColor: const Color(0xFF21BFBD),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    //  ctrlApp.usuarioId.value = 0;
                    Navigator.of(context).popAndPushNamed(AppRoutes.login);
                  },
                  color: Colors.white,
                ),
                //nome do vendedor
                SizedBox(
                  width: 250,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Obx(() => Text(
                            ctrlApp.usuario.value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.end,
                          )),
                      const SizedBox(width: 15),
                    ],
                  ),
                ),
                //
              ],
            ),
          ),
          //titulo do menu principal
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Row(
              children: const <Widget>[
                Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'Principal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
          const SizedBox(height: 10),
          //itens do menu
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Color.fromARGB(250, 236, 232, 232),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(75),
              ),
            ),
            child: ListView(
              primary: false,
              padding: const EdgeInsets.only(top: 40),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView(
                      children: <Widget>[
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(() => (MenuItem(
                                    img: 'images/cliente.png',
                                    header: 'Clientes',
                                    botton: ctrlApp.totalClientes.toString() +
                                        ' clientes',
                                    onPress: () {
                                      Navigator.of(context)
                                          .pushNamed(AppRoutes.clienteList);
                                    },
                                  ))),
                              Obx(() {
                                return MenuItem(
                                    img: 'images/produto.png',
                                    header: 'Produtos',
                                    botton: ctrlApp.totalProdutos.toString() +
                                        ' produtos',
                                    onPress: () {
                                      Navigator.of(context)
                                          .pushNamed(AppRoutes.produtoList);
                                    });
                              }),
                            ]),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(() {
                              return MenuItem(
                                  img: 'images/pedidos.png',
                                  header: 'Pedidos',
                                  botton: ctrlApp.totalPedidos.toString() +
                                      ' pedidos',
                                  onPress: () {
                                    Navigator.of(context)
                                        .pushNamed(AppRoutes.pedidoList);
                                  });
                            }),
                            MenuItem(
                                img: 'images/vender.png',
                                header: 'Novo pedido',
                                botton: '', //'Registrar um novo pedido',
                                onPress: () {
                                  Navigator.of(context).pushNamed(
                                      AppRoutes.clientesSelecionar,
                                      arguments: 'pedido');
                                }),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MenuItem(
                              img: 'images/dav.png',
                              header: 'DAV',
                              botton: '',
                              onPress: () {
                                Navigator.of(context).pushNamed(
                                    AppRoutes.clientesSelecionar,
                                    arguments: 'dav');
                              },
                            ),
                            MenuItem(
                              img: 'images/preco.png',
                              header: 'Consulta',
                              botton: '',
                              onPress: () {
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.produtoPreco);
                              },
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MenuItem(
                              img: 'images/sincro.png',
                              header: 'Sincronizar',
                              botton: 'pedidos e carga',
                              onPress: () {
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.sincro);
                              },
                            ),
                            MenuItem(
                                img: 'images/config.png',
                                header: 'Configurar',
                                botton: '', //'Configurações gerais',
                                onPress: () {
                                  Navigator.of(context)
                                      .pushNamed(AppRoutes.config);
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
