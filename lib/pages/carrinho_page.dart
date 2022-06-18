import 'package:flutter/material.dart';
import 'package:loja_virtual/models/carrinho_model.dart';
import 'package:loja_virtual/models/usuario_model.dart';
import 'package:loja_virtual/pages/login_page.dart';
import 'package:loja_virtual/pages/pedido_page.dart';
import 'package:loja_virtual/widgets/carrinho_valor_compra_card.dart';
import 'package:loja_virtual/widgets/disconto_card.dart';
import 'package:loja_virtual/widgets/frete_card.dart';
import 'package:scoped_model/scoped_model.dart';
import '../tile/produto_do_carrinho_tile.dart';

class CarrinhoPage extends StatelessWidget {
  const CarrinhoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Carrinho"),
        centerTitle: true,
        actions: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 10),
            child: ScopedModelDescendant<CarrinhoModel>(
              builder: (context, child, model) {
                int numIntens = model.listaProdutosDoCarrinho.length;
                return Text(
                  '${numIntens ?? 0} ${numIntens == 1 ? 'ITEM' : 'Itens'}',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                );
              },
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CarrinhoModel>(
        builder: (context, child, model) {
          if (model.carregandoProdutos &&
              UsuarioModel.of(context).usuarioEstaOuNaoLogado()) {
            //se esta carregango os produtos e o usuario esta logado
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          } else if (!UsuarioModel.of(context).usuarioEstaOuNaoLogado()) {
            //se o usuario nao esta logado
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                //centraliza na vertical
                mainAxisAlignment: MainAxisAlignment.center,
                //preenche o espaço possivel na horizontal
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Faça o login para adicionar produtos!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      child: Text("Entrar"),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                          fontSize: 18,
                        ),
                        primary: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          } else if (model.listaProdutosDoCarrinho == null ||
              model.listaProdutosDoCarrinho.length == 0) {
            //se o usuario esta logado e o carrinho esta vazio
            return Center(
              child: Text(
                "Nenhum produto no carrinho!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            //se o usuario esta logado e o carrinho não esta vazio
            return ListView(
              children: [
                Column(
                  children: model.listaProdutosDoCarrinho.map((e) {
                    return ProdutoDoCarrinhoTile(carrinhoProduto: e);
                  }).toList(),
                ),
                DiscontoCard(),
                FreteCard(),
                ValorCompraCard(
                  finalizarPedido: () async {
                    String? idPedido = await model.finalizarPedido();
                    if (idPedido != null) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => PedidoPage(
                          idPedido: idPedido,
                        ),
                      ));
                    }
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
