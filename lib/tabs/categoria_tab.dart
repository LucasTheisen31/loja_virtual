import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/tile/categoria_tile.dart';


class CategoriaTab extends StatelessWidget {
  const CategoriaTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('produtos').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          //se nao tiver dados
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        } else {
          var dividedTiles = ListTile.divideTiles(
            //troca cada documento por um CategoriaTile e depois transforma tudo em uma lista
            tiles: snapshot.data!.docs.map((e) {
              return CategoriaTile(snapshot: e);
            }).toList(),
            color: Colors.grey.shade500, //cor do divisor
          ).toList(); //transforma tudo em uma lista para exibir abaixo no ListView

          return ListView(
            children: dividedTiles,
          );
        }
      },
    );
  }
}
