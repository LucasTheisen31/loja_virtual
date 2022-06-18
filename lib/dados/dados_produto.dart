
import 'package:cloud_firestore/cloud_firestore.dart';

class DadosProduto {
  //atributos
  String? categoria;
  String? id;
  String? titulo;
  String? descricao;
  double? preco;
  List? imagens;
  List? tamanhos;

  DadosProduto.fromDocument(DocumentSnapshot snapshot) {
    //convertendo um documento em um objeto
    id = snapshot.id;
    titulo = snapshot.get('titulo');
    descricao = snapshot.get('descricao');
    preco = snapshot.get('preco') + 0; //pois é um double
    imagens = snapshot.get('imagens');
    tamanhos = snapshot.get('tamanhos');
  }

  Map<String, dynamic> toResumedMap(){
    //cria um mapa com dados resumidos
    return {
      'titulo': titulo,
      'descricao': descricao,
      'preco': preco,
    };
  }
}
