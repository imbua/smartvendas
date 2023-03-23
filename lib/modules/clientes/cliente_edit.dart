import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smartvendas/modules/datamodule/connection/model/cep.dart';
import 'package:smartvendas/modules/datamodule/connection/model/clientes.dart';
import 'package:smartvendas/modules/datamodule/connection/provider/clientes_provider.dart';
import 'package:smartvendas/shared/funcoes.dart';
import 'package:smartvendas/shared/header_main.dart';
import 'package:smartvendas/shared/show_message.dart';
import 'package:smartvendas/shared/variaveis.dart';
import 'package:http/http.dart' as http;
import 'package:brasil_fields/brasil_fields.dart';

class TextControllers {
  final TextEditingController _edCpfCnpj = TextEditingController();
  final TextEditingController _edNome = TextEditingController();
  final TextEditingController _edFantasia = TextEditingController();
  final TextEditingController _edBairro = TextEditingController();
  final TextEditingController _edUf = TextEditingController();
  final TextEditingController _edEndereco = TextEditingController();
  final TextEditingController _edCep = TextEditingController();
  final TextEditingController _edFone = TextEditingController();
  final TextEditingController _edCidade = TextEditingController();
  final TextEditingController _edEmail = TextEditingController();

  static void clearVars() {
    textControllers._edCpfCnpj.clear();
    textControllers._edNome.clear();
    textControllers._edFantasia.clear();
    textControllers._edBairro.clear();
    textControllers._edUf.clear();
    textControllers._edEndereco.clear();
    textControllers._edCep.clear();
    textControllers._edFone.clear();
    textControllers._edCidade.clear();
    textControllers._edEmail.clear();
  }
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
  final FocusNode _edFocusEmail = FocusNode();

  Future<bool> consultaCnpj(String cnpj) async {
    try {
      bool okBool = false;
      cnpj = cnpj.replaceAll(RegExp(r'[^0-9 ]'), "");
      var url = 'http://www.receitaws.com.br/v1/cnpj/$cnpj';
      final response = await http.get(Uri.parse(url));
      String data = response.body;
      if (response.statusCode == 200) {
        if (data != '{"status":"ERROR","message":"CNPJ inválido"}') {
          var parsedJson = json.decode(data);

          // textControllers._edCpfCnpj.value = parsedJson['cnpj'];
          textControllers._edCpfCnpj.text = cnpj;
          textControllers._edNome.text = parsedJson['nome'];
          textControllers._edFantasia.text = parsedJson['fantasia'];
          textControllers._edBairro.text = parsedJson['bairro'];
          textControllers._edUf.text = parsedJson['uf'];
          textControllers._edEndereco.text = parsedJson['logradouro'];
          textControllers._edCep.text = parsedJson['cep'];
          textControllers._edFone.text = parsedJson['telefone'];
          textControllers._edCidade.text = parsedJson['municipio'];
          // textControllers._edEmail.text = parsedJson['email'];
          okBool = true;
        }
      }
      return okBool;
    } catch (e) {
      throw 'Erro na captação do cnpj';
    }
  }

  void fetchVars(Cliente cliente) async {
    List<Cliente> lstcli = await ClientesProvider.loadClientes(cliente.id);
    cliente = lstcli[0];

    textControllers._edCpfCnpj.text = cliente.id;
    textControllers._edNome.text = cliente.nome;
    textControllers._edFantasia.text = cliente.fantasia;
    textControllers._edBairro.text = cliente.bairro;
    textControllers._edUf.text = cliente.uf;
    textControllers._edEndereco.text = cliente.endereco;
    textControllers._edCep.text = cliente.cep;
    textControllers._edFone.text = cliente.telefone;
    textControllers._edCidade.text = cliente.municipio;
    textControllers._edEmail.text = cliente.email;
  }

