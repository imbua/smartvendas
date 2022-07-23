import 'package:smartvendas/modules/datamodule/connection/provider/formapgto_provider.dart';

class FormaPgto {
  String id = '';
  String descricao = '';
  FormaPgto(this.id, this.descricao);

  Map<String, dynamic> toMap() {
    var dados = <String, dynamic>{};
    dados['id'] = id;
    dados['descricao'] = descricao;
    return dados;
  }

  factory FormaPgto.fromMap(Map<String, dynamic> dados, bool toDb) {
    FormaPgto formapgto = FormaPgto(
      dados['id'],
      dados['descricao'],
    );
    if (toDb) {
      FormaPgtoProvider.addReplaceFormaPgto(formapgto);
    }
    return formapgto;
  }

  FormaPgto.mapToModel(Map<String, dynamic> dados) {
    id = dados['id'];
    descricao = dados["descricao"];
  }
}
