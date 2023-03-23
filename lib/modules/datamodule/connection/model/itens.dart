import 'package:smartvendas/modules/datamodule/connection/provider/itens_provider.dart';
import 'package:smartvendas/shared/funcoes.dart';

class Item {
  String id = '';
  String idpedido = '';
  String idproduto = '';
  String descricao = '';
  String unidade = '';
  double qtde = 0;
  int qteminatacado = 0;
  double valor = 0.00;
  double atacado = 0.00;
  String totalfmt = '';
  int enviado = 0;
  Item(
    this.id,
    this.idpedido,
    this.idproduto,
    this.descricao,
    this.unidade,
    this.qtde,
    this.qteminatacado,
    this.valor,
    this.atacado,
    this.totalfmt,
    this.enviado,
  );
  Map toJson() => {
        'id': id,
        'idpedido': idpedido,
        'idproduto': idproduto,
        'descricao': descricao,
        'unidade': unidade,
        'qtde': qtde,
        'qteminatacado': qteminatacado,
        'valor': valor,
        'atacado': atacado,
        'totalfmt': totalfmt,
        'enviado': enviado,
      };
  factory Item.fromMap(Map<String, dynamic> dados, bool toDb) {
    Item item = Item(
      dados['id'],
      dados['idpedido'],
      dados['idproduto'],
      dados['descricao'] ?? '',
      dados['unidade'] ?? '',
      Funcoes.strToFloat(dados['qtde'].toString()),
      dados['qteminatacado'],
      dados['valor'],
      dados['atacado'],
      dados['totalfmt'],
      dados['enviado'],
    );
    if (toDb) {
      ItensProvider.addUpdateItem(item);
    }
    return item;
  }

  Map<String, dynamic> toMap() {
    var dados = <String, dynamic>{};

    dados['id'] = id;
    dados['idpedido'] = idpedido;
    dados['idproduto'] = idproduto;
    dados['descricao'] = descricao;
    dados['unidade'] = unidade;
    dados['qtde'] = qtde;
    dados['qteminatacado'] = qteminatacado;
    dados['valor'] = valor;
    dados['atacado'] = atacado;
    dados['totalfmt'] = totalfmt;
    dados['enviado'] = enviado;
    return dados;
  }

  Item.mapToModel(Map<String, dynamic> dados) {
    id = dados['id'];
    idpedido = dados['idpedido'];
    idproduto = dados['idproduto'];
    descricao = dados['descricao'];
    unidade = dados['unidade'];
    qtde = dados['qtde'];
    qteminatacado = dados['qteminatacado'];
    valor = dados['valor'];
    atacado = dados['atacado'];
    totalfmt = dados['totalfmt'];
    enviado = dados['enviado'];
  }
}
