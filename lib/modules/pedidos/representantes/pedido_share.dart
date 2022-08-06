import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:smartvendas/app_store.dart';
import 'package:smartvendas/modules/datamodule/connection/dm.dart';
import 'package:smartvendas/modules/datamodule/connection/dmremoto.dart';
import 'package:smartvendas/modules/datamodule/connection/model/produtos.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/produtos_provider.dart';
import 'package:smartvendas/shared/funcoes.dart';
import 'package:smartvendas/shared/number_editcustom.dart';
import 'package:smartvendas/shared/variaveis.dart';

class FuncoesTela {
  static double _n = 0;

  static void doUpdateProduto(
    List<Produto> produto,
    int index,
  ) async {
    await DmModule.updTable('update produtos set qte=' +
        FuncoesTela._n.toString() +
        ' where id="' +
        produto[index].id +
        '"');
    String _str = 'preco';
    if (produto[index].qteminatacado > 0) {
      if (_n >= produto[index].qteminatacado) {
        _str = 'atacado';
      }
    }

    ctrlApp.totalGeralProdutos.value =
        await DmModule.getTotal('produtos', 'qte*$_str');

    ctrlApp.totalGeralProdutosFmt.value =
        formatter.format(ctrlApp.totalGeralProdutos.value);
    produto[index].qte = _n;
  }

  static void minus(List<Produto> produto, int index) {
    if (FuncoesTela._n > 0) {
      FuncoesTela._n = produto[index].qte - 1;
      doUpdateProduto(produto, index);
    }
  }

  static void add(List<Produto> produto, int index) {
    FuncoesTela._n = produto[index].qte + 1;
    doUpdateProduto(produto, index);
  }

  static void updateField(List<Produto> produto, int index, String qte) {
    FuncoesTela._n = Funcoes.strToFloat(qte);
    doUpdateProduto(produto, index);
  }

  // static Future<List<Produto>> loadBuilder(bool isconta) {
  //   return isconta
  //       ? ProdutosProvider.loadProdutosConta()
  //       : ProdutosProvider.loadProdutos(ctrlApp.searchBar.value);
  // }
  static Future<List<Produto>> loadBuilder(bool isconta) {
    return isconta
        ? ProdutosProvider.loadProdutosConta()
        : ProdutosProvider.loadProdutos(
            ctrlApp.searchBar.value, ctrlApp.searchBarWithCategoria.value);
  }
}

class ProdutosBuilder extends StatefulWidget {
  final bool isConta;
  final AppStore ctrlApp;
  const ProdutosBuilder(
      {Key? key, required this.ctrlApp, required this.isConta})
      : super(key: key);

  @override
  State<ProdutosBuilder> createState() => _ProdutosBuilderState();
}

class _ProdutosBuilderState extends State<ProdutosBuilder> {
  final List<TextEditingController> _controllers = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Produto>>(
        future: FuncoesTela.loadBuilder(widget.isConta),
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<Produto> lstProduto = snapshot.data;

          if (!snapshot.hasData) {
            // || snapshot.data.lenght == 0
            return const Center(
              child: Text('Nenhum registro encontrado!'),
            );
          } else {
            return ListView.builder(
              itemCount: lstProduto.length,
              itemBuilder: (BuildContext context, int index) {
                _controllers.add(TextEditingController());

                return Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: ExpansionTileCard(
                    // leading: const CircleAvatar(
                    //   foregroundImage: AssetImage("images/compras.png"),
                    //   radius: 20,
                    //   // backgroundImage: Image("images/compras.png"),
                    // ),
                    // finalPadding: EdgeInsets.only(bottom: 1),
                    // initialPadding: EdgeInsets.only(bottom: 1),
                    // contentPadding: EdgeInsets.only(bottom: 1),
                    title: Text(
                      lstProduto[index].descricao,
                      style: const TextStyle(color: corText, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                                lstProduto[index].valorfmt +
                                    '' +
                                    lstProduto[index].unidade,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: corText,
                                    fontWeight: FontWeight.bold)),
                            const Spacer(),
                            Text(
                              '  Barras: ' + lstProduto[index].barras,
                              style: const TextStyle(
                                  color: corText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11),
                            ),
                          ],
                        ),
                        (lstProduto[index].atacado > 0 ||
                                lstProduto[index].qte > 0)
                            ? Row(
                                children: [
                                  lstProduto[index].atacado > 0
                                      ? Text(
                                          'Vr.Atac.:' +
                                              lstProduto[index].atacadofmt,
                                          style: const TextStyle(fontSize: 15),
                                        )
                                      : const SizedBox(
                                          width: 1,
                                        ),
                                  const Spacer(),
                                  (lstProduto[index].qte) > 0
                                      ? Text(
                                          lstProduto[index].qte.toString() +
                                              ' X R\$' +
                                              formatter.format(
                                                  Funcoes.getValorProduto(
                                                      lstProduto[index])) +
                                              ' = ' +
                                              formatter.format(
                                                  lstProduto[index].qte *
                                                      Funcoes.getValorProduto(
                                                          lstProduto[index])),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: corText,
                                              fontWeight: FontWeight.bold))
                                      : const Text(''),
                                ],
                              )
                            : const SizedBox(
                                height: 1,
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              lstProduto[index].imagem.isNotEmpty
                                  ? SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Image.memory(
                                        Funcoes.getImagenBase64(
                                            lstProduto[index].imagem),
                                      ),
                                    )
                                  : const SizedBox(
                                      height: 50,
                                      width: 50,
                                    ),
                              const SizedBox(
                                width: 20,
                              ),
                              FloatingActionButton(
                                heroTag: "minusconta" + index.toString(),
                                onPressed: () {
                                  setState(() {
                                    FuncoesTela._n = lstProduto[index].qte;
                                    FuncoesTela.minus(lstProduto, index);
                                    _controllers[index].text =
                                        FuncoesTela._n.toString();
                                  });
                                },
                                child: const Icon(
                                  Icons.remove_circle_outline,
                                  size: 36,
                                ),
                                backgroundColor: Colors.blueGrey,
                              ),
                              const Spacer(flex: 3),
                              NumberEditCustom(
                                edController: _controllers[index],
                                fonteSize: 30,
                                fieldSize: 50,
                                fieldMaxLength: 5,
                                // edFocusNode: edQte,
                                textFlex: 30,
                                caption: lstProduto[index].qte.toString(),
                                onComplete: () {
                                  setState(() {
                                    lstProduto[index].qte = Funcoes.strToFloat(
                                        _controllers[index].text);
                                    FuncoesTela.updateField(lstProduto, index,
                                        _controllers[index].text);
                                    _controllers[index].text =
                                        FuncoesTela._n.toString();
                                  });
                                },
                                textInputType:
                                    const TextInputType.numberWithOptions(
                                        decimal: false),
                              ),
                              const Spacer(),
                              FloatingActionButton(
                                heroTag: "addconta" + index.toString(),
                                onPressed: () {
                                  setState(() {
                                    FuncoesTela._n = lstProduto[index].qte;
                                    FuncoesTela.add(lstProduto, index);
                                    _controllers[index].text =
                                        FuncoesTela._n.toString();
                                  });
                                },
                                child: const Icon(
                                  Icons.add_circle_outline,
                                  size: 36,
                                ),
                                backgroundColor: Colors.blueGrey,
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
        });
  }
}
