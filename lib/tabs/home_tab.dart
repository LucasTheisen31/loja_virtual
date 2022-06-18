import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  HomeTab({Key? key}) : super(key: key);

  Widget _buildBodyBack() => Container(
        //fundo degrade
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 211, 118, 130),
            const Color.fromARGB(255, 253, 181, 168),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      //uma pilha de widgets, um ira sobrepor o outro
      children: [
        _buildBodyBack(), //fundo degrade
        CustomScrollView(
          slivers: [
            SliverAppBar(
              //app bar que some e aparece conforme arrasta a tela
              floating: true,
              //app bar flutuante
              snap: true,
              //quando deslizar de volta a barra ja aparece novamente
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('Novidades'),
                centerTitle: true,
              ),
            ),
            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              //future builder pois os dados nao sao carregados instantaneamente do firebase, e emquanto nao carrega tem que exibir algo na tela
              future: FirebaseFirestore.instance
                  .collection('home')
                  .orderBy('posicao')
                  .get(),
              builder: (context, snapshot) {
                //funcao que vai criar o que vai ter na tela de acordo com o que future retornar
                if (!snapshot.hasData) {
                  //se nao retornar dados
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    ),
                  );
                } else {
                  return SliverStaggeredGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    staggeredTiles: snapshot.data!.docs.map((e) {
                      return StaggeredTile.count(
                          e.data()['largura'], e.data()['altura']+.0);
                    }).toList(),
                    children: snapshot.data!.docs.map((e) {
                      return FadeInImage.memoryNetwork(
                        //FadeInImage carrega as imagens lentamente
                        placeholder: kTransparentImage,
                        image: e.data()['imagem'],
                        fit: BoxFit.cover,
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
