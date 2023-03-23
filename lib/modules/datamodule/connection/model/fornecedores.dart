import 'package:smartvendas/modules/datamodule/connection/provider/fornecedores_provider.dart';

class Fornecedor {
  String id = '';
  String descricao = '';
  Fornecedor(this.id, this.descricao);

  Map<String, dynamic> toMap() {
    var dados = <String, dynamic>{};
    dados['id'] = id;
    dados['descricao'] = descricao;
    return dados;
  }

  factory Fornecedor.fromMap(Map<String, dynamic> dados, bool toDb) {
    Fornecedor fornecedor = Fornecedor(
      dados['id'],
      dados['descricao'],
    );
    if (toDb) {
      if (fornecedor.id.isNotEmpty) {
        FornecedoresProvider.addReplaceFornecedor(fornecedor);
      }
    }
    return fornecedor;
  }

  Fornecedor.mapToModel(Map<String, dynamic> dados) {
    id = dados['id'];
    descricao = dados["nome"];
  }
}
