import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartvendas/modules/datamodule/connection/dm.dart';
import 'package:smartvendas/modules/datamodule/connection/model/pedido.dart';
import 'package:smartvendas/store.dart';

class AppStore = _AppStoreBase with Store;

abstract class _AppStoreBase extends GetxController {
  final Completer<SharedPreferences> _instancia = Completer();

  _init() async {
    _instancia.complete(await SharedPreferences.getInstance());
  }

  _AppStoreBase() {
    _init();
    _lerIni();
  }

  RxBool isOk = false.obs;

  void sbOkChecked() {
    isOk.value = !isOk.value;
  }

  RxBool isRememberSenha = false.obs;

  void updRememberSenha(bool fbool) {
    isRememberSenha.value = fbool;
  }

  //gravar variavies e ambiente
  RxBool showSenha = false.obs;

  void isShowSenha() {
    showSenha.value = showSenha.value ? false : true;
  }

  RxInt usuarioId = 0.obs;
  // RxString usuarioNome = ''.obs;
  RxString usuario = ''.obs;
  RxString senha = ''.obs;
  RxString usuarioGravado = ''.obs;
  RxString senhaGravado = ''.obs;
  RxString loginVendedor = ''.obs;
  RxString loginVendedorNome = ''.obs;
  RxString userChaveApp = ''.obs;
  String cwHost = '';
  String cwHostUser = '';
  String cwHostPassword = '';
  String cwHostDb = '';
  String cwHostDbFinan = '';
  String cwHostConnection =
      'amz.nbsoftware.com.br/nbsoftkernel/express/route.class.php';
//variaves do sistema
  RxString searchBar = ''.obs;

  RxString strLabel = ''.obs;
  String getObxLabel(String label) {
    // if (usuarioGravado.value != value) {
    //   usuarioId.value = 0;
    // }
    strLabel.value = label;
    return strLabel.value;
  }

//variaveis do pedido
  RxString pedidoId = ''.obs;
  RxString pedidoSubtotal = ''.obs;
  RxString pedidoClienteId = ''.obs;
  RxString pedidoClienteNome = ''.obs;
  RxString pedidoCidade = ''.obs;

  RxList<Pedido> lstPedido = RxList([]);

  RxInt totalClientes = 0.obs;
  RxInt totalProdutos = 0.obs;
  RxInt totalPedidos = 0.obs;
  RxString totalGeralProdutosFmt = ''.obs;
  RxDouble totalGeralProdutos = 0.00.obs;
  RxInt totalQteLabelPedido = 0.obs;

  String getPedidoId() {
    // if (usuarioGravado.value != value) {
    //   usuarioId.value = 0;
    // }
    pedidoId.value = usuarioId.value.toString() +
        DateTime.now().millisecondsSinceEpoch.toString();

    return pedidoId.value.toString();
  }

  void doTabCounts() async {
    // print(await myDb.countCli().toString());
    totalClientes.value = await DmModule.getCount('clientes');
    // totalProdutos.value = await myDb.countPrd();
  }

  void updUsuario(String value) {
    // if (usuarioGravado.value != value) {
    //   usuarioId.value = 0;
    // }

    usuario = value.obs;
  }

  void updSenha(String value) {
    // if (senhaGravado.value != value) {
    //   usuarioId.value = 0;
    // }

    senha = value.obs;
  }

  Future gravarIni() async {
    try {
      var sp = await _instancia.future;
      sp.setInt('usuarioId', usuarioId.value);
      // sp.setString('usuarioNome', usuarioNome.value);
      sp.setString('usuario', usuario.value);
      sp.setString('psw', senha.value);
      sp.setString('userchaveapp', userChaveApp.value);
      sp.setString('host', cwHost);
      sp.setString('hostDb', cwHostDb);
      sp.setString('hostDbFinan', cwHostDbFinan);
      sp.setBool('remember', isRememberSenha.value);
      _lerIni();
    } catch (exception) {
      throw ("GravaPreferences" + exception.toString());
    }
  }

  _lerIni() async {
    var sp = await _instancia.future;
    usuarioId.value = sp.getInt('usuarioId') ?? 0;
    usuario.value = sp.getString('usuario') ?? '';
    // usuarioNome.value = sp.getString('nome') ?? '';
    senha.value = sp.getString('psw') ?? '';
    userChaveApp.value = sp.getString('userchaveapp') ?? 'nokey';

    usuarioGravado.value = sp.getString('usuario') ?? '';
    senhaGravado.value = sp.getString('psw') ?? '';
    isRememberSenha.value = sp.getBool('remember') ?? false;

    cwHost = sp.getString('host') ?? '';
    cwHostDb = sp.getString('hostDb') ?? '';
    cwHostDbFinan = sp.getString('hostDbFinan') ?? '';
  }

  String ipServerSufixo = '/nbsoftkernellocal/mobile';
  String ipServer = 'localhost'; //provisório
  String urlToken = 'MTBtZXRyMWNzYnljcjFzdDFhbm8'; //provisório

  void updipServer(String value) {
    ipServer = value;
  }

  String get urlBase => 'http://' + ipServer + '/';
  String get loginRemoto =>
      urlBase +
      'login.mobile.php?token=' +
      urlToken +
      '=' + //original 10metr1csbycr1st1ano
      '&user=' +
      base64.encode(utf8.encode(usuario.value)) +
      '&pwd=' +
      base64.encode(utf8.encode(senha.value));

  String get cargaRemoto =>
      urlBase +
      'route.mobile.php?route=carga&token=' +
      urlToken +
      '&campo=&conteudo=';

  String get urlSendClientes =>
      urlBase + 'route.mobile.php?route=sendcliente&token=' + urlToken;

  String get urlSendPedidos =>
      urlBase + 'route.mobile.php?route=sendpedido&token=' + urlToken;

  String get vendedornome => 'Vendedor: $loginVendedorNome';
}
