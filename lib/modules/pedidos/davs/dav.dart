import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:smartvendas/app_routes.dart';
import 'package:smartvendas/app_store.dart';
import 'package:smartvendas/modules/datamodule/connection/dm.dart';
import 'package:smartvendas/modules/datamodule/connection/dmremoto.dart';
import 'package:smartvendas/modules/datamodule/connection/model/clientes.dart';
import 'package:smartvendas/modules/datamodule/connection/model/produtos.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/produtos_provider.dart';
import 'package:smartvendas/shared/funcoes.dart';
import 'package:smartvendas/shared/header_main.dart';
import 'package:smartvendas/shared/number_editcustom.dart';
import 'package:smartvendas/shared/show_message.dart';
import 'package:smartvendas/shared/variaveis.dart';

class FuncoesTela {
  static double _n = 0;

  static void setTotal(String campo) async {
    ctrlApp.totalGeralProdutos.value =
        await DmModule.getTotal('produtos', 'qte*$campo');

    ctrlApp.totalGeralProdutosFmt.value =
        formatter.format(ctrlApp.totalGeralProdutos.value);
    // produto.qte = _n;
  }

  static void doUpdateProduto(produto) async {
    var _str = '';
    await DmModule.updTable('update produtos set qte=qte+' +
        FuncoesTela._n.toString() +
        ' where id="' +
        produto.id +
        '"');
    _str = getFieldValor(produto);
    setTotal(_str);
  }

  static void doExcluiItem(Produto produto) async {
    var _str = '';
    await DmModule.updTable('update produtos set qte=0'
            ' where id="' +
        produto.id +
        '"');
    _str = getFieldValor(produto);
    setTotal(_str);
  }

  static String getFieldValor(Produto produto) {
    String _str = 'preco';
    if (produto.qteminatacado > 0) {
      if (produto.qte >= produto.qteminatacado) {
        _str = 'atacado';
      }
    }
    return _str;
    // produto.qte = _n;
  }

  void minus(List<Produto> produto, int index) {
    if (FuncoesTela._n > 0) {
      FuncoesTela._n = produto[index].qte - 1;
      // doUpdateProduto(produto[index]);
    }
  }

  static minusEdit(Produto produto) {
    if (produto.id.isNotEmpty) {
      if (produto.qte > 0) {
        produto.qte = produto.qte - 1;
        FuncoesTela._n = produto.qte;
        // doUpdateProduto(produto);
      }
    }
  }

  void add(List<Produto> produto, int index) {
    FuncoesTela._n = produto[index].qte + 1;
    produto[index].qte = FuncoesTela._n;
    // doUpdateProduto(produto[index]);
  }

  static addEdit(Produto produto) {
    if (produto.id.isNotEmpty) {
      produto.qte = produto.qte + 1;
      FuncoesTela._n = produto.qte;
      // doUpdateProduto(produto);
    }
  }

  void updateField(List<Produto> produto, int index, String qte) {
    FuncoesTela._n = Funcoes.strToFloat(qte);
    produto[index].qte = FuncoesTela._n;

    // FuncoesTela._n = Funcoes.strToFloat(qte);
    // doUpdateProduto(produto[index]);
  }

  static updateFieldEdit(Produto produto, String qte) {
    FuncoesTela._n = Funcoes.strToFloat(qte);
    produto.qte = FuncoesTela._n;

    // doUpdateProduto(produto);
  }

  // static Future<List<Produto>> loadBuilder(bool isconta) {
  //   return isconta
  //       ? ProdutosProvider.loadProdutosConta()
  //       : ProdutosProvider.loadProdutos(ctrlApp.searchBar.value);
  // }
  static Future<List<Produto>> loadBuilder(bool isconta) {
    return isconta
        ? ProdutosProvider.loadProdutosConta()
        : ProdutosProvider.loadProdutos(ctrlApp.searchBar.value, '');
  }
}

class DAV extends StatelessWidget {
  const DAV({Key? key}) : super(key: key);
  //  BackButtonInterceptor.add(myInterceptor);

  @override
  Widget build(BuildContext context) {
    final Cliente lstCliente =
        ModalRoute.of(context)!.settings.arguments as Cliente;

    AppStore ctrlApp = Get.find<AppStore>();
    ctrlApp.searchBar.value = '';
    return WillPopScope(
      onWillPop: () {
        return Future.value(false); // if true allow back else block it
      },
      child: DAVControl(
        ctrlApp: ctrlApp,
        lstCliente: lstCliente,
      ),
    );
  }
}

