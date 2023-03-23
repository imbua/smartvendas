import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:smartvendas/app_routes.dart';
import 'package:smartvendas/app_store.dart';
import 'package:smartvendas/modules/datamodule/connection/model/clientes.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/clientes_provider.dart';
import 'package:smartvendas/shared/funcoes.dart';
import 'package:smartvendas/shared/header_main.dart';
import 'package:smartvendas/shared/variaveis.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class ClienteList extends StatelessWidget {
  const ClienteList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController edSearchNome = TextEditingController();
    AppStore ctrlApp = Get.find<AppStore>();
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context)
              .pushNamed(AppRoutes.clienteEdit, arguments: null),
          tooltip: 'Adicionar Clientes',
          backgroundColor: corText,
          child: const Icon(
            Icons.add,
            size: 30,
          ),
        ),
        body: Column(children: [
          Stack(
            children: [
              const HeaderMain(
                iconeMain: Icons.supervisor_account,
                titulo: 'Clientes Registrados',
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
              Positioned(
                top: 30,
                right: 15,
                child: Obx(
                  () => Text(
                    ctrlApp.totalClientes.value.toString(),
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
                  controller: edSearchNome,
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
                        edSearchNome.clear();
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
                            child: ExpansionTileCard(
                              title: Text(
                                lstCliente[index].nome,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.blueGrey[800], fontSize: 16),
                              ),
                              subtitle: Text(
                                  '${lstCliente[index].municipio} - ${lstCliente[index].uf}',
                                  style: const TextStyle(fontSize: 12)),
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
                                    child: RichText(
                                      text: TextSpan(
                                          text:
                                              '${lstCliente[index].endereco}\n',
                                          style: TextStyle(
                                              color: Colors.blueGrey[800],
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  '${lstCliente[index].bairro} - ${lstCliente[index].cep}\n',
                                              style: TextStyle(
                                                  color: Colors.blueGrey[800],
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${lstCliente[index].telefone} ',
                                              style: TextStyle(
                                                  color: Colors.blueGrey[800],
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ]),
                                    ),
                                  ),
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.spaceAround,
                                  buttonHeight: 50,
                                  buttonMinWidth: 80,
                                  children: [
                                    BotaoBar(
                                      lstCliente: lstCliente[index],
                                      iconeBotao: FontAwesomeIcons.phone,
                                      caption: 'Ligar',
                                    ),
                                    BotaoBar(
                                        lstCliente: lstCliente[index],
                                        iconeBotao:
                                            FontAwesomeIcons.locationPin,
                                        caption: 'Mapa'),
                                    BotaoBar(
                                        lstCliente: lstCliente[index],
                                        iconeBotao: Icons.edit,
                                        caption: 'Editar'),
                                  ],
                                )
                              ],
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

class BotaoBar extends StatelessWidget {
  const BotaoBar({
    Key? key,
    required this.lstCliente,
    required this.iconeBotao,
    required this.caption,
  }) : super(key: key);

  final Cliente lstCliente;
  final String caption;
  final IconData iconeBotao;

  @override
  Widget build(BuildContext context) {
    final isCliente = (caption == 'Editar');
    final isFone = (caption == 'Ligar') && (lstCliente.telefone != '');
    final isGps = (caption == 'Mapa');
    final isMap = (caption == 'Mapa') &&
        (lstCliente.latitude != '') &&
        (lstCliente.longitude != '');
    final isEdit = (caption == 'Editar');

    return TextButton(
        style: flatButtonStyle,
        child: Column(
          children: [
            Icon(
              iconeBotao,
              color: isFone || isMap || isEdit
                  ? corBotao
                  : isGps
                      ? Colors.red
                      : Colors.grey,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
            ),
            Text(
              caption,
              style: TextStyle(
                color: isFone || isMap || isEdit
                    ? corBotao
                    : isGps
                        ? Colors.red
                        : Colors.grey,
              ),
            )
          ],
        ),
        onPressed: () {
          if (isCliente) {
            Navigator.of(context)
                .pushNamed(AppRoutes.clienteEdit, arguments: lstCliente);
          } else if (isFone) {
            fazerLigacao(lstCliente.telefone);
          } else if (isGps) {
            try {
              localizarMapa(context, lstCliente);
            } catch (e) {
              throw ('Erro on Gps ');
            }
          }
        });
  }

  localizarMapa(BuildContext context, Cliente lstCliente) async {
    if (lstCliente.latitude != '' && lstCliente.longitude != '') {
      MapsLauncher.launchCoordinates(
        double.parse(lstCliente.latitude),
        double.parse(lstCliente.longitude),
      );
    } else {
      //funcao para pegar por endereco!
      // MapsLauncher.launchQuery(lstCliente.endereco +
      //     ' ' +
      //     lstCliente.bairro +
      //     ' ' +
      //     lstCliente.municipio +
      //     ' ' +
      //     lstCliente.uf);
      await _getLocation().then((location) {
        final lat = location.latitude.toString();
        final lng = location.longitude.toString();
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.room,
                  size: 40,
                ),
                const SizedBox(height: 5),
                const Text('Coordenadas'),
                const SizedBox(height: 5),
                Column(
                  children: [
                    Text('Latitude:$lat'),
                    Text('Logitude:$lng'),
                  ],
                ),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text('Salvar'),
                onPressed: () {
                  if (lat != '') {
                    var cliente = lstCliente;
                    cliente.latitude = lat;
                    cliente.longitude = lng;
                    cliente.alterado = 1;
                    ClientesProvider.addReplaceCliente(cliente);
                  }

                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: const Text('Fechar'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
      });
    }
  }

  Future<LocationData> _getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw 'Serviço de localização não habilitado!';
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw 'Serviço de localização não permitido!';
      }
    }

    return await location.getLocation();
  }

  fazerLigacao(String telefone) async {
    if (telefone != '') {
      String fone = telefone.replaceAll(')', '');
      fone = fone.replaceAll('(', '');
      fone = fone.replaceAll('-', '');
      fone = fone.replaceAll('"', '');
      fone = fone.replaceAll('.', '');
      fone = fone.replaceAll(' ', '');

      await FlutterPhoneDirectCaller.callNumber(fone);
    }
  }
}
