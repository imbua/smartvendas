import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:flutter/services.dart';
import 'package:smartvendas/modules/datamodule/connection/model/produtos.dart';
import 'package:smartvendas/shared/variaveis.dart';

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toLowerCase());
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

class Funcoes {
  static Future<int> loadSound() async {
    asset = await rootBundle.load("assets/sounds/barras.mp3");
    return await soundpool.load(asset!);
  }

  static Future<int> loadErrorSound() async {
    assetError = await rootBundle.load("assets/sounds/error.mp3");
    return await soundpool.load(assetError!);
  }

  static void loadPool() {
    soundId = loadSound();
    soundErrorId = loadErrorSound();
  }

  static Future<void> customBeep(bool isError) async {
    var _alarmSound = -1;
    if (isError) {
      _alarmSound = await soundId;
    } else {
      _alarmSound = await soundErrorId;
    }
    await soundpool.play(_alarmSound);
  }

  static double getValorProduto(Produto produto) {
    if (produto.qteminatacado > 0 &&
        produto.atacado > 0 &&
        produto.qte >= produto.qteminatacado) {
      return produto.atacado;
    } else {
      return produto.preco;
    }
  }

  static bool isNumber(String string) {
    if (string.isEmpty) {
      return false;
    } else {
      final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

      return numericRegex.hasMatch(string);
    }
  }

  static int strToInt(var value) {
    if (value.toString() == '') {
      return 0;
    } else {
      double val = double.tryParse(value.toString()) ?? 0.00;
      return val.toInt();
    }
  }

  static Future<String> escanearCodigoBarras() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancelar', true, ScanMode.BARCODE);

    if (barcodeScanRes == '-1') {
      return '-1';
    } else {
      return barcodeScanRes;
    }
  }

  static String doXmlGetChaveAmazon(String fChave) {
    return '<?xml version="1.0"?>'
            '<comando>'
            '	<clienteweb><id>' +
        fChave +
        '</id></clienteweb>'
            '	<funcao>'
            '	<unitphp>clientesweb.class</unitphp>'
            '	<tipo>GetClienteWeb</tipo>'
            ' <campo>id</campo>'
            ' <conteudo>' +
        fChave +
        '</conteudo>'
            ' <range></range>'
            ' <tabela></tabela>'
            ' <complemento></complemento>'
            ' <empresa></empresa>'
            ' <data></data>'
            '	</funcao>'
            '</comando>';
  }

  static double strToFloat(var value) {
    if (value.toString() == '') {
      return 0;
    } else {
      double val = double.tryParse(value.toString()) ?? 0.00;
      return val;
    }
  }

  static Uint8List getImagenBase64(String imagem) {
    try {
      String _imageBase64 = imagem;
      return base64.decode(_imageBase64);
    } catch (err) {
      throw (err.toString());
      //   '`path_provider_ios` threw an error: $err. '
      //   'The app may not function as expected until you remove this plugin from pubspec.yaml'
      // );

    }
  }
}
