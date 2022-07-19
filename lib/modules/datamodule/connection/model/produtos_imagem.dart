import 'package:smartvendas/modules/datamodule/connection/provider/produtosimagem_provider.dart';

class ProdutosImagem {
  String id = '';
  String imagem = '';
  ProdutosImagem(this.id, this.imagem);

  Map<String, dynamic> toMap() {
    var dados = <String, dynamic>{};
    dados['id'] = id;
    dados['imagem'] = imagem;
    return dados;
  }

  factory ProdutosImagem.fromMap(Map<String, dynamic> dados, bool toDb) {
    ProdutosImagem produtosimagem = ProdutosImagem.mapToModel(dados);
    if (toDb) {
      ProdutosImagemProvider.addReplaceProdutosImagem(produtosimagem);
    }
    return produtosimagem;
  }

  ProdutosImagem.mapToModel(Map<String, dynamic> dados) {
    id = dados['produto'];
    imagem = dados["imagem"];
  }
}
