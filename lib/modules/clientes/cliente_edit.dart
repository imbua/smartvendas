import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartvendas/modules/datamodule/connection/model/clientes.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/clientes_provider.dart';
import 'package:smartvendas/shared/funcoes.dart';
import 'package:smartvendas/shared/header_main.dart';
import 'package:smartvendas/shared/show_message.dart';
import 'package:smartvendas/shared/variaveis.dart';
import 'package:http/http.dart' as http;

class TextControllers extends GetxController {
  final Rx<TextEditingController> _edCpfCnpj = TextEditingController().obs;
  final Rx<TextEditingController> _edNome = TextEditingController().obs;
  final Rx<TextEditingController> _edFantasia = TextEditingController().obs;
  final Rx<TextEditingController> _edBairro = TextEditingController().obs;
  final Rx<TextEditingController> _edUf = TextEditingController().obs;
  final Rx<TextEditingController> _edEndereco = TextEditingController().obs;
  final Rx<TextEditingController> _edCep = TextEditingController().obs;
  final Rx<TextEditingController> _edFone = TextEditingController().obs;
  final Rx<TextEditingController> _edCidade = TextEditingController().obs;
}

final TextControllers textControllers = Get.put(TextControllers());

class ClienteEdit extends StatefulWidget {
  const ClienteEdit({Key? key}) : super(key: key);
  @override
  State<ClienteEdit> createState() => _ClienteEditState();
}

class _ClienteEditState extends State<ClienteEdit> {
  final FocusNode _edFocusCpfCnpj = FocusNode();
  final FocusNode _edFocusNome = FocusNode();
  final FocusNode _edFocusFantasia = FocusNode();
  final FocusNode _edFocusBairro = FocusNode();
  final FocusNode _edFocusUf = FocusNode();
  final FocusNode _edFocusEndereco = FocusNode();
  final FocusNode _edFocusCep = FocusNode();
  final FocusNode _edFocusFone = FocusNode();
  final FocusNode _edFocusCidade = FocusNode();

  Future<bool> consultaCnpj() async {
    try {
      bool okBool = false;
      var cnpj = textControllers._edCpfCnpj.value.text
          .replaceAll(RegExp(r'[^0-9 ]'), "");
      var url = 'http://www.receitaws.com.br/v1/cnpj/' + cnpj;
      final response = await http.get(Uri.parse(url));
      String data = response.body;
      if (response.statusCode == 200) {
        if (data != '{"status":"ERROR","message":"CNPJ inválido"}') {
          var parsedJson = json.decode(data);

          // textControllers._edCpfCnpj.value = parsedJson['cnpj'];
          textControllers._edNome.value.text = parsedJson['nome'];
          textControllers._edFantasia.value.text = parsedJson['fantasia'];
          textControllers._edBairro.value.text = parsedJson['bairro'];
          textControllers._edUf.value.text = parsedJson['uf'];
          textControllers._edEndereco.value.text = parsedJson['logradouro'];
          textControllers._edCep.value.text = parsedJson['cep'];
          textControllers._edFone.value.text = parsedJson['telefone'];
          textControllers._edCidade.value.text = parsedJson['municipio'];
          okBool = true;
        }
      }
      return okBool;
    } catch (e) {
      throw 'Erro na captação do cnpj';
    }
  }

