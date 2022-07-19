import 'package:smartvendas/modules/datamodule/connection/provider/categorias_provider.dart';

class Categoria {
  String id = '';
  String descricao = '';
  Categoria(this.id, this.descricao);

  Map<String, dynamic> toMap() {
    var dados = <String, dynamic>{};
    dados['id'] = id;
    dados['descricao'] = descricao;
    return dados;
  }

  factory Categoria.fromMap(Map<String, dynamic> dados, bool toDb) {
    Categoria categoria = Categoria(
      dados['id'],
      dados['descricao'],
    );
    if (toDb) {
      CategoriasProvider.addReplaceCategoria(categoria);
    }
    return categoria;
  }

  Categoria.mapToModel(Map<String, dynamic> dados) {
    id = dados['id'];
    descricao = dados["descricao"];
  }
}
