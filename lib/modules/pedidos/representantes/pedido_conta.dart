import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartvendas/app_routes.dart';
import 'package:smartvendas/app_store.dart';
import 'package:smartvendas/modules/datamodule/connection/dm.dart';
import 'package:smartvendas/modules/datamodule/connection/model/clientes.dart';
import 'package:smartvendas/modules/datamodule/connection/model/itens.dart';
import 'package:smartvendas/modules/datamodule/connection/model/pedido.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/itens_provider.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/pedidos_provider.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/produtos_provider.dart';
import 'package:smartvendas/modules/pedidos/representantes/pedido_share.dart';
import 'package:smartvendas/shared/header_main.dart';
import 'package:smartvendas/shared/variaveis.dart';
import 'package:jiffy/jiffy.dart';

class PedidoConta extends StatelessWidget {
  const PedidoConta({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Cliente lstCliente =
        ModalRoute.of(context)!.settings.arguments as Cliente;

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
              OutlinedButton.icon(
                label: const Text(
                  'Voltar',
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
                icon: const Icon(Icons.arrow_back_ios_outlined,
                    color: Colors.black54),
                onPressed: () {
                  Navigator.of(context).pop();
                  // .popUntil((ModalRoute.withName(AppRoutes.menu)));
                },
              ),
              const Spacer(),
              Obx(() => Text(
                    'Total:' + ctrlApp.totalGeralProdutosFmt.value,
                    style: const TextStyle(color: Colors.white),
                  )),
              const Spacer(),
              OutlinedButton.icon(
                label: const Text(
                  'Salvar',
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
                icon: const Icon(Icons.save, color: Colors.black54),
                onPressed: () async {
                  if (ctrlApp.totalGeralProdutos.value > 0) {
                    PedidosProvider.addUpdatePedido(Pedido(
                      ctrlApp.getPedidoId(),
                      ctrlApp.usuarioId.value.toString(),
                      ctrlApp.usuario.value.toString(),
                      lstCliente.id.toString(),
                      lstCliente.nome,
                      Jiffy().format('dd[/]MM[/]yyyy'),
                      ctrlApp.totalGeralProdutos.value,
                      ctrlApp.totalGeralProdutosFmt.value,
                      0,
                    ));
                    ProdutosProvider.loadProdutosConta().then((value) {
                      int i;
                      String id = ItensProvider.getItemId(
                          ctrlApp.usuarioId.value.toString());

                      for (i = 0; i < value.length; i++) {
                        ItensProvider.addUpdateItem(Item(
                            id + i.toString(),
                            ctrlApp.pedidoId.value,
                            value[i].id,
                            value[i].descricao,
                            value[i].unidade,
                            value[i].qte,
                            value[i].qteminatacado,
                            value[i].preco,
                            value[i].atacado,
                            value[i].valorfmt,
                            0));
                      }
                    });
                    await PedidosProvider.resetProdutos();
                    ctrlApp.totalPedidos.value =
                        await DmModule.getCount('pedidos');
                    Navigator.of(context)
                        .popUntil((ModalRoute.withName(AppRoutes.menu)));
                  }
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
                titulo: 'Fechamento',
                altura: 70,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ctrlApp.pedidoId.value.isNotEmpty
                        ? Text(
                            'Pedido:' + ctrlApp.pedidoId.value,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w900),
                            overflow: TextOverflow.ellipsis,
                          )
                        : const SizedBox(
                            height: 20,
                          ),
                    Text(
                      lstCliente.nome,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w900),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text('Data do Pedido: ' +
                        Jiffy().format('dd[/]MM[/]yyyy [às] hh:mm')),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ProdutosBuilder(ctrlApp: ctrlApp, isConta: true),
          ),
        ]),
      ),
    );
  }
}
