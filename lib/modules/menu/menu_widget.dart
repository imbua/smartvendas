import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartvendas/app_routes.dart';
import 'package:smartvendas/app_store.dart';
import 'package:smartvendas/componentes/app_rodape.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/produtos_provider.dart';
import 'package:smartvendas/modules/menu/menu_item.dart' as menu;

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
              children: <Widget>[
                const Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Principal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.config);
                  },
                  icon: const Icon(Icons.settings),
                  iconSize: 30,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Container(
            color: const Color(0xFF21BFBD),
            height: 30,
            width: 30,
            child: const AppRodape(),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Color.fromARGB(250, 236, 232, 232),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(75),
              ),
            ),
            child: Padding(
              padding: ctrlApp.isLocal
                  ? const EdgeInsets.only(top: 40)
                  : const EdgeInsets.only(top: 40),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  children: <Widget>[
                    MenuItemRow(ctrlApp: ctrlApp),
                    ctrlApp.isLocal
                        ? const SizedBox()
                        : MenuItemRemote(ctrlApp: ctrlApp),
                    ctrlApp.isLocal
                        ? MenuItemLocal(ctrlApp: ctrlApp)
                        : const SizedBox(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        menu.MenuItem(
                            img: 'images/coletor.png',
                            header: 'Coletor',
                            botton: '', //'Configurações gerais',
                            onPress: () {
                              ProdutosProvider.resetProdutos;
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.produtosColetor);
                            }),
                        menu.MenuItem(
                          img: 'images/cotacao.png',
                          header: 'Cotação',
                          botton: 'Cotar preços',
                          onPress: () {
                            Navigator.of(context)
                                .pushNamed(AppRoutes.pedidoCotacao);
                          },
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        menu.MenuItem(
                          img: 'images/sincro.png',
                          header: 'Sincronizar',
                          botton: 'pedidos e carga',
                          onPress: () {
                            Navigator.of(context).pushNamed(AppRoutes.sincro);
                          },
                        ),
                      ],
                    ),

                    //itens do menu
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItemLocal extends StatelessWidget {
  const MenuItemLocal({
    Key? key,
    required this.ctrlApp,
  }) : super(key: key);

  final AppStore ctrlApp;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        menu.MenuItem(
          img: 'images/dav.png',
          header: 'DAV',
          botton: '',
          onPress: () {
            ctrlApp.searchBar.value = '';

            ctrlApp.searchBarWithCategoria.value = '';
            Navigator.of(context)
                .pushNamed(AppRoutes.clientesSelecionar, arguments: 'dav');
          },
        ),
        menu.MenuItem(
          img: 'images/preco.png',
          header: 'Consulta',
          botton: '',
          onPress: () {
            Navigator.of(context).pushNamed(AppRoutes.produtoPreco);
          },
        ),
      ],
    );
  }
}

class MenuItemRemote extends StatelessWidget {
  const MenuItemRemote({
    Key? key,
    required this.ctrlApp,
  }) : super(key: key);

  final AppStore ctrlApp;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() {
          return menu.MenuItem(
              img: 'images/pedidos.png',
              header: 'Pedidos',
              botton: '${ctrlApp.totalPedidos} pedidos',
              onPress: () {
                ctrlApp.searchBar.value = '';
                ctrlApp.searchBarWithCategoria.value = '';
                Navigator.of(context).pushNamed(AppRoutes.pedidoList);
              });
        }),
        menu.MenuItem(
            img: 'images/vender.png',
            header: 'Novo pedido',
            botton: '', //'Registrar um novo pedido',
            onPress: () {
              ctrlApp.searchBar.value = '';
              ctrlApp.searchBarWithCategoria.value = '';

              Navigator.of(context)
                  .pushNamed(AppRoutes.clientesSelecionar, arguments: 'pedido');
            }),
      ],
    );
  }
}

class MenuItemRow extends StatelessWidget {
  const MenuItemRow({
    Key? key,
    required this.ctrlApp,
  }) : super(key: key);

  final AppStore ctrlApp;

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() => menu.MenuItem(
                img: 'images/cliente.png',
                header: 'Clientes',
                botton: '${ctrlApp.totalClientes} clientes',
                onPress: () {
                  Navigator.of(context).pushNamed(AppRoutes.clienteList);
                },
              )),
          Obx(() {
            return menu.MenuItem(
                img: 'images/produto.png',
                header: 'Produtos',
                botton: '${ctrlApp.totalProdutos} produtos',
                onPress: () {
                  Navigator.of(context).pushNamed(AppRoutes.produtoList);
                });
          }),
        ]);
  }
}
