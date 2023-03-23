// import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smartvendas/app_store.dart';
import 'package:smartvendas/modules/datamodule/connection/dmremoto.dart';
import 'package:smartvendas/modules/datamodule/connection/model/categoria.dart';
import 'package:smartvendas/modules/datamodule/connection/model/fornecedores.dart';
import 'package:smartvendas/shared/funcoes.dart';
import 'package:smartvendas/modules/pedidos/representantes/pedido_share.dart';
import 'package:smartvendas/shared/header_main.dart';
import 'package:smartvendas/shared/variaveis.dart';

class ProdutoSearch extends StatelessWidget {
  const ProdutoSearch({Key? key}) : super(key: key);
  //  BackButtonInterceptor.add(myInterceptor);

  @override
  Widget build(BuildContext context) {
    final String source = ModalRoute.of(context)!.settings.arguments as String;

    AppStore ctrlApp = Get.find<AppStore>();
    return WillPopScope(
      onWillPop: () {
        return Future.value(false); // if true allow back else block it
      },
      child: ProdutoSearchControl(ctrlApp: ctrlApp, origem: source),
    );
  }
}

class ProdutoSearchControl extends StatefulWidget {
  final String origem;
  final AppStore ctrlApp;

  const ProdutoSearchControl({
    Key? key,
    required this.origem,
    required this.ctrlApp,
  }) : super(key: key);

  @override
  State<ProdutoSearchControl> createState() => _ProdutoSearchControlState();
}

class _ProdutoSearchControlState extends State<ProdutoSearchControl> {
  final TextEditingController _edSearch = TextEditingController();
  bool isFornecedor = false;

  Categoria _itemSelecionado = Categoria('', '');
  Fornecedor _itemFornecSelecionado = Fornecedor('', '');

  DropdownMenuItem<Categoria> buildMenuItem(Categoria item) => DropdownMenuItem(
        value: item,
        child: Text(item.descricao),
      );
  DropdownMenuItem<Fornecedor> buildFornecMenuItem(Fornecedor item) =>
      DropdownMenuItem(
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
    if (widget.origem == 'cotacao') {
      isFornecedor = ctrlApp.useTabFornecedor;
    }

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: corRodape,
          child: Row(
            children: [
              Obx(
                () => Text(
                  '${ctrlApp.totalRegistros} registros',
                  style: const TextStyle(
                      color: Colors.white70,
                      fontFamily: "RobotoCondensed",
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              const Spacer(),
              OutlinedButton.icon(
                label: const Text(
                  'OK',
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
                  // Modular.to.popUntil(ModalRoute.withName(AppRoutes.menu));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
        body: Column(children: [
          Stack(
            children: const [
              HeaderInput(
                iconeMain: Icons.local_shipping,
                titulo: 'Pesquisa Produtos',
                altura: 50,
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
                    _edSearch.text = '';
                    _itemSelecionado = Categoria('', '');
                    _itemFornecSelecionado = Fornecedor('', '');

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
                child:
                    isFornecedor ? dropDownFornecedor() : dropDownCategoria(),
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
            child:
                ProdutosBuilder(ctrlApp: widget.ctrlApp, origem: widget.origem),
          ),
        ]),
      ),
    );
  }

  DropdownButton<Categoria> dropDownCategoria() {
    return DropdownButton<Categoria>(
      isExpanded: true,
      items: ctrlApp.lstCategoria.map(buildMenuItem).toList(),
      value: _itemSelecionado.id == "" ? null : _itemSelecionado,
      onChanged: (itemSelecionado) {
        ctrlApp.searchBarWithCategoria.value = itemSelecionado!.id;
        _itemSelecionado = itemSelecionado;

        mudaEstado();
      },
      // selectedItemBuilder: _itemSelecionado,
    );
  }

  DropdownButton<Fornecedor> dropDownFornecedor() {
    return DropdownButton<Fornecedor>(
      isExpanded: true,
      items: ctrlApp.lstFornecedor.map(buildFornecMenuItem).toList(),
      value: _itemFornecSelecionado.id == "" ? null : _itemFornecSelecionado,
      onChanged: (itemSelecionado) {
        ctrlApp.searchBarWithCategoria.value = itemSelecionado!.id;
        _itemFornecSelecionado = itemSelecionado;

        mudaEstado();
      },
      // selectedItemBuilder: _itemSelecionado,
    );
  }
}
