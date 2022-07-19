import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:flutter/services.dart';
import 'package:smartvendas/modules/datamodule/connection/model/produtos.dart';

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
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    return numericRegex.hasMatch(string);
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
