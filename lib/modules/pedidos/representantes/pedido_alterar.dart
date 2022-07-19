import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartvendas/app_store.dart';
import 'package:smartvendas/modules/datamodule/connection/model/itens.dart';
import 'package:smartvendas/modules/datamodule/connection/model/pedido.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/itens_provider.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/pedidos_provider.dart';
import 'package:smartvendas/modules/pedidos/representantes/pedido_alterarext.dart';
import 'package:smartvendas/shared/header_main.dart';
import 'package:smartvendas/shared/variaveis.dart';

class PedidoAlterar extends StatelessWidget {
  const PedidoAlterar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Item> lstCliente =
        ModalRoute.of(context)!.settings.arguments as List<Item>;
    // PedidosProvider.getQueryPedido(lstCliente[0].idpedido);
    List<Pedido> lstPedido = PedidosProvider.pedido;

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
                    lstPedido[0].total = ctrlApp.totalGeralProdutos.value;
                    lstPedido[0].totalfmt = ctrlApp.totalGeralProdutosFmt.value;

                    PedidosProvider.addUpdatePedido(lstPedido[0]);

                    ItensProvider.doSetTable(lstCliente);
                    Navigator.of(context).pop();
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
                titulo: 'Alterar',
                altura: 70,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pedido:' + ctrlApp.pedidoId.value,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w900),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      lstPedido[0].nomecliente,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w900),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text('Data do Pedido: ' + lstPedido[0].datapedido),
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
            child: ItensBuilder(
              lstCliente: lstCliente,
            ),
          ),
        ]),
      ),
    );
  }
}
