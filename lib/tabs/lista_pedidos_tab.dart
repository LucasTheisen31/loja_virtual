import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/usuario_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../pages/login_page.dart';
import '../tile/pedido_tile.dart';

class ListaPedidosTab extends StatelessWidget {
  const ListaPedidosTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (UsuarioModel.of(context).usuarioEstaOuNaoLogado()) {
      String usuarioID = UsuarioModel.of(context).firebaseUsuario!.uid;
      //QuerySnapshot pois vai buscar todos os documentos
      //DocumentSnapshot se fosse buscar somente 1 documento
      return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('usuarios').doc(usuarioID).collection('pedidos').get(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            //se nao tem dados ainda
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }else{
            return ListView(
              scrollDirection: Axis.vertical,
              /*transforma cada um dos documentos um um widget do tipo PedidoTile, cada PedidoTile recebe o id do documento
            e depois transforma todos essses widgets em uma lista pois o ListView quer uma lista de Widgets
             */
              children: snapshot.data!.docs.map((e) => PedidoTile(pedidoId: e.id)).toList().reversed.toList(),
            );
          }
        },
      );
    } else {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        child: Column(
          //centraliza na vertical
          mainAxisAlignment: MainAxisAlignment.center,
          //preenche o espaço possivel na horizontal
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SvgPicture.asset(
              'assets/icons/pedidos.svg',
              height: 80,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Faça o login para acompanhar seus pedidos!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 44,
              child: ElevatedButton(
                child: Text("Entrar"),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(
                    fontSize: 18,
                  ),
                  primary: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      );
    }
  }
}
