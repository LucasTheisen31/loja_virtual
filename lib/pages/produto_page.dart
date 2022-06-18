import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/dados/carrinho_produto.dart';
import 'package:loja_virtual/dados/dados_produto.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:loja_virtual/models/carrinho_model.dart';
import 'package:loja_virtual/models/usuario_model.dart';
import 'package:loja_virtual/pages/carrinho_page.dart';
import 'package:loja_virtual/pages/login_page.dart';

class ProdutoPage extends StatefulWidget {
  const ProdutoPage({Key? key, required this.produto}) : super(key: key);

  final DadosProduto produto;

  @override
  //passando o produto para o State
  State<ProdutoPage> createState() => _ProdutoPageState(produto);
}

class _ProdutoPageState extends State<ProdutoPage> {
  //construtor
  _ProdutoPageState(this.produto);

  //atributos
  final DadosProduto produto;
  int _indiceAtual = 0;
  String? _tamanhoSelecionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(produto.titulo!),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 0.9, //largura dividido pela altura
            child: CarouselSlider(
              //Um widget de controle deslizante de carrossel
              items: produto.imagens!.map((e) {
                return Image.network(
                  e,
                  fit: BoxFit.cover,
                );
              }).toList(),
              options: CarouselOptions(
                  initialPage: 0,
                  height: 400,
                  //autoPlay: true,
                  viewportFraction: 1,
                  //autoPlayInterval: Duration(seconds: 4),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _indiceAtual = index;
                    });
                  }),
            ),
          ),
          //dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: produto.imagens!.map((e) {
              int index = produto.imagens!.indexOf(e);
              return Container(
                width: 10.0,
                height: 10.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _indiceAtual == index
                      ? Theme.of(context).primaryColor
                      : Color.fromRGBO(0, 0, 0, 0.3),
                ),
              );
            }).toList(),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              //todos os widgets da coluna vai tentar ocupar o maximo espaço horizontal
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  produto.titulo!,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3, //texto vai ocupar no maximo 3 linhas
                ),
                Text(
                  'R\$ ${produto.preco!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Tamanho',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 34,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    scrollDirection: Axis.horizontal, //na horizontal
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        //1 linha
                        mainAxisSpacing: 8,
                        //neste caso o eixo principal é o eixo horizontal
                        childAspectRatio: 0.5 //altura / largura
                        ),
                    children: produto.tamanhos!.map((e) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _tamanhoSelecionado = e;
                          });
                        },
                        child: Container(
                          width: 50, //largura do container
                          alignment: Alignment.center, //alinhamento do child
                          decoration: BoxDecoration(
                            //formato do container
                            borderRadius: BorderRadius.circular(4),
                            //borda ao redor
                            border: Border.all(
                              color: e == _tamanhoSelecionado
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade500,
                              width: 3,
                            ),
                          ),
                          child: Text(e),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 44,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _tamanhoSelecionado != null
                        ? () {
                            if (UsuarioModel.of(context)
                                .usuarioEstaOuNaoLogado()) {
                              CarrinhoProduto carrinhoProduto =
                                  CarrinhoProduto();
                              carrinhoProduto.idProduto = produto.id;
                              carrinhoProduto.categoriaProduto =
                                  produto.categoria;
                              carrinhoProduto.quantidade = 1;
                              carrinhoProduto.tamanho = _tamanhoSelecionado;
                              carrinhoProduto.dadosProduto = produto;
                              CarrinhoModel.of(context).addProdutoCarrinho(carrinhoProduto);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CarrinhoPage(),
                                ),
                              );
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ));
                            }
                          }
                        : null,
                    child: Text(
                        UsuarioModel.of(context).usuarioEstaOuNaoLogado()
                            ? 'Adicionar ao Carrinho'
                            : 'Entre para Comprar'),
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(fontSize: 18, color: Colors.white),
                      primary: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Descrição',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  produto.descricao!,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
