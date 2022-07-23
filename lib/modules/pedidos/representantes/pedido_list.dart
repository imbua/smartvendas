import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:smartvendas/app_routes.dart';
import 'package:smartvendas/app_store.dart';
import 'package:smartvendas/modules/datamodule/connection/dm.dart';
import 'package:smartvendas/modules/datamodule/connection/model/itens.dart';
import 'package:smartvendas/modules/datamodule/connection/model/pedido.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/itens_provider.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/pedidos_provider.dart';
import 'package:smartvendas/shared/botao_customizado.dart';
import 'package:smartvendas/shared/header_main.dart';
import 'package:smartvendas/shared/variaveis.dart';

class PedidoListagem extends StatefulWidget {
  const PedidoListagem({Key? key}) : super(key: key);

  @override
  State<PedidoListagem> createState() => _PedidoListagemState();
}

class _PedidoListagemState extends State<PedidoListagem> {
  @override
  Widget build(BuildContext context) {
    AppStore ctrlApp = Get.find<AppStore>();
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
              const Spacer(),
              Obx(() => Text(
                    'Total:' + ctrlApp.totalGeralProdutosFmt.value,
                    style: const TextStyle(color: Colors.white),
                  )),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
        body: Column(children: [
          Stack(
            children: [
              const HeaderMain(
                iconeMain: Icons.shopping_cart,
                titulo: 'Pedidos',
                altura: 70,
              ),
              Positioned(
                top: 15,
                left: 15,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                  iconSize: 30,
                  color: Colors.white,
                ),
              ),
              Positioned(
                top: 30,
                right: 15,
                child: Text(
                  ctrlApp.totalPedidos.value.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<Pedido>>(
                future: PedidosProvider.loadPedidos(''),
                initialData: const [],
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  // lstPedido = List<Pedido>.from(snapshot.data).obs;
                  List<Pedido> lstPedido = snapshot.data;
                  if (!snapshot.hasData) {
                    // || snapshot.data.lenght == 0
                    return const Center(
                      child: Text('Nenhum registro encontrado!'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: lstPedido.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Slidable(
                              // The start action pane is the one at the left or the top side.

                              key: Key(lstPedido[index].id),
                              child: Container(
                                color: Colors.white,
                                child: ExpansionTileCard(
                                  leading: const CircleAvatar(
                                    child: Icon(
                                      Icons.account_circle,
                                      size: 40,
                                    ),
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            lstPedido[index].id.toString(),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: corText,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                          Text(
                                            lstPedido[index]
                                                .formapgto
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: corText,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(
                                          lstPedido[index]
                                              .nomecliente
                                              .toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        lstPedido[index].datapedido.toString(),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Spacer(),
                                      Text(
                                        lstPedido[index].totalfmt,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  children: [
                                    BotaoInfo(
                                      caption: 'Alterar',
                                      iconeBotaoBackGround: Icons.change_circle,
                                      onPress: () async {
                                        ctrlApp.pedidoId.value =
                                            lstPedido[index].id;

                                        ItensProvider.loaditens(
                                                ctrlApp.pedidoId.value)
                                            .then((items) {
                                          List<Item> itemslist = items;
                                          PedidosProvider.getQueryPedido(
                                                  ctrlApp.pedidoId.value)
                                              .then((value) {
                                            Navigator.of(context)
                                                .pushNamed(
                                                    AppRoutes.pedidoAlterar,
                                                    arguments: itemslist)
                                                .then((value) {
                                              lstPedido[index].total = ctrlApp
                                                  .totalGeralProdutos.value;
                                              lstPedido[index].totalfmt =
                                                  ctrlApp.totalGeralProdutosFmt
                                                      .value;
                                              setState(() {});
                                            });
                                          });
                                          // List<Item> itens = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              startActionPane: ActionPane(
                                // A motion is a widget used to control how the pane animates.
                                motion: const ScrollMotion(),

                                // A pane can dismiss the Slidable.
                                dismissible: DismissiblePane(
                                  onDismissed: (() async {
                                    String _id = lstPedido[index].id.toString();
                                    await DmModule.deletaPedido(_id);
                                  }),
                                ),

                                // All actions are defined in the children parameter.
                                children: [
                                  // A SlidableAction can have an icon and/or a label.

                                  SlidableAction(
                                    onPressed: ((context) async {
                                      String _id =
                                          lstPedido[index].id.toString();
                                      await DmModule.deletaPedido(_id);
                                    }),
                                    backgroundColor: const Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Excluir',
                                  ),
                                ],
                              ),
                            ));
                      },
                    );
                  }
                  // return const Center(child: CircularProgressIndicator());
                }),
          ),
        ]),
      ),
    );
  }
}
