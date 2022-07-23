// import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smartvendas/app_routes.dart';
import 'package:smartvendas/app_store.dart';
import 'package:smartvendas/modules/datamodule/connection/dmremoto.dart';
import 'package:smartvendas/modules/datamodule/connection/model/categoria.dart';
import 'package:smartvendas/modules/datamodule/connection/model/clientes.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/produtos_provider.dart';
import 'package:smartvendas/shared/funcoes.dart';
import 'package:smartvendas/modules/pedidos/representantes/pedido_share.dart';
import 'package:smartvendas/shared/header_main.dart';
import 'package:smartvendas/shared/variaveis.dart';
import 'package:jiffy/jiffy.dart';

class PedidoProduto extends StatelessWidget {
  const PedidoProduto({Key? key}) : super(key: key);
  //  BackButtonInterceptor.add(myInterceptor);

  @override
  Widget build(BuildContext context) {
    final Cliente lstCliente =
        ModalRoute.of(context)!.settings.arguments as Cliente;

    AppStore ctrlApp = Get.find<AppStore>();
    return WillPopScope(
      onWillPop: () {
        return Future.value(false); // if true allow back else block it
      },
      child: PedidoProdutosControl(
        ctrlApp: ctrlApp,
        lstCliente: lstCliente,
      ),
    );
  }
}

class PedidoProdutosControl extends StatefulWidget {
  const PedidoProdutosControl({
    Key? key,
    required this.ctrlApp,
    required this.lstCliente,
  }) : super(key: key);

  final AppStore ctrlApp;
  final Cliente lstCliente;

  @override
  State<PedidoProdutosControl> createState() => _PedidoProdutosControlState();
}

// _listCategorias(BuildContext context, Function statechange) {
//   List<Categoria> lstCategoria = ctrlApp.lstCategoria;

//   return SizedBox(
//     width: MediaQuery.of(context).size.width - 85,
//     child: SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Wrap(
//         direction: Axis.horizontal,
//         children: List.generate(lstCategoria.length, (index) {
//           return Padding(
//             padding: const EdgeInsets.only(left: 8.0, top: 2, bottom: 2),
//             child: TextButton(
//               onPressed: () {
//                 // final String _str = ctrlApp.searchBar.value;

//                 ctrlApp.searchBarWithCategoria.value = lstCategoria[index].id;
//                 statechange();
//                 // ctrlApp.searchBar.value = '';
//                 // ctrlApp.searchBar.value = _str;
//               },
//               style: ButtonStyle(
//                   foregroundColor: MaterialStateProperty.all(Colors.white),
//                   backgroundColor: MaterialStateProperty.all(corBotao)),
//               child: Text(lstCategoria[index].descricao),
//             ),
//           );
//         }),
//       ),
//     ),
//   );
// }

class _PedidoProdutosControlState extends State<PedidoProdutosControl> {
  final TextEditingController _edSearch = TextEditingController();
  Categoria _itemSelecionado = Categoria('', '');

  DropdownMenuItem<Categoria> buildMenuItem(Categoria item) => DropdownMenuItem(
        value: item,
        child: Text(item.descricao),
      );

  void mudaEstado() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: corRodape,
          child: Row(
            children: [
              const SizedBox(
                height: 40,
                width: 10,
              ),
              OutlinedButton.icon(
                label: const Text(
                  'Cancelar',
                  style: TextStyle(
                      color: Colors.white70,
                      fontFamily: "RobotoCondensed",
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  side: const BorderSide(width: 1, color: Colors.black87),
                ),
                icon: const Icon(Icons.cancel, color: Colors.black54),
                onPressed: () {
                  if (widget.ctrlApp.totalGeralProdutos.value > 0) {
                    ProdutosProvider.resetProdutos;
                    widget.ctrlApp.totalGeralProdutos.value = 0;
                    widget.ctrlApp.totalGeralProdutosFmt.value = '';
                  }

                  // Modular.to.popUntil(ModalRoute.withName(AppRoutes.menu));
                  Navigator.of(context)
                      .popUntil((ModalRoute.withName(AppRoutes.menu)));
                },
              ),
              const Spacer(),
              Obx(() => Text(
                    'Total:' + widget.ctrlApp.totalGeralProdutosFmt.value,
                    style: const TextStyle(color: Colors.white),
                  )),
              const Spacer(),
              OutlinedButton.icon(
                label: const Text(
                  'Conta',
                  style: TextStyle(
                      color: Colors.white70,
                      fontFamily: "RobotoCondensed",
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  side: const BorderSide(width: 1, color: Colors.black87),
                ),
                icon: const Icon(Icons.shopping_cart, color: Colors.black54),
                onPressed: () async {
                  if (widget.ctrlApp.totalGeralProdutos.value > 0) {
                    await Navigator.of(context).pushNamed(AppRoutes.pedidoConta,
                        arguments:
                            PedidoArguments(widget.lstCliente, 'PEDIDO'));
                  }
                  setState(() {});
                },
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
        body: Column(children: [
          Stack(
            children: [
              const HeaderInput(
                iconeMain: Icons.local_shipping,
                titulo: 'Pedido',
                altura: 70,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.lstCliente.nome,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w900),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Usuário: ' + widget.ctrlApp.usuario.value,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text('Data do Pedido: ' +
                        Jiffy().format('dd[/]MM[/]yyyy [às] hh:mm')),
                  ],
                ),
              ),
            ],
          ),
          // Categorias(),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 2, bottom: 2),
                child: TextButton(
                  onPressed: () {
                    ctrlApp.searchBarWithCategoria.value = '';
                    _itemSelecionado = Categoria('', '');

                    setState(() {});
                  },
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 97, 111, 134))),
                  child: const Text('Todos'),
                ),
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width - 85,
                child: DropdownButton<Categoria>(
                  items: ctrlApp.lstCategoria.map(buildMenuItem).toList(),
                  value: _itemSelecionado.id == "" ? null : _itemSelecionado,
                  onChanged: (itemSelecionado) {
                    ctrlApp.searchBarWithCategoria.value = itemSelecionado!.id;
                    _itemSelecionado = itemSelecionado;

                    mudaEstado();
                  },
                  // selectedItemBuilder: _itemSelecionado,
                ),
              ),

              // _listCategorias(context, mudaEstado),
            ],
          ),
          SizedBox(
            height: 60,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextField(
                  controller: _edSearch,
                  style: const TextStyle(color: corText, fontSize: 15),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    border: InputBorder.none,
                    fillColor: corText.withOpacity(0.2),
                    filled: true,
                    hintText: 'Localizar',
                    prefix: const Icon(
                      Icons.search,
                      color: corText,
                      size: 20,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _edSearch.clear();
                          ctrlApp.searchBar.value = '';
                          FocusScope.of(context).unfocus();
                        });
                      },
                      child: const Icon(FontAwesomeIcons.eraser,
                          color: corText, size: 30),
                    ),
                  ),
                  onChanged: (value) async {
                    setState(() {
                      ctrlApp.searchBar.value = value;
                    });
                  },
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                )),
          ),
          Expanded(
            child: ProdutosBuilder(ctrlApp: widget.ctrlApp, isConta: false),
          ),
        ]),
      ),
    );
  }
}