  void fetchVarsLocal(ResultCep cep) {
    textControllers._edBairro.text = cep.bairro!;
    textControllers._edUf.text = cep.uf!;
    textControllers._edEndereco.text = cep.logradouro!;
    textControllers._edCidade.text = cep.localidade!;
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.settings.arguments != null) {
      final Cliente lstCliente =
          ModalRoute.of(context)!.settings.arguments as Cliente;
      fetchVars(lstCliente);
    } else {
      TextControllers.clearVars();
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
                    edController: textControllers._edCpfCnpj,
                    edFocusNode: _edFocusCpfCnpj,
                    caption: 'CPF ou CNPJ',
                    showClear: true,
                    textInputType:
                        const TextInputType.numberWithOptions(decimal: false),
                  ),
                  const SizedBox(width: 15),
                  IconButton(
                    tooltip: 'Consultar CNPJ na Receita',
                    icon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 30,
                    ),
                    onPressed: () async {
                      String cnpj = textControllers._edCpfCnpj.text
                          .replaceAll(RegExp(r'[^0-9 ]'), "");
                      TextControllers.clearVars();

                      if (cnpj.length != 11 && cnpj.length != 14) {
                        showMessage('Erro no preenchimento do CPF / CNPJ!');
                        return;
                      }

                      List<Cliente> lstCliente =
                          await ClientesProvider.loadClientes(cnpj);
                      if (lstCliente.isNotEmpty) {
                        fetchVars(lstCliente[0]);
                      } else {
                        if (cnpj.length == 11 || cnpj.length == 14) {
                          if (cnpj.length == 11 &&
                              !CPFValidator.isValid(cnpj)) {
                            showMessage('Erro no preenchimento do CPF!');
                          } else {
                            if (cnpj.length == 14 &&
                                !CNPJValidator.isValid(cnpj)) {
                              showMessage('Erro no preenchimento do CNPJ!');
                            } else {
                              if (cnpj.length == 14) {
                                await consultaCnpj(cnpj).then((ok) {
                                  if (!ok) {
                                    showMessage('Cnpj não encontrado!');
                                  }
                                });
                              }
                            }
                          }
                        }
                      }
                    },
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
                      edController: textControllers._edNome,
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
                      edController: textControllers._edFantasia,
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
                      edController: textControllers._edEndereco,
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
                      edController: textControllers._edBairro,
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
                    edController: textControllers._edCep,
                    edFocusNode: _edFocusCep,
                    caption: 'CEP',
                    textFlex: 2,
                    textInputType: TextInputType.number,
                  ),
                  IconButton(
                    tooltip: 'Consultar Cep',
                    icon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 30,
                    ),
                    onPressed: () async {
                      String cep = textControllers._edCep.text
                          .replaceAll(RegExp(r'[^0-9 ]'), "");
                      // clearVars();
                      textControllers._edCep.text = cep;
                      if (cep.length != 8) {
                        showMessage('Erro no preenchimento do CEP!');
                        return;
                      }

                      final resultCep = await ViaCepService.fetchCep(cep: cep);

                      if (resultCep.localidade != null) {
                        fetchVarsLocal(resultCep);
                      } else {
                        showMessage('Cep não encontrado!');
                        return;
                      }
                    },
                  ),
                  TextEditCustom(
                    caption: 'Telefone',
                    edController: textControllers._edFone,
                    edFocusNode: _edFocusFone,
                    textFlex: 3,
                    textInputType: TextInputType.phone,
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
                      edController: textControllers._edCidade,
                      edFocusNode: _edFocusCidade,
                      caption: 'Municipio',
                      textFlex: 3),
                  const SizedBox(width: 15),
                  TextEditCustom(
                      edController: textControllers._edUf,
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
                children: [
                  TextEditCustom(
                      edController: textControllers._edEmail,
                      textInputType: TextInputType.emailAddress,
                      edFocusNode: _edFocusEmail,
                      caption: 'Email',
                      textFlex: 3),
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
                    BotaoBar(
                      iconeBotao: Icons.clear_all,
                      caption: 'Limpar',
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
          if (caption == 'Limpar') {
            TextControllers.clearVars();
          } else if (caption == 'Fechar') {
            Navigator.of(context).pop();
          } else if (caption == 'Gravar') {
            var cliente = Cliente(
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
              textControllers._edEmail.value.text,
            );
            cliente.id = textControllers._edCpfCnpj.value.text;

            ClientesProvider.addReplaceCliente(cliente);
            Navigator.of(context).pop(cliente);
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
  final bool? showClear;
  const TextEditCustom(
      {Key? key,
      required this.caption,
      this.textInputType = TextInputType.text,
      this.textFlex = 1,
      required this.edController,
      required this.edFocusNode,
      this.showClear = false})
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
            suffixIcon: showClear == false
                ? null
                : GestureDetector(
                    onTap: () {
                      edController.clear();
                      // ctrlApp.searchBar.value = '';
                      FocusScope.of(context).unfocus();
                    },
                    child: const Icon(FontAwesomeIcons.eraser,
                        color: corText, size: 20),
                  ),
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
