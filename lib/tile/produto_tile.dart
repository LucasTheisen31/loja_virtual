import 'package:flutter/material.dart';
import 'package:loja_virtual/dados/dados_produto.dart';

import '../models/carrinho_model.dart';
import '../pages/produto_page.dart';

class ProdutoTile extends StatelessWidget {
  const ProdutoTile({Key? key, required this.tipo, required this.produto})
      : super(key: key);

  final String tipo; //Grid ou List
  final DadosProduto produto;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      //igual o gestureDetector mas o InkWell tem uma animação de toque
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProdutoPage(produto: produto),
        ));
      },
      child: Card(
        color: Colors.white,
        child: tipo == 'grid'
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //para presencher o espaço disponivel
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AspectRatio(
                    aspectRatio: 0.8, //largura dividido pea altura
                    child: Image.network(
                      produto.imagens![0],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    //para os textos ocuparem o espaço que restar do card
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            produto.titulo!,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,//estouro de texto
                          ),
                          Text(
                            'R\$ ${produto.preco!.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  //os dois flexible vao dividir o espaço igualmente pois ambos tem flex = 1
                  Flexible(
                    flex: 1,
                    child: Image.network(
                      produto.imagens![0],
                      fit: BoxFit.cover,
                      height: 250,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            produto.titulo!,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'R\$ ${produto.preco!.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
