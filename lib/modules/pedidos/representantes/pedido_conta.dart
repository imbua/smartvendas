import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartvendas/app_routes.dart';
import 'package:smartvendas/app_store.dart';
import 'package:smartvendas/modules/datamodule/connection/dm.dart';
import 'package:smartvendas/modules/datamodule/connection/dmremoto.dart';
import 'package:smartvendas/modules/datamodule/connection/model/itens.dart';
import 'package:smartvendas/modules/datamodule/connection/model/pedido.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/itens_provider.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/pedidos_provider.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/produtos_provider.dart';
import 'package:smartvendas/modules/pedidos/representantes/pedido_share.dart';
import 'package:smartvendas/modules/pedidos/representantes/report/pdf_invoice.dart';
import 'package:smartvendas/shared/funcoes.dart';

import 'package:smartvendas/shared/header_main.dart';
import 'package:smartvendas/shared/variaveis.dart';
import 'package:jiffy/jiffy.dart';

String _observacao = "";

class PedidoConta extends StatelessWidget {
  const PedidoConta({Key? key}) : super(key: key);

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      );

  @override
  Widget build(BuildContext context) {
    final PedidoArguments args =
        ModalRoute.of(context)!.settings.arguments as PedidoArguments;
    // final TextEditingController _observacaoController = TextEditingController();

    RxString? fitemSelecionado = "".obs;

    final msg = ScaffoldMessenger.of(context);

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
                    'Total:${ctrlApp.totalGeralProdutosFmt.value}',
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
                  if (fitemSelecionado.value == '') {
                    msg.showSnackBar(
                      const SnackBar(
                        content: Text('Escolha a forma de pagamento'),
                      ),
                    );
                    throw "Escolha a forma de pagamento";
                  }

                  if (ctrlApp.totalGeralProdutos.value > 0) {
                    final List<Pedido> fpedido = [];
                    final List<Item> lstItens = [];

                    fpedido.add(
                      Pedido(
                        ctrlApp.getPedidoId(),
                        ctrlApp.usuarioId.value.toString(),
                        ctrlApp.usuario.value.toString(),
                        args.lstCliente.id.toString(),
                        args.lstCliente.nome,
                        Jiffy().format('dd[/]MM[/]yyyy'),
                        ctrlApp.totalGeralProdutos.value,
                        ctrlApp.totalGeralProdutosFmt.value,
                        0,
                        fitemSelecionado.value,
                        _observacao,
                      ),
                    );
                    int i;
                    String id = ItensProvider.getItemId(
                        ctrlApp.usuarioId.value.toString());

                    final produtos = await ProdutosProvider.loadProdutosConta();
                    for (i = 0; i < produtos.length; i++) {
                      lstItens.add(Item(
                          id + i.toString(),
                          ctrlApp.pedidoId.value,
                          produtos[i].id,
                          produtos[i].descricao,
                          produtos[i].unidade,
                          produtos[i].qte,
                          produtos[i].qteminatacado,
                          produtos[i].preco,
                          produtos[i].atacado,
                          produtos[i].valorfmt,
                          0));
                    }

                    if (args.origem == 'dav') {
                      final bool resultado = await sendDAV(
                          context, args.lstCliente, fpedido, lstItens);
                      if (resultado == true) {
                        PedidosProvider.resetProdutos();

                        await PdfInvoice(
                                itens: lstItens,
                                pedido: fpedido[0],
                                titulo: 'DAV')
                            .generate(context);

                        Navigator.of(context)
                            .popUntil((ModalRoute.withName(AppRoutes.menu)));
                      }
                    } else {
                      PedidosProvider.addUpdatePedido(fpedido[0]);
                      // final produtos = await  ProdutosProvider.loadProdutosConta().then((value) {
                      for (var item in lstItens) {
                        if (item.qtde > 0) {
                          ItensProvider.addUpdateItem(item);
                        }
                      }
                      await PedidosProvider.resetProdutos();
                      DmModule.getCount('pedidos').then((resultado) =>
                          ctrlApp.totalPedidos.value = resultado);
                      await PdfInvoice(
                              itens: lstItens,
                              pedido: fpedido[0],
                              titulo: 'PEDIDO')
                          .generate(context);
                      Navigator.of(context)
                          .popUntil((ModalRoute.withName(AppRoutes.menu)));
                    }
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
                            'Pedido:${ctrlApp.pedidoId.value}',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w900),
                            overflow: TextOverflow.ellipsis,
                          )
                        : const SizedBox(
                            height: 20,
                          ),
                    Text(
                      args.lstCliente.nome,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w900),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text('Data do Pedido: ${Jiffy().format('dd[/]MM[/]yyyy [às] hh:mm')}'),
                        const Spacer(),
                        Text(
                          args.origem,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
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
            child: ProdutosBuilder(ctrlApp: ctrlApp, origem: 'conta'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    // minWidth: size.width,
                    // maxWidth: size.width,
                    minHeight: 25.0,
                    maxHeight: 135.0,
                  ),
                  child: Scrollbar(
                    child: TextFormField(
                      // controller: _observacaoController,

                      expands: true,
                      maxLength: 200,

                      maxLines: null,
                      minLines: null,
                      initialValue: "",
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        labelText: "Observação",
                      ),
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        // _observacaoController.text = value;
                        _observacao = value;
                        // FocusScope.of(context).nextFocus();
                      },
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 8,
              ),
              Container(
                // alignment: Alignment.topCenter,
                height: 40,

                // color: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                      color: corBotao, style: BorderStyle.solid, width: 1),
                ),
                width: MediaQuery.of(context).size.width - 100,
                child: Obx(
                  () => DropdownButton<String>(
                    dropdownColor: Colors.green[100],
                    // style: TextStyle(),
                    isExpanded: true,
                    hint: const Text('Forma de pagamento'),
                    items: ctrlApp.lstFormaPgto.map(buildMenuItem).toList(),
                    value: fitemSelecionado.value == ""
                        ? null
                        : fitemSelecionado.value,
                    onChanged: (itemSelecionado) {
                      fitemSelecionado.value = itemSelecionado!;
                    },
                    focusColor: Colors.black,
                    selectedItemBuilder: (BuildContext context) {
                      return ctrlApp.lstFormaPgto.map<Widget>((String item) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.centerLeft,
                          height: 20,
                          child: Text(item),
                        );
                      }).toList();
                    },

                    // selectedItemBuilder: fitemSelecionado,
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
