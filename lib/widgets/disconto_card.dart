import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/carrinho_model.dart';

class DiscontoCard extends StatelessWidget {
  const DiscontoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(
          'Cupom de desconto',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
          textAlign: TextAlign.start,
        ),
        leading: const Icon(Icons.card_giftcard), //icone da esquerda
        trailing: const Icon(Icons.add), //icone da direita
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              initialValue: CarrinhoModel.of(context).cupomDesconto ?? '',
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite seu cupom',
              ),
              onFieldSubmitted: (text) {
                //ao clicar o ok do teclado
               if(text.isEmpty){
                 CarrinhoModel.of(context).aplicarDesconto(pocentagem: 0);
               }else{
                 FirebaseFirestore.instance
                     .collection('cupons')
                     .doc(text)
                     .get()
                     .then((value) {
                   if (value.data() != null) {
                     //se existe um cupom igual
                     CarrinhoModel.of(context).aplicarDesconto(cupom: text, pocentagem: value.data()!['porcentagem']);
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                         content: Text("Desconto de ${value.data()!['porcentagem']}% aplicado!"),
                         backgroundColor: Theme.of(context).primaryColor,
                       ),
                     );
                   } else {
                     //se nao existe um cupom igual
                     CarrinhoModel.of(context).aplicarDesconto(cupom: null, pocentagem: 0);
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(
                         content: Text("Cupom invalido!"),
                         backgroundColor: Colors.redAccent,
                       ),
                     );
                   }
                 });
               }
              },
            ),
          ),
        ],
      ),
    );
  }
}
