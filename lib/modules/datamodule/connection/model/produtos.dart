import 'package:smartvendas/modules/datamodule/connection/provider/produtos_provider.dart';
import 'package:smartvendas/shared/funcoes.dart';
import 'package:smartvendas/shared/variaveis.dart';

class Produto {
  String id = '';
  String descricao = '';
  String idcategoria = '';
  String idfornecedor = '';
  String barras = '';
  double qte = 0;
  double estoque = 0;
  int qteminatacado = 0;
  double custo = 0.00;
  double preco = 0.00;
  double atacado = 0.00;

  String volume = '';
  double qtevolume = 0;
  String unidade = '';
  String valorfmt = '';
  String atacadofmt = '';
  String imagem = '';
  Produto(
    this.id,
    this.descricao,
    this.idcategoria,
    this.idfornecedor,
    this.barras,
    this.qte,
    this.estoque,
    this.qteminatacado,
    this.custo,
    this.preco,
    this.atacado,
    this.volume,
    this.qtevolume,
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
      throw ("Produtos model$exception$dados");
    }
  }

  Map<String, dynamic> toMap() {
    var dados = <String, dynamic>{};

    dados['id'] = id;
    dados['descricao'] = descricao;
    dados['idcategoria'] = idcategoria;
    dados['idfornecedor'] = idfornecedor;
    dados['barras'] = barras;
    dados['qte'] = qte;
    dados['estoque'] = estoque;
    dados['qteminatacado'] = qteminatacado;
    dados['custo'] = custo;
    dados['preco'] = preco;
    dados['atacado'] = atacado;
    dados['volume'] = volume;
    dados['qtevolume'] = qtevolume;
    dados['unidade'] = unidade;
    dados['valorfmt'] = valorfmt;
    dados['atacadofmt'] = atacadofmt;
    return dados;
  }

  Produto.mapToModel(Map<String, dynamic> dados) {
    try {
      id = dados['id'];
      descricao = dados['descricao'];
      idcategoria = dados['idcategoria'];
      idfornecedor = dados['idfornecedor'] ?? '';
      barras = dados['barras'] ?? '';
      qteminatacado = Funcoes.strToInt(dados['qteminatacado']);
      qte = Funcoes.strToFloat(dados['qte']);
      estoque = Funcoes.strToFloat(dados['estoque']);
      atacado = Funcoes.strToFloat(dados['atacado']);
      custo = Funcoes.strToFloat(dados['custo']);
      preco = Funcoes.strToFloat(dados['preco']);
      volume = dados['volume'] ?? 'UND';
      qtevolume = Funcoes.strToFloat(dados['qtevolume'] ?? '1');
      unidade = dados['unidade'] ?? 'UND';
      valorfmt = formatter.format(preco);
      atacadofmt = formatter.format(atacado);
      imagem = dados['imagem'] ?? '';
    } catch (exception) {
      throw ("Produtos model$exception$dados");
    }
  }

  Produto.clear() {
    id = '';
    descricao = '';
    idcategoria = '';
    idfornecedor = '';
    barras = '';
    qteminatacado = 0;
    qte = 0;
    estoque = 0;
    atacado = 0;
    custo = 0;
    preco = 0;
    volume = '';
    qtevolume = 0;
    unidade = '';
    valorfmt = '';
    atacadofmt = '';
    imagem = '';
  }
}
