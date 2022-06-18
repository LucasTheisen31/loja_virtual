import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LojaTile extends StatelessWidget {
  const LojaTile({Key? key, required this.documentSnapshot}) : super(key: key);

  final DocumentSnapshot documentSnapshot;

  @override
  Widget build(BuildContext context) {
    return Card(
      //espacamento fora do card
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 100,
            child: Image.network(
              documentSnapshot.get('imagem'),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  documentSnapshot.get('titulo'),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  documentSnapshot.get('endereco'),
                  style: TextStyle(),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  launch('https://www.google.com/maps/search/?api=1&query=${documentSnapshot.get('latitude')},${documentSnapshot.get('longitude')}');
                },
                child: Text(
                  "Ver no Mapa",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
              ),
              TextButton(
                onPressed: () {
                  launch('tel:${documentSnapshot.get('telefone')}');
                },
                child: Text(
                  "Ligar",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
