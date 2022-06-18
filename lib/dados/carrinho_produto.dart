

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dados_produto.dart';

class CarrinhoProduto {
  String? idCarrinho;
  String? categoriaProduto;
  String? idProduto;
  late int quantidade;
  String? tamanho;
  DadosProduto? dadosProduto;


  CarrinhoProduto();//construtor vazio

  CarrinhoProduto.fromDocument(DocumentSnapshot snapshot) {
    //convertendo um documento em um objeto
    idCarrinho = snapshot.id;
    categoriaProduto = snapshot.get('categoria');
    idProduto = snapshot.get('idProduto');
    quantidade = snapshot.get('quantidade');
    tamanho = snapshot.get('tamanho');
  }

  Map<String, dynamic> toMap(){
    //cria um mapa a partir de um objeto para poder salvar no banco de dados
    return{
      'categoria': categoriaProduto,
      'idProduto': idProduto,
      'quantidade': quantidade,
      'tamanho': tamanho,
      'produto': dadosProduto!.toResumedMap(),
    };
  }
}
