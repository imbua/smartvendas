import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smartvendas/app_routes.dart';
import 'package:smartvendas/app_store.dart';
import 'package:smartvendas/modules/datamodule/connection/model/clientes.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/clientes_provider.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/pedidos_provider.dart';
import 'package:smartvendas/shared/funcoes.dart';
import 'package:smartvendas/shared/header_main.dart';
import 'package:smartvendas/shared/variaveis.dart';

class ClienteSelecionar extends StatelessWidget {
  const ClienteSelecionar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String _choice = ModalRoute.of(context)!.settings.arguments as String;

    final TextEditingController _edSearchNome = TextEditingController();
    AppStore ctrlApp = Get.find<AppStore>();
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          Stack(
            children: [
              const HeaderMain(
                iconeMain: Icons.supervisor_account,
                titulo: 'Selecionar Clientes',
                altura: 70,
              ),
              Positioned(
                top: 15,
                left: 15,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                  iconSize: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 60,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextField(
                  controller: _edSearchNome,
                  style: const TextStyle(color: corText, fontSize: 18),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    border: InputBorder.none,
                    fillColor: corText.withOpacity(0.2),
                    filled: true,
                    labelText: 'Localizar',
                    prefix: const Icon(
                      Icons.search,
                      color: corText,
                      size: 20,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _edSearchNome.clear();
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
              child: FutureBuilder<List<Cliente>>(
                  future:
                      ClientesProvider.loadClientes(ctrlApp.searchBar.value),
                  initialData: const [],
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    List<Cliente> lstCliente = snapshot.data;
                    if (!snapshot.hasData) {
                      // || snapshot.data.lenght == 0
                      return const Center(
                        child: Text('Nenhum registro encontrado!'),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: lstCliente.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: InkWell(
                              splashColor: Colors.greenAccent,
                              onTap: () async {
                                PedidosProvider.resetProdutos();
                                ctrlApp.totalGeralProdutosFmt.value = '';
                                if (_choice == 'dav') {
                                  Navigator.of(context).pushReplacementNamed(
                                      AppRoutes.dav,
                                      arguments: lstCliente[index]);
                                } else {
                                  Navigator.of(context).pushReplacementNamed(
                                      AppRoutes.pedidoProduto,
                                      arguments: lstCliente[index]);
                                }
                              },
                              child: ListTile(
                                title: Text(
                                  lstCliente[index].nome,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.blueGrey[800],
                                      fontSize: 16),
                                ),
                                subtitle: Text(
                                    lstCliente[index].municipio +
                                        ' - ' +
                                        lstCliente[index].uf,
                                    style: const TextStyle(fontSize: 12)),
                              ),
                            ),
                          );
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
