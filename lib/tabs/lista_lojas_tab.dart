import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../tile/loja_tile.dart';

class ListaLojasTab extends StatelessWidget {
  const ListaLojasTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      //obtem do firebase a lista de documentos, cada codumento é uma loja
      //QuerySnapshot pois estamos buscando mais de um documento(loja) por vez
      future: FirebaseFirestore.instance.collection('lojas').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          //se nao tem dados ainda
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        } else {
          return ListView(
            scrollDirection: Axis.vertical,
            /*transforma cada um dos documentos um um widget do tipo LojaTile, cada LojaTile recebe o documento com os dados referente a loja
            e depois transforma todos essses widgets em uma lista pois o ListView quer uma lista de Widgets
             */
            children: snapshot.data!.docs.map((e) => LojaTile(documentSnapshot: e)).toList(),
          );
        }
      },
    );
  }
}
