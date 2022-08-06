import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smartvendas/app_store.dart';
import 'package:smartvendas/modules/datamodule/connection/dm.dart';
import 'package:smartvendas/modules/datamodule/connection/dmremoto.dart';
import 'package:smartvendas/shared/botao_customizado.dart';
import 'package:smartvendas/shared/funcoes.dart';
import 'package:smartvendas/shared/header_main.dart';
import 'package:smartvendas/shared/show_message.dart';

class SincroWidget extends StatefulWidget {
  const SincroWidget({Key? key}) : super(key: key);

  @override
  State<SincroWidget> createState() => _SincroWidgetState();
}

class _SincroWidgetState extends State<SincroWidget> {
  final TextEditingController txtChaveApp = TextEditingController();

  bool checked = false;

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);

    AppStore ctrlApp = Get.find<AppStore>();
    txtChaveApp.text = ctrlApp.userChaveApp.value;
    return Scaffold(
      body: Column(
        children: [
          const HeaderMain(
            iconeMain: Icons.sync,
            titulo: 'Sincronisar dados',
            altura: 100,
          ),
          // _itemList(
          //   titulo: 'Opçoes teste',
          //   subTitulo: 'subOpçoes teste',
          //   cor: Colors.blue,
          //   iconeItemList: Icons.sync,
          //   item: Switch(
          //       value: checked,
          //       onChanged: (bool value) {
          //         setState(() {
          //           checked = value;
          //         });
          //       }),
          // ),
          BotaoInfo(
              caption: 'Envio de Pedidos',
              iconeBotaoBackGround: FontAwesomeIcons.circleUser,
              onPress: () async {
                final pbProgress =
                    Funcoes.progressBar(context, 1, 'Enviando pedidos...');

                try {
                  pbProgress.show();

                  await sendPedidos(context).then((value) {
                    // final String   result = value;
                    pbProgress.hide();
                    msg.showSnackBar(
                      SnackBar(
                        content: Text(value),
                      ),
                    );
                  });
                } catch (exception) {
                  if (pbProgress.isShowing()) {
                    pbProgress.hide();
                  }
                  showMessage('Erro:' + exception.toString(), context);

                  Navigator.of(context).pop();
                }
              }),
          BotaoInfo(
              caption: 'Carga',
              iconeBotaoBackGround: FontAwesomeIcons.circleUser,
              onPress: () async {
                try {
                  await cargaDados(ctrlApp.cargaRemoto, context);

                  await DmModule.totalCounts();
                  // Navigator.of(context).pop();

                  showMessage('Process concluido!', context);
                } catch (exception) {
                  showMessage('Erro:' + exception.toString(), context);
                  // Navigator.of(context).pop();
                }
              }),
          Expanded(child: Container()),
          BotaoInfo(
            caption: 'Sair',
            iconeBotaoBackGround: FontAwesomeIcons.circleUser,
            onPress: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

// _carga(String url, BuildContext context) async {
  // await cargaDados(url, context);
// }



// class _itemList extends StatelessWidget {
//   final Widget item;
//   final Color cor;
//   final String titulo;
//   final String subTitulo;
//   final IconData iconeItemList;

//   const _itemList({
//     Key? key,
//     required this.item,
//     this.cor = Colors.blue,
//     required this.titulo,
//     this.subTitulo = '',
//     required this.iconeItemList,
//   }) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Icon(
//         iconeItemList,
//         color: cor,
//         size: 35,
//       ),
//       title: Text(
//         titulo,
//         style: TextStyle(color: cor, fontSize: 18, fontWeight: FontWeight.bold),
//       ),
//       subtitle: Text(
//         subTitulo,
//         style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//       ),
//       trailing: Transform.scale(
//         scale: 1.2,
//         child: item,
//       ),
//     );
//   }
// }
