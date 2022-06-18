import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PedidoTile extends StatelessWidget {
  const PedidoTile({Key? key, required this.pedidoId}) : super(key: key);

  final String pedidoId;

  @override
  Widget build(BuildContext context) {
    return Card(
      //espacamento fora do card
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        //espacamaneto dentro do card, ou seja entre o card e o widget filho
        padding: const EdgeInsets.all(8),
        child: StreamBuilder<DocumentSnapshot>(
          //DocumentSnapshot vai buscar somente 1 documento (pedido) por vez
          /*StreamBuilder vai observar o banco de dados verificando se ha alguma alteraçao nos dados
          se haver alteraçao vai automaticamanete alterar o estado do wiget
          .snapshots() é pq queremos atualizaçoes em tempo real*/
          stream: FirebaseFirestore.instance
              .collection('pedidos')
              .doc(pedidoId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              //se nao tiver dados ainda
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              );
            } else {
              int _statusdoPedido = snapshot.data!.get('statusDoPedido');
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Código do pedido: ${snapshot.data!.id}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(_buildPedidosText(snapshot.data!)),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Status do pedido:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCirculoProgressoEntrega(
                        titulo: '1',
                        subTitulo: 'Pedido Aceito',
                        statusdoPedido: _statusdoPedido,
                        thisStatus: 1,
                      ),
                      Container(
                        height: 1,
                        width: 14,
                        color: Colors.grey.shade500,
                      ),
                      _buildCirculoProgressoEntrega(
                        titulo: '2',
                        subTitulo: 'Preparação',
                        statusdoPedido: _statusdoPedido,
                        thisStatus: 2,
                      ),
                      Container(
                        height: 1,
                        width: 14,
                        color: Colors.grey.shade500,
                      ),
                      _buildCirculoProgressoEntrega(
                        titulo: '3',
                        subTitulo: 'Transporte',
                        statusdoPedido: _statusdoPedido,
                        thisStatus: 3,
                      ),
                      Container(
                        height: 1,
                        width: 14,
                        color: Colors.grey.shade500,
                      ),
                      _buildCirculoProgressoEntrega(
                        titulo: '4',
                        subTitulo: 'Entregue',
                        statusdoPedido: _statusdoPedido,
                        thisStatus: 4,
                      ),
                    ],
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }

  String _buildPedidosText(DocumentSnapshot snapshot) {
    String texto = 'Descricao:\n';
    for (LinkedHashMap p in snapshot.get('produtos')) {
      /*Como temos uma lista dos produtos dentro do documento do pedido
      Para acessarmos cada item desta lista de produtos usamos um LinkedHasMap
      (no caso cada indice dentro de produtos, pois produtos é um array e em cada posicao tem os dados de um produto)*/
      texto +=
          '${p['quantidade']} x ${p['produto']['titulo']} (R\$: ${p['produto']['preco'].toStringAsFixed(2)})\n';
    }
    texto += 'Total: R\$: ${snapshot.get('valorTotal')}';
    return texto;
  }

  Widget _buildCirculoProgressoEntrega(
      {required String titulo,
      required String subTitulo,
      required int statusdoPedido,
      required int thisStatus}) {
    Color corDeFundo;
    Widget child;

    if (statusdoPedido < thisStatus) {
      corDeFundo = Colors.grey.shade500;
      child = Text(
        titulo,
        style: TextStyle(color: Colors.white),
      );
    } else if (statusdoPedido == thisStatus) {
      corDeFundo = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: [
          Text(
            titulo,
            style: TextStyle(color: Colors.white),
          ),
          CircularProgressIndicator(
            color: Colors.white,
          )
        ],
      );
    } else {
      corDeFundo = Colors.green;
      child = Icon(
        Icons.check,
        color: Colors.white,
      );
    }
    return Column(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: corDeFundo,
          child: child,
        ),
        Text(subTitulo),
      ],
    );
  }
}
