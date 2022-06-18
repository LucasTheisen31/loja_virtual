import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/dados/carrinho_produto.dart';
import 'package:loja_virtual/dados/dados_produto.dart';
import 'package:loja_virtual/models/carrinho_model.dart';

class ProdutoDoCarrinhoTile extends StatelessWidget {
  const ProdutoDoCarrinhoTile({Key? key, required this.carrinhoProduto})
      : super(key: key);

  final CarrinhoProduto carrinhoProduto;

  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      //wiget para mostrar os dados do produto
      //CarrinhoModel.of(context).atualizarPrecos assim que carregar os precos do produtos vai pedir para atualizar a pagina
      CarrinhoModel.of(context).atualizarPrecos;
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            width: 120,
            child: Image.network(
              carrinhoProduto.dadosProduto!.imagens![0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    carrinhoProduto.dadosProduto!.titulo!,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    carrinhoProduto.dadosProduto!.descricao!,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Tamanho: ${carrinhoProduto.tamanho}",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    "R\$ ${carrinhoProduto.dadosProduto!.preco!.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Row(
                    // espaço livre uniformemente entre o widget filho
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed:
                            carrinhoProduto.quantidade > 1 ? () {
                              CarrinhoModel.of(context).decrementarQuantidade(produtoDoCarrinho: carrinhoProduto);
                            } : null,
                        icon: Icon(
                          Icons.remove,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        carrinhoProduto.quantidade.toString(),
                      ),
                      IconButton(
                        onPressed: () {
                          CarrinhoModel.of(context).incrementarQuantidade(produtoDoCarrinho: carrinhoProduto);
                        },
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          CarrinhoModel.of(context).removeProdutoCarrinho(carrinhoProduto);
                        },
                        child: Text(
                          "Remover",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      );
    }

    return Card(
      //(margin) espaçamento do lado de fora do widget
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: carrinhoProduto.dadosProduto == null
          ? FutureBuilder<DocumentSnapshot>(
              //se nao tem os dados do produto carregados vai busca esses dados
              future: FirebaseFirestore.instance
                  .collection('produtos')
                  .doc(carrinhoProduto.categoriaProduto)
                  .collection('Items')
                  .doc(carrinhoProduto.idProduto)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //se temDados
                  //converte o documento em um objeto e armazenana em carrinhoProduto.dadosProduto
                  carrinhoProduto.dadosProduto =
                      DadosProduto.fromDocument(snapshot.data!);
                  return _buildContent(); //mostra estes dados
                } else {
                  //se nao tiver dados, ou seja se tiver carregando os dados ainda mostra um CircularProgressIndicator
                  return Container(
                    height: 70,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                }
              },
            )
          :
          //se ja tiver os dados do produto carregado, somente ira exibur estes dados
          _buildContent(), //mostra estes dados
    );
  }
}
