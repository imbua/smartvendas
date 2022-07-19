import 'package:smartvendas/modules/datamodule/connection/provider/produtos_provider.dart';
import 'package:smartvendas/shared/funcoes.dart';
import 'package:smartvendas/shared/variaveis.dart';

class Produto {
  String id = '';
  String descricao = '';
  String idcategoria = '';
  String barras = '';
  int qte = 0;
  int estoque = 0;
  int qteminatacado = 0;

  double preco = 0.00;
  double atacado = 0.00;

  String unidade = '';
  String valorfmt = '';
  String atacadofmt = '';
  String imagem = '';
  Produto(
    this.id,
    this.descricao,
    this.idcategoria,
    this.barras,
    this.qte,
    this.estoque,
    this.qteminatacado,
    this.preco,
    this.atacado,
    this.unidade,
    this.valorfmt,
    this.atacadofmt,
    this.imagem,
  );

  factory Produto.fromMap(Map<String, dynamic> dados, bool toDb) {
    try {
      Produto produto = Produto.mapToModel(dados);

      if (toDb) {
        ProdutosProvider.addReplaceProduto(produto);
      }
      return produto;
    } catch (exception) {
      throw ("Produtos model" + exception.toString() + dados.toString());
    }
  }

  Map<String, dynamic> toMap() {
    var dados = <String, dynamic>{};

    dados['id'] = id;
    dados['descricao'] = descricao;
    dados['idcategoria'] = idcategoria;
    dados['barras'] = barras;
    dados['qte'] = qte;
    dados['estoque'] = estoque;
    dados['qteminatacado'] = qteminatacado;
    dados['preco'] = preco;
    dados['atacado'] = atacado;
    dados['unidade'] = unidade;
    dados['valorfmt'] = valorfmt;
    dados['atacadofmt'] = atacadofmt;
    return dados;
  }

  Produto.mapToModel(Map<String, dynamic> dados) {
    id = dados['id'];
    descricao = dados['descricao'];
    idcategoria = dados['idcategoria'];
    barras = dados['barras'] ?? '';
    qteminatacado = Funcoes.strToInt(dados['qteminatacado']);
    qte = Funcoes.strToInt(dados['qte']);
    estoque = Funcoes.strToInt(dados['estoque']);
    atacado = Funcoes.strToFloat(dados['atacado']);
    preco = Funcoes.strToFloat(dados['preco']);
    unidade = dados['unidade'];
    valorfmt = formatter.format(preco);
    atacadofmt = formatter.format(atacado);
    imagem = dados['imagem'] ?? '';
  }

  Produto.clear() {
    id = '';
    descricao = '';
    idcategoria = '';
    barras = '';
    qteminatacado = 0;
    qte = 0;
    estoque = 0;
    atacado = 0;
    preco = 0;
    unidade = '';
    valorfmt = '';
    atacadofmt = '';
    imagem = '';
  }
}
