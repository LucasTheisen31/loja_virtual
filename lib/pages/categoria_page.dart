import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../dados/dados_produto.dart';
import '../tile/produto_tile.dart';
import '../widgets/carrinho_button.dart';

class CategoriaPage extends StatelessWidget {
  const CategoriaPage({Key? key, required this.snapshot}) : super(key: key);

  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(snapshot.get('titulo')),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white, //cor do icone da tab selecionada
            tabs: [
              Tab(
                icon: Icon(
                  Icons.grid_on,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.list,
                ),
              ),
            ],
          ),
        ),
        body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance //aonde sera pego os dados
              .collection('produtos')
              .doc(snapshot.id)
              .collection('Items')
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              //se nao contem nenhum dado
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              );
            } else {
              return TabBarView(
                //desativa a fisica de mudar as tab arrastando para o lado cm o dedo
                //physics: NeverScrollableScrollPhysics(),
                children: [
                  GridView.builder(
                    //.builder é para nao carregar todos os items ao mesmo tempo, somente comforme vai rolando a pagina
                    padding: EdgeInsets.all(4),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      // gridDelegate definimos como os itens serao exibidos na tela
                      crossAxisCount: 2, //num de items na horizontal
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: snapshot.data?.docs.length, //numero de items
                    itemBuilder: (context, index) {
                      //os items que seram exibidos
                      DadosProduto dados =
                          DadosProduto.fromDocument(snapshot.data!.docs[index]);
                      dados.categoria = this
                          .snapshot
                          .id; //salva o id da categoria dos produtos
                      return ProdutoTile(tipo: 'grid', produto: dados);
                    },
                  ),
                  //segunda tab ira exibir os item em LISTA
                  ListView.builder(
                    //.builder é para nao carregar todos os items ao mesmo tempo, somente comforme vai rolando a pagina
                    padding: EdgeInsets.all(4),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      //os items que seram exibidos
                      DadosProduto dados =
                          DadosProduto.fromDocument(snapshot.data!.docs[index]);
                      dados.categoria = this
                          .snapshot
                          .id; //salva o id da categoria dos produtos
                      return ProdutoTile(tipo: 'list', produto: dados);
                    },
                  )
                ],
              );
            }
          },
        ),
        floatingActionButton: CarrinhoButton(),
      ),
    );
  }
}