class DAVControl extends StatefulWidget {
  const DAVControl({
    Key? key,
    required this.ctrlApp,
    required this.lstCliente,
  }) : super(key: key);

  final AppStore ctrlApp;
  final Cliente lstCliente;

  @override
  State<DAVControl> createState() => _DAVControlState();
}

class _DAVControlState extends State<DAVControl> {
  List<Produto> lstProdutoList = [];
  Produto lstProduto = Produto.clear();
  final TextEditingController _edSearchNome = TextEditingController();
  final TextEditingController _edQte = TextEditingController();
  final FocusNode _focusProduto = FocusNode();

  void submitData(String value) async {
    double _qte = 1;
    double _valor = 0;
    String _produto = value;
    String _str;
    if (_produto.length > 7) {
      _str = _produto.substring(7, _produto.length - 1);
      // print(_str);
      if (_produto.substring(0, 1) == '2') {
        //e barras
        _produto = _produto.substring(1, 7); //barras
        _valor = Funcoes.strToFloat(_str) / 100;
      }

      lstProdutoList = await ProdutosProvider.loadProdutos(_produto, '');
      lstProduto = Produto.clear();
      if (lstProdutoList.isNotEmpty) {
        FlutterBeep.beep(true);
        //se houve barras
        if (_valor > 0) {
          _qte = double.parse(
              (_valor / lstProdutoList[0].preco).toStringAsFixed(3));
        }

        lstProdutoList[0].qte = _qte;
        lstProduto = lstProdutoList[0];
      } else {
        FlutterBeep.beep(false);
        showMessage('Registro não encontrado', context);
        FocusScope.of(context).requestFocus(_focusProduto);
      }
      setState(() {});
    } else {
      FocusScope.of(context).requestFocus(_focusProduto);
    }
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
                        arguments: PedidoArguments(widget.lstCliente, 'dav'));
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
                titulo: 'DAV',
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
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 60,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextField(
                  controller: _edSearchNome,
                  focusNode: _focusProduto,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: corText, fontSize: 25),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(3, 0, 10, 0),
                    border: InputBorder.none,
                    fillColor: corText.withOpacity(0.2),
                    filled: true,
                    // labelText: _edSearchNome.text.isEmpty ? 'Localizar' : '',
                    // floatingLabelAlignment: FloatingLabelAlignment.start,
                    suffix: GestureDetector(
                      onTap: () {
                        _edSearchNome.clear();
                        ctrlApp.searchBar.value = '';
                        FocusScope.of(context).isFirstFocus;
                      },
                      child: const Icon(FontAwesomeIcons.eraser,
                          color: corText, size: 30),
                    ),
                  ),
                  onSubmitted: (value) async {
                    submitData(value);
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    UpperCaseTextFormatter(),
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: lstProduto.id.isEmpty
                ? const SizedBox(
                    height: 1,
                  )
                : ExpansionTileCard(
                    baseColor: Colors.white24,
                    expandedColor: Colors.white24,
                    initiallyExpanded: true,
                    // leading:
                    title: Text(
                      lstProduto.descricao,
                      style: const TextStyle(color: corText, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            children: [
                              Text(
                                lstProduto.barras,
                                style: const TextStyle(
                                    color: corText,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11),
                              ),
                              const Spacer(),
                              Text(
                                lstProduto.qte.toStringAsFixed(3) +
                                    ' X R\$' +
                                    formatter.format(
                                        Funcoes.getValorProduto(lstProduto)) +
                                    ' = ' +
                                    formatter.format(lstProduto.qte *
                                        Funcoes.getValorProduto(lstProduto)),
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: corText,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    children: [
                      const Divider(
                        thickness: 1,
                        height: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: Row(
                          children: [
                            FloatingActionButton(
                              heroTag: "minusconta",
                              onPressed: () {
                                FuncoesTela.minusEdit(lstProduto);

                                setState(() {
                                  _edQte.text = lstProduto.qte.toString();
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
                              edController: _edQte,
                              fonteSize: 25,
                              fieldSize: 50,
                              fieldWidth: 30,
                              fieldMaxLength: 5,
                              // edFocusNode: edQte,
                              textFlex: 30,
                              caption: lstProduto.qte.toString(),
                              onComplete: (value) {
                                setState(() {
                                  lstProduto.qte = value;

                                  FuncoesTela.updateFieldEdit(
                                      lstProduto, _edQte.text);
                                  _edQte.text = FuncoesTela._n.toString();
                                });
                              },
                              textInputType:
                                  const TextInputType.numberWithOptions(
                                      decimal: false),
                            ),
                            FloatingActionButton(
                              heroTag: "addconta",
                              onPressed: () {
                                FuncoesTela.addEdit(lstProduto);

                                setState(() {
                                  _edQte.text = lstProduto.qte.toString();
                                });
                              },
                              child: const Icon(
                                Icons.add_circle_outline,
                                size: 36,
                              ),
                              backgroundColor: Colors.blueGrey,
                            ),
                            const Spacer(
                              flex: 25,
                            ),
                            FloatingActionButton(
                              heroTag: "Gravar",
                              onPressed: () {
                                if (lstProduto.id.isNotEmpty) {
                                  FuncoesTela._n =
                                      Funcoes.strToFloat(_edQte.text);
                                  FuncoesTela.doUpdateProduto(
                                      lstProdutoList[0]);
                                  setState(() {
                                    lstProduto = Produto.clear();
                                    _edSearchNome.clear();
                                    FocusScope.of(context)
                                        .requestFocus(_focusProduto);
                                  });
                                }
                              },
                              child: const Icon(
                                Icons.check,
                                size: 36,
                              ),
                              backgroundColor: Colors.green[700],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
          Expanded(
            child: DAVProdutosBuilder(ctrlApp: widget.ctrlApp, isConta: true),
          ),
          Row(
            children: [
              const Spacer(flex: 2),
              IconButton(
                onPressed: () {
                  Funcoes.escanearCodigoBarras().then((barras) {
                    if (barras == '-1') {
                      _edSearchNome.clear;
                      ctrlApp.searchBar.value = '';
                      showMessage('Leitura cancelada', context);
                    } else {
                      FlutterBeep.beep();
                      _edSearchNome.text = barras;
                      ctrlApp.searchBar.value = barras;
                      submitData(barras);
                    }
                  });
                },
                icon: const Icon(
                  FontAwesomeIcons.barcode,
                  color: corText,
                  size: 50,
                ),
                iconSize: 50,
                color: Colors.white,
              ),
              const Spacer(flex: 1),
              IconButton(
                onPressed: () async {
                  await Navigator.of(context)
                      .pushNamed(AppRoutes.produtoSearch);
                  setState(() {});
                },
                icon: const Icon(
                  Icons.search,
                  color: corText,
                  size: 50,
                ),
                iconSize: 50,
                color: Colors.white,
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

class DAVProdutosBuilder extends StatefulWidget {
  final bool isConta;
  final AppStore ctrlApp;
  const DAVProdutosBuilder(
      {Key? key, required this.ctrlApp, required this.isConta})
      : super(key: key);

  @override
  State<DAVProdutosBuilder> createState() => _ProdutosBuilderState();
}

class _ProdutosBuilderState extends State<DAVProdutosBuilder> {
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

                return customExpationTileCard(lstProduto, index);
              },
            );
          }
          // return const Center(child: CircularProgressIndicator());
        });
  }

  SizedBox customExpationTileCard(List<Produto> lstProduto, int index) {
    return SizedBox(
      // leading:
      child: Slidable(
        key: Key(lstProduto[index].id),
        child: Container(
          margin: const EdgeInsets.only(bottom: 3, left: 10, right: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(3),
                topRight: Radius.circular(3),
                bottomLeft: Radius.circular(3),
                bottomRight: Radius.circular(3)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          padding: const EdgeInsets.only(bottom: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 3, left: 8, top: 3, right: 8),
                      child: Text(
                        lstProduto[index].descricao,
                        style: const TextStyle(color: corText, fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(3),
                child: Row(
                  children: [
                    Text(
                      'Barras: ' + lstProduto[index].barras,
                      style: const TextStyle(
                          color: corText,
                          fontWeight: FontWeight.bold,
                          fontSize: 11),
                    ),
                    const Spacer(),
                    Text(
                        lstProduto[index].qte.toStringAsFixed(3) +
                            lstProduto[index].unidade +
                            ' X R\$' +
                            formatter.format(
                                Funcoes.getValorProduto(lstProduto[index])) +
                            ' = ' +
                            formatter.format(lstProduto[index].qte *
                                Funcoes.getValorProduto(lstProduto[index])),
                        style: const TextStyle(
                            fontSize: 12,
                            color: corText,
                            fontWeight: FontWeight.bold))
                  ],
                ),
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
              String _id = lstProduto[index].id.toString();
              await DmModule.deletaPedido(_id);
              setState(() {});
            }),
          ),

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.

            SlidableAction(
              onPressed: ((context) async {
                // String _id = lstProduto[index].id.toString();
                FuncoesTela.doExcluiItem(lstProduto[index]);
              }),
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Excluir',
            ),
          ],
        ),
      ),
    );
  }
}
