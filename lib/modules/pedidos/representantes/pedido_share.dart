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
  static String setUnd(Produto produto, String origem) {
    if (origem == 'cotacao') {
      return '${produto.volume}(${produto.qtevolume})';
    } else {
      return produto.unidade;
    }
  }

  static String setPreco(Produto produto, String origem) {
    if (origem == 'cotacao') {
      double valor = produto.custo * produto.qtevolume;
      return (formatter.format(valor));
    } else {
      return produto.valorfmt;
    }
  }

  static void doUpdateProduto(
      List<Produto> produto, int index, String origem) async {
    await DmModule.updTable('update produtos set qte=${FuncoesTela._n} where id="${produto[index].id}"');
    String str = 'preco';
    if (origem == 'cotacao') {
      str = 'custo*qtevolume';
    } else {
      if (produto[index].qteminatacado > 0) {
        if (_n >= produto[index].qteminatacado) {
          str = 'atacado';
        }
      }
    }

    ctrlApp.totalGeralProdutos.value =
        await DmModule.getTotal('produtos', 'qte*$str');

    ctrlApp.totalGeralProdutosFmt.value =
        formatter.format(ctrlApp.totalGeralProdutos.value);
    produto[index].qte = _n;
  }

  static void minus(List<Produto> produto, int index, String origem) {
    if (FuncoesTela._n > 0) {
      FuncoesTela._n = produto[index].qte - 1;
      if (FuncoesTela._n < 0) {
        FuncoesTela._n = 0;
      }
      doUpdateProduto(produto, index, origem);
    }
  }

  static void add(List<Produto> produto, int index, String origem) {
    FuncoesTela._n = produto[index].qte + 1;
    doUpdateProduto(produto, index, origem);
  }

  static void updateField(
      List<Produto> produto, int index, String qte, String origem) {
    FuncoesTela._n = Funcoes.strToFloat(qte);
    doUpdateProduto(produto, index, origem);
  }

  // static Future<List<Produto>> loadBuilder(bool isconta) {
  //   return isconta
  //       ? ProdutosProvider.loadProdutosConta()
  //       : ProdutosProvider.loadProdutos(ctrlApp.searchBar.value);
  // }
  static Future<List<Produto>> loadBuilder(String origem) {
    if (origem == 'conta') {
      return ProdutosProvider.loadProdutosConta();
    } else {
      if (origem == 'cotacao') {
        return ProdutosProvider.loadProdutosCotacao(
            ctrlApp.searchBar.value, ctrlApp.searchBarWithCategoria.value);
      } else {
        return ProdutosProvider.loadProdutos(
            ctrlApp.searchBar.value, ctrlApp.searchBarWithCategoria.value);
      }
    }
  }
}

class ProdutosBuilder extends StatefulWidget {
  final String origem;
  final AppStore ctrlApp;
  const ProdutosBuilder({Key? key, required this.ctrlApp, required this.origem})
      : super(key: key);

  @override
  State<ProdutosBuilder> createState() => _ProdutosBuilderState();
}

class _ProdutosBuilderState extends State<ProdutosBuilder> {
  final List<TextEditingController> _controllers = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Produto>>(
        future: FuncoesTela.loadBuilder(widget.origem),
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
                                '${FuncoesTela.setPreco(
                                        lstProduto[index], widget.origem)}  ( ${lstProduto[index]
                                        .estoque
                                        .toStringAsFixed(0)} ${FuncoesTela.setUnd(
                                        lstProduto[index], 'produto')})',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: corText,
                                    fontWeight: FontWeight.bold)),
                            const Spacer(),
                            Text(
                              '  Barras: ${lstProduto[index].barras}',
                              style: const TextStyle(
                                  color: corText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            if (lstProduto[index].atacado > 0 &&
                                widget.origem != 'cotacao')
                              Text(
                                'Atac.:${lstProduto[index].atacadofmt}(${lstProduto[index].qteminatacado} ${FuncoesTela.setUnd(
                                        lstProduto[index], 'produto')})',
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              )
                            else
                              const SizedBox(width: 1),
                            const Spacer(),
                            (lstProduto[index].qte) > 0
                                ? Text(
                                    '${formatter.format(lstProduto[index].qte)}${FuncoesTela.setUnd(
                                            lstProduto[index], widget.origem)} X R\$${formatter.format(
                                            Funcoes.getValorProduto(
                                                lstProduto[index],
                                                widget.origem))} = ${formatter.format(lstProduto[index].qte *
                                            Funcoes.getValorProduto(
                                                lstProduto[index],
                                                widget.origem))}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: corText,
                                        fontWeight: FontWeight.bold))
                                : const Text(''),
                          ],
                        ),

                        // const Spacer(),
                        // Text(
                        //   '  Estoque: ' + lstProduto[index].estoque.toString(),
                        //   style: const TextStyle(
                        //       color: corText,
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 11),
                        // ),
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
                                heroTag: "minusconta$index",
                                onPressed: () {
                                  setState(() {
                                    FuncoesTela._n = lstProduto[index].qte;
                                    FuncoesTela.minus(
                                        lstProduto, index, widget.origem);
                                    _controllers[index].text =
                                        FuncoesTela._n.toString();
                                  });
                                },
                                backgroundColor: Colors.blueGrey,
                                child: const Icon(
                                  Icons.remove_circle_outline,
                                  size: 36,
                                ),
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
                                    FuncoesTela.updateField(
                                        lstProduto,
                                        index,
                                        _controllers[index].text,
                                        widget.origem);
                                    _controllers[index].text =
                                        FuncoesTela._n.toString();
                                  });
                                },
                                textInputType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                              ),
                              const Spacer(),
                              FloatingActionButton(
                                heroTag: "addconta$index",
                                onPressed: () {
                                  setState(() {
                                    FuncoesTela._n = lstProduto[index].qte;
                                    FuncoesTela.add(
                                        lstProduto, index, widget.origem);
                                    _controllers[index].text =
                                        FuncoesTela._n.toString();
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
        });
  }
}
