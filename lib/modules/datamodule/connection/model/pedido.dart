import 'package:smartvendas/modules/datamodule/connection/provider/pedidos_provider.dart';

class Pedido {
  String id = '';
  String idvendedor = '';
  String nomevendedor = '';
  String idcliente = '';
  String nomecliente = '';
  String datapedido = '';
  double total = 0.00;
  String totalfmt = '';
  int enviado = 0;
  String formapgto = '';
  String observacao = '';

  Pedido(
    this.id,
    this.idvendedor,
    this.nomevendedor,
    this.idcliente,
    this.nomecliente,
    this.datapedido,
    this.total,
    this.totalfmt,
    this.enviado,
    this.formapgto,
    this.observacao,
  );

  Map toJson() => {
        'id': id,
        'idvendedor': idvendedor,
        'nomevendedor': nomevendedor,
        'idcliente': idcliente,
        'nomecliente': nomecliente,
        'datapedido': datapedido,
        'total': total,
        'totalfmt': totalfmt,
        'enviado': enviado,
        'formapgto': formapgto,
      };

  factory Pedido.fromMap(Map<String, dynamic> dados, bool toDb) {
    Pedido pedido = Pedido(
      dados['id'],
      dados['idvendedor'],
      dados['nomevendedor'] ?? '',
      dados['idcliente'],
      dados['nomecliente'],
      dados['datapedido'],
      dados['total'],
      dados['totalfmt'],
      dados['enviado'],
      dados['formapgto'],
      dados['observacao'],
    );
    if (toDb) {
      PedidosProvider.addUpdatePedido(pedido);
    }
    return pedido;
  }

  Map<String, dynamic> toMap() {
    var dados = <String, dynamic>{};

    dados['id'] = id;
    dados['idvendedor'] = idvendedor;
    dados['nomevendedor'] = nomevendedor;
    dados['idcliente'] = idcliente;
    dados['nomecliente'] = nomecliente;
    dados['datapedido'] = datapedido;
    dados['total'] = total;
    dados['totalfmt'] = totalfmt;
    dados['enviado'] = enviado;
    dados['formapgto'] = formapgto;
    dados['observacao'] = observacao;
    return dados;
  }

  Pedido.mapToModel(Map<String, dynamic> dados) {
    id = dados['id'];
    idvendedor = dados['idvendedor'];
    nomevendedor = dados['nomevendedor'];
    idcliente = dados['idcliente'];
    nomecliente = dados['nomecliente'];
    datapedido = dados['datapedido'];
    total = dados['total'];
    totalfmt = dados['totalfmt'];
    enviado = dados['enviado'];
    formapgto = dados['formapgto'];
    observacao = dados['observacao'];
  }
}
