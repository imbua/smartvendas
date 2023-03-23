import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartvendas/app_store.dart';
import 'package:smartvendas/modules/datamodule/connection/model/itens.dart';
import 'package:smartvendas/shared/variaveis.dart';

class FuncoesTela {
  static void minus(List<Item> item, int index) {
    if (item[index].qtde > 0) {
      item[index].qtde = item[index].qtde - 1;
    }

    updateTotal(item);
  }

  static double updateTotal(List<Item> item) {
    double fval = 0;
    int i = 0;
    for (i = 0; i < item.length; i++) {
      if ((item[i].qtde < item[i].qteminatacado) ||
          (item[i].qteminatacado == 0)) {
        fval = fval + (item[i].valor * item[i].qtde);
      } else {
        fval = fval + (item[i].atacado * item[i].qtde);
      }
    }

    //  ItensBuilder().ctrlApp.totalGeralProdutosFmt.value = formatter.format(fval);
    //  ItensBuilder().ctrlApp.totalGeralProdutos.value = fval;
    return fval;
  }

  static void add(List<Item> item, int index) {
    item[index].qtde = item[index].qtde + 1;
    updateTotal(item);
  }
}

String getPrice(Item item) {
  double val = 0;
  if ((item.qtde < item.qteminatacado) || (item.qteminatacado == 0)) {
    val = item.valor;
  } else {
    val = item.atacado;
  }
  return '${formatter.format(val)} = ${formatter.format(item.qtde * val)}';
}

class ItensBuilder extends StatefulWidget {
  final List<Item> lstCliente;
  const ItensBuilder({Key? key, required this.lstCliente}) : super(key: key);

  @override
  State<ItensBuilder> createState() => _ItensBuilderState();
}

class _ItensBuilderState extends State<ItensBuilder> {
  AppStore ctrlApp = Get.find<AppStore>();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.lstCliente.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: ExpansionTileCard(
            leading: const CircleAvatar(
              foregroundImage: AssetImage("images/compras.png"),
              radius: 20,
              // backgroundImage: Image("images/compras.png"),
            ),
            title: Text(
              widget.lstCliente[index].descricao,
              style: const TextStyle(color: corText, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              children: [
                Row(
                  children: [
                    Text(
                        '${widget.lstCliente[index].totalfmt}   ${widget.lstCliente[index].unidade}',
                        style: const TextStyle(
                            fontSize: 12,
                            color: corText,
                            fontWeight: FontWeight.bold)),
                    const Spacer(),
                    (widget.lstCliente[index].qtde) > 0
                        ? Text(
                            '${widget.lstCliente[index].qtde}${widget.lstCliente[index].unidade} X ${getPrice(widget.lstCliente[index])}',
                            style: const TextStyle(
                                fontSize: 12,
                                color: corText,
                                fontWeight: FontWeight.bold))
                        : const Text(''),
                  ],
                ),
              ],
            ),
            children: [
              const Divider(
                thickness: 1,
                height: 1,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      FloatingActionButton(
                        heroTag: "minusconta$index",
                        onPressed: () {
                          setState(() {
                            FuncoesTela.minus(widget.lstCliente, index);
                            ctrlApp.totalGeralProdutos.value =
                                FuncoesTela.updateTotal(widget.lstCliente);

                            ctrlApp.totalGeralProdutosFmt.value = formatter
                                .format(ctrlApp.totalGeralProdutos.value);
                          });
                        },
                        backgroundColor: Colors.blueGrey,
                        child: const Icon(
                          Icons.remove_circle_outline,
                          size: 36,
                        ),
                      ),
                      const Spacer(),
                      Text(widget.lstCliente[index].qtde.toString(),
                          style: const TextStyle(fontSize: 60.0)),
                      const Spacer(),
                      FloatingActionButton(
                        heroTag: "addconta$index",
                        onPressed: () {
                          setState(() {
                            // FuncoesTela._n = widget.lstCliente[index].qtde;
                            FuncoesTela.add(widget.lstCliente, index);
                            ctrlApp.totalGeralProdutos.value =
                                FuncoesTela.updateTotal(widget.lstCliente);

                            ctrlApp.totalGeralProdutosFmt.value = formatter
                                .format(ctrlApp.totalGeralProdutos.value);
                          });
                        },
                        backgroundColor: Colors.blueGrey,
                        child: const Icon(
                          Icons.add_circle_outline,
                          size: 36,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  // return const Center(child: CircularProgressIndicator());

}
