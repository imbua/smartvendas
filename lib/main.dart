import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:smartvendas/app_routes.dart';
import 'package:smartvendas/app_store.dart';
import 'package:smartvendas/modules/clientes/cliente_edit.dart';
import 'package:smartvendas/modules/clientes/clientes_selecionar.dart';
import 'package:smartvendas/modules/datamodule/connection/dm.dart';
import 'package:smartvendas/modules/pedidos/davs/dav.dart';
import 'package:smartvendas/modules/pedidos/representantes/pedido_alterar.dart';
import 'package:smartvendas/modules/pedidos/representantes/pedido_conta.dart';
import 'package:smartvendas/modules/pedidos/representantes/pedido_list.dart';
import 'package:smartvendas/modules/pedidos/representantes/pedido_produto.dart';
import 'package:smartvendas/modules/produtos/produtos_list.dart';
import 'package:smartvendas/modules/config/sincro_widget.dart';
import 'package:smartvendas/modules/produtos/produtos_preco.dart';
import 'modules/clientes/clientes_list.dart';
import 'modules/config/config_widget.dart';
import 'modules/login/login_page.dart';
import 'modules/menu/menu_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // bool loggedIn = prefs.getBool("loggedIn");
  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (BuildContext context) => DmModule,
          // dispose: (context, db) => DmModule.database.close(),
        )
      ],
      // child: DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) => MyApp(),
      // ),
      child: const MyApp(),
    ),
  );
}

// void main() {
// runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppStore ctrlApp = Get.put(AppStore());
    //  myDb.doCmdQuery('DROP DATABASE IF EXISTS db.sqlite');
    // AppStore ctrlApp = Get.put(AppStore());

    return MaterialApp(
      title: 'SmartVendas',
      theme: ThemeData(
        // fontFamily: 'Lato',
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: Colors.deepOrange),
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        AppRoutes.login: (ctx) {
          // if (ctrlApp.usuarioId.value == 0) {
          return const LoginPage();
          // } else {
          //   return const MenuWidget();
          // }
        },
        AppRoutes.menu: (ctx) => const MenuWidget(),
        AppRoutes.config: (ctx) => const ConfigWidget(),
        AppRoutes.sincro: (ctx) => const SincroWidget(),
        AppRoutes.clienteList: (ctx) => const ClienteList(),
        AppRoutes.clienteEdit: (ctx) => const ClienteEdit(),
        AppRoutes.clientesSelecionar: (ctx) => const ClienteSelecionar(),
        AppRoutes.produtoList: (ctx) => const ProdutosList(),
        AppRoutes.produtoPreco: (ctx) => const ProdutosPreco(),
        AppRoutes.pedidoProduto: (ctx) => const PedidoProduto(),
        AppRoutes.pedidoConta: (ctx) => const PedidoConta(),
        AppRoutes.pedidoAlterar: (ctx) => const PedidoAlterar(),
        AppRoutes.pedidoList: (ctx) => const PedidoListagem(),
        AppRoutes.dav: (ctx) => const DAV(),

        //   AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailPage(),
        //   AppRoutes.CART: (ctx) => CartPage(),
        //   AppRoutes.ORDERS: (ctx) => OrdersPage(),
        //   AppRoutes.PRODUCTS: (ctx) => ProductPage(),
        //   AppRoutes.PRODUCT_FORM: (ctx) => ProductFormPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
