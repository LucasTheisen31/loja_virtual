import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/dados/carrinho_produto.dart';
import 'package:loja_virtual/models/usuario_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CarrinhoModel extends Model {
  UsuarioModel? usuario;

  List<CarrinhoProduto> listaProdutosDoCarrinho = [];

  String? cupomDesconto;

  int porcentagemDesconto = 0;

  bool carregandoProdutos = false;

  //encontrar o Modelfornecido pelo ScopedModel diretamente ScopedModel.of<tipoObjeto>
  static CarrinhoModel of(BuildContext context) =>
      ScopedModel.of<CarrinhoModel>(context);

  CarrinhoModel({required this.usuario}) {
    //construtor
    //se o ususario esta logado, chama a funcao para carregar a lista de produtos do carinho deste usuario
    if (usuario!.usuarioEstaOuNaoLogado()) {
      _carregarProdutosCarrinho();
    }
  }

  Future<void> _carregarProdutosCarrinho() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuario!.firebaseUsuario!.uid)
        .collection('carrinhoCompras')
        .get();
    //transformando cada documento retornado do firebase em um objeto CarrinhoProduto e retornando uma lista
    //com todos esees CarrinhoProduto e armazenando na listaProdutosDoCarrinho
    listaProdutosDoCarrinho =
        query.docs.map((e) => CarrinhoProduto.fromDocument(e)).toList();
    notifyListeners();
  }

  void aplicarDesconto({String? cupom, required int pocentagem}) {
    this.cupomDesconto = cupom;
    this.porcentagemDesconto = pocentagem;
    notifyListeners();
  }

  void addProdutoCarrinho(CarrinhoProduto carrinhoProduto) {
    listaProdutosDoCarrinho.add(carrinhoProduto);

    FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuario!.firebaseUsuario!.uid)
        .collection('carrinhoCompras')
        .add(carrinhoProduto.toMap())
        .then((value) {
      carrinhoProduto.idCarrinho = value
          .id; //salva o id do codumento(um produto ao carrinho) adicionado no firebase
    });
    notifyListeners(); //notifica que um novo produto foi add ao carrinho
  }

  void incrementarQuantidade({required CarrinhoProduto produtoDoCarrinho}) {
    produtoDoCarrinho.quantidade++;
    FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuario!.firebaseUsuario!.uid)
        .collection('carrinhoCompras')
        .doc(produtoDoCarrinho.idCarrinho)
        .update(produtoDoCarrinho.toMap());
    notifyListeners();
  }

  void decrementarQuantidade({required CarrinhoProduto produtoDoCarrinho}) {
    produtoDoCarrinho.quantidade--;
    FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuario!.firebaseUsuario!.uid)
        .collection('carrinhoCompras')
        .doc(produtoDoCarrinho.idCarrinho)
        .update(produtoDoCarrinho.toMap());
    notifyListeners();
  }

  void removeProdutoCarrinho(CarrinhoProduto carrinhoProduto) {
    FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuario!.firebaseUsuario!.uid)
        .collection('carrinhoCompras')
        .doc(carrinhoProduto.idCarrinho)
        .delete();
    listaProdutosDoCarrinho.remove(carrinhoProduto);
    notifyListeners(); //notifica que um produto foi removido do corrinho
  }

  void atualizarPrecos() {
    notifyListeners();
  }

  double getValorProdutosDoCarrinho() {
    double valor = 0;
    for (CarrinhoProduto c in listaProdutosDoCarrinho) {
      if (c.dadosProduto != null) {
        valor += c.quantidade * c.dadosProduto!.preco!;
      }
    }
    //notifyListeners();
    return valor;
  }

  double getValorDesconto() {
    return getValorProdutosDoCarrinho() * porcentagemDesconto / 100;
  }

  double getValorFrete() {
    return 10;
  }

  Future<String?> finalizarPedido() async {
    if (listaProdutosDoCarrinho.isEmpty) {
      return null;
    }

    carregandoProdutos = true;
    notifyListeners();

    double valorCompra = getValorProdutosDoCarrinho();
    double valorFrete = getValorFrete();
    double valorDesconto = getValorDesconto();
    double valorTotal = valorCompra - valorDesconto + valorFrete;

    DocumentReference<Map<String, dynamic>> referenciaDoPedido =
        await FirebaseFirestore.instance.collection('pedidos').add({
      //referenciaDoPedido tem o id do doocumento criado referente ao pedido
      'clienteID': usuario!.firebaseUsuario!.uid,
      'produtos': listaProdutosDoCarrinho
          .map((carrinhoProduto) => carrinhoProduto.toMap())
          .toList(),
      'valorCompra': valorCompra,
      'valorFrete': valorFrete,
      'valorDesconto': valorDesconto,
      'valorTotal': valorTotal,
      'statusDoPedido': 1,
    });

    //referenciaDoPedido tem o id do doocumento criado referente ao pedido
    //Linka o ID do pedido feito dentro do usuario
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuario!.firebaseUsuario!.uid)
        .collection('pedidos')
        .doc(referenciaDoPedido.id)
        .set({
      'idPedido': referenciaDoPedido.id,
    });

    //busca todos os ducomentos(produtos) do carrinho do ususario
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuario!.firebaseUsuario!.uid)
        .collection('carrinhoCompras')
        .get();
    //deleta todos os ducomentos(produtos) do carrinho do ususario
    for (DocumentSnapshot doc in query.docs) {
      doc.reference.delete();
    }
    //limpa a listaProdutosDoCarrinho
    listaProdutosDoCarrinho.clear();

    cupomDesconto = null;
    porcentagemDesconto = 0;

    carregandoProdutos = false;
    notifyListeners();

    return referenciaDoPedido.id;
  }
}
