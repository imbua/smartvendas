// import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smartvendas/app_store.dart';
import 'package:smartvendas/modules/datamodule/connection/dmremoto.dart';
import 'package:smartvendas/modules/datamodule/connection/model/categoria.dart';
import 'package:smartvendas/modules/datamodule/connection/model/produtos.dart';
import 'package:smartvendas/shared/funcoes.dart';
import 'package:smartvendas/modules/pedidos/representantes/pedido_share.dart';
import 'package:smartvendas/shared/header_main.dart';
import 'package:smartvendas/shared/variaveis.dart';

class ProdutosList extends StatelessWidget {
  const ProdutosList({Key? key}) : super(key: key);
  //  BackButtonInterceptor.add(myInterceptor);

  @override
  Widget build(BuildContext context) {
    // final String source = ModalRoute.of(context)!.settings.arguments as String;

    AppStore ctrlApp = Get.find<AppStore>();
    return WillPopScope(
      onWillPop: () {
        return Future.value(false); // if true allow back else block it
      },
      child: ProdutosListControl(ctrlApp: ctrlApp),
    );
  }
}

class ProdutosListControl extends StatefulWidget {
  final AppStore ctrlApp;

  const ProdutosListControl({
    Key? key,
    required this.ctrlApp,
  }) : super(key: key);

  @override
  State<ProdutosListControl> createState() => _ProdutosListControlState();
}

class _ProdutosListControlState extends State<ProdutosListControl> {
  final TextEditingController _edSearch = TextEditingController();

  Categoria _itemSelecionado = Categoria('', '');

  DropdownMenuItem<Categoria> buildMenuItem(Categoria item) => DropdownMenuItem(
        value: item,
        child: Text(item.descricao),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: corRodape,
          child: Row(
            children: [
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
                child: dropDownCategoria(),
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
            child: produtosBuilderList(),
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

        setState(() {});
      },
      // selectedItemBuilder: _itemSelecionado,
    );
  }
}

produtosBuilderList() {
  return FutureBuilder<List<Produto>>(
      future: FuncoesTela.loadBuilder('produtoslist'),
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
                              '${lstProduto[index].valorfmt}  ( ${lstProduto[index].estoque.toStringAsFixed(0)} ${lstProduto[index].unidade})',
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
                          lstProduto[index].atacado > 0
                              ? Text(
                                  'Atac.:${lstProduto[index].atacadofmt}(${lstProduto[index].qteminatacado} ${lstProduto[index].unidade})',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                )
                              : const SizedBox(width: 1),
                          const Spacer(),
                          (lstProduto[index].qte) > 0
                              ? Text(
                                  '${lstProduto[index].qte} X R\$${formatter.format(Funcoes.getValorProduto(lstProduto[index], 'produtos'))} = ${formatter.format(lstProduto[index].qte * Funcoes.getValorProduto(lstProduto[index], 'produtos'))}',
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
                            const Spacer(),
                            lstProduto[index].imagem.isNotEmpty
                                ? SizedBox(
                                    height: 100,
                                    width: 100,
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
                            const Spacer(),
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
