import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/pages/categoria_page.dart';

class CategoriaTile extends StatelessWidget {
  const CategoriaTile({Key? key, required this.snapshot}) : super(key: key);

  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(
          snapshot.get('icone'),
        ),
      ),
      title: Text(snapshot.get('titulo')),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        //sempre que clicar nesta categoria vai executar o codigo abaixo
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CategoriaPage(snapshot: snapshot),
          ),
        );
      },
    );
  }
}