  void fetchVars(Cliente cliente) {
    textControllers._edCpfCnpj.value.text = cliente.id;
    textControllers._edNome.value.text = cliente.nome;
    textControllers._edFantasia.value.text = cliente.fantasia;
    textControllers._edBairro.value.text = cliente.bairro;
    textControllers._edUf.value.text = cliente.uf;
    textControllers._edEndereco.value.text = cliente.endereco;
    textControllers._edCep.value.text = cliente.cep;
    textControllers._edFone.value.text = cliente.telefone;
    textControllers._edCidade.value.text = cliente.municipio;
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.settings.arguments != null) {
      final List<Cliente> lstCliente =
          ModalRoute.of(context)!.settings.arguments as List<Cliente>;
      fetchVars(lstCliente[0]);
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Stack(
            children: [
              const HeaderMain(
                iconeMain: Icons.supervisor_account,
                titulo: 'Cadastro de clientes',
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
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextEditCustom(
                    edController: textControllers._edCpfCnpj.value,
                    edFocusNode: _edFocusCpfCnpj,
                    caption: 'CPF ou CNPJ',
                    textInputType:
                        const TextInputType.numberWithOptions(decimal: false),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: IconButton(
                      tooltip: 'Consultar CNPJ na Receita',
                      icon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 30,
                      ),
                      onPressed: () async {
                        String _cnpj = textControllers._edCpfCnpj.value.text
                            .replaceAll(RegExp(r'[^0-9 ]'), "");
                        if (_cnpj.length != 14) {
                          showMessage(
                              'Erro no preenchimento do CNPJ!', context);
                        } else {
                          await consultaCnpj().then((ok) {
                            if (!ok) {
                              showMessage('Cnpj não encontrado!', context);
                            }
                          });
                        }
                      },
                    ),
                  ),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextEditCustom(
                      edController: textControllers._edNome.value,
                      edFocusNode: _edFocusNome,
                      caption: 'Nome'),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextEditCustom(
                      edController: textControllers._edFantasia.value,
                      edFocusNode: _edFocusFantasia,
                      caption: 'Fantasia'),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextEditCustom(
                      edController: textControllers._edEndereco.value,
                      edFocusNode: _edFocusEndereco,
                      caption: 'Endereco'),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextEditCustom(
                      edController: textControllers._edBairro.value,
                      edFocusNode: _edFocusBairro,
                      caption: 'Bairro'),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextEditCustom(
                    edController: textControllers._edCep.value,
                    edFocusNode: _edFocusCep,
                    caption: 'CEP',
                    textInputType: TextInputType.number,
                  ),
                  const SizedBox(width: 35),
                  Expanded(
                    child: TextEditCustom(
                      caption: 'Telefone',
                      edController: textControllers._edFone.value,
                      edFocusNode: _edFocusFone,
                      textInputType: TextInputType.phone,
                    ),
                  ),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextEditCustom(
                      edController: textControllers._edCidade.value,
                      edFocusNode: _edFocusCidade,
                      caption: 'Municipio',
                      textFlex: 3),
                  const SizedBox(width: 15),
                  TextEditCustom(
                      edController: textControllers._edUf.value,
                      edFocusNode: _edFocusUf,
                      caption: 'UF',
                      textFlex: 1),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  buttonHeight: 50,
                  buttonMinWidth: 80,
                  children: [
                    BotaoBar(
                      iconeBotao: Icons.save_as,
                      caption: 'Gravar',
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    BotaoBar(
                      iconeBotao: Icons.close,
                      caption: 'Fechar',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class BotaoBar extends StatelessWidget {
  const BotaoBar({
    Key? key,
    required this.iconeBotao,
    required this.caption,
  }) : super(key: key);
  final String caption;
  final IconData iconeBotao;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: flatButtonStyle,
        child: Column(
          children: [
            Icon(iconeBotao, color: corBotao),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
            ),
            Text(
              caption,
              style: const TextStyle(color: corBotao),
            )
          ],
        ),
        onPressed: () async {
          if (caption == 'Fechar') {
            Navigator.of(context).pop();
          } else if (caption == 'Gravar') {
            var _cliente = Cliente(
              textControllers._edCpfCnpj.value.text,
              textControllers._edNome.value.text,
              textControllers._edFantasia.value.text,
              textControllers._edEndereco.value.text,
              '0',
              textControllers._edBairro.value.text,
              textControllers._edCep.value.text,
              textControllers._edFone.value.text,
              textControllers._edUf.value.text,
              textControllers._edCidade.value.text,
              '0',
              '0',
            );
            _cliente.id = textControllers._edCpfCnpj.value.text;

            ClientesProvider.addReplaceCliente(_cliente);
            Navigator.of(context).pop(_cliente);
          }
        });
  }
}

//;TextInputType.numberWithOptions(decimal: false),
class TextEditCustom extends StatelessWidget {
  final TextInputType textInputType;
  final TextEditingController edController;
  final FocusNode edFocusNode;
  final String caption;
  final int textFlex;
  const TextEditCustom(
      {Key? key,
      required this.caption,
      this.textInputType = TextInputType.text,
      this.textFlex = 3,
      required this.edController,
      required this.edFocusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: textFlex,
      child: SizedBox(
        height: 30,
        width: 20,
        child: TextFormField(
          controller: edController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 0, color: Colors.black12),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            labelText: caption,
          ),
          keyboardType: textInputType,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (term) {
            FocusScope.of(context).nextFocus();
          },
          inputFormatters: [
            UpperCaseTextFormatter(),
          ],
        ),
      ),
    );
  }
}
