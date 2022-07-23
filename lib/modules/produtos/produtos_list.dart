import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smartvendas/app_routes.dart';
import 'package:smartvendas/app_store.dart';
import 'package:smartvendas/modules/datamodule/connection/model/produtos.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/produtos_provider.dart';
import 'package:smartvendas/shared/funcoes.dart';
import 'package:smartvendas/shared/header_main.dart';
import 'package:smartvendas/shared/variaveis.dart';

class ProdutosList extends StatelessWidget {
  const ProdutosList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _edSearchProduto = TextEditingController();
    AppStore ctrlApp = Get.find<AppStore>();
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          Stack(
            children: [
              const HeaderMain(
                iconeMain: Icons.supervisor_account,
                titulo: 'Produtos Registrados',
                altura: 70,
              ),
              Positioned(
                top: 15,
                left: 15,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).popAndPushNamed(AppRoutes.menu);
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                  iconSize: 30,
                  color: Colors.white,
                ),
              ),
              Positioned(
                top: 30,
                right: 15,
                child: Obx(
                  () => Text(
                    ctrlApp.totalProdutos.value.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 60,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextField(
                  controller: _edSearchProduto,
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
                        _edSearchProduto.clear();
                        FocusScope.of(context).unfocus();
                      },
                      child: const Icon(FontAwesomeIcons.eraser,
                          color: corText, size: 30),
                    ),
                  ),
                  onChanged: (value) async {
                    ctrlApp.searchBar.value = value;
                  },
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                )),
          ),
          const SizedBox(height: 10),
          Obx(
            () => (Expanded(
              child: FutureBuilder<List<Produto>>(
                  future: ProdutosProvider.loadProdutos(
                      ctrlApp.searchBar.value, ''),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 1.0),
                              child: ListTile(
                                title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lstProduto[index].descricao.trim(),
                                        style: const TextStyle(
                                            color: corText, fontSize: 14),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Código: ' + lstProduto[index].id,
                                            style: const TextStyle(
                                                color: corText, fontSize: 11),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '  Barras: ' +
                                                lstProduto[index].barras,
                                            style: const TextStyle(
                                                color: corText,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Valor:' +
                                                lstProduto[index].valorfmt +
                                                ' ' +
                                                lstProduto[index].unidade,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                          const Spacer(),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          Text(
                                            'Vr.Atac.:' +
                                                lstProduto[index].atacadofmt,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ]),
                              ));
                        },
                      );
                    }
                    // return const Center(child: CircularProgressIndicator());
                  }),
            )),
          ),
        ]),
      ),
    );
  }
}
