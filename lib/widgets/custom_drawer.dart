import 'package:flutter/material.dart';
import 'package:loja_virtual/models/usuario_model.dart';
import 'package:loja_virtual/pages/login_page.dart';
import 'package:loja_virtual/tile/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key, required this.pageController})
      : super(key: key);

  final PageController
      pageController; //para dar acesso ao controlador das paginas do page view, para poder mudar a pagina

  Widget _buildDrawerBack() => Container(
        //fundo degrade
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 203, 236, 241),
            Colors.white,
          ],
          begin: Alignment.topCenter, //inicio
          end: Alignment.bottomCenter, //fim
        )),
      );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        //spbrepoem widgets
        children: [
          _buildDrawerBack(), //funcao para efeito degrade
          SafeArea(
            child: ListView(
              padding: EdgeInsets.only(left: 20, top: 10),
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 20, 16),
                  height: 170,
                  child: Stack(
                    //stack permite sobrepor e posicionar widgets
                    children: [
                      Positioned(
                        top: 8,
                        left: 0,
                        child: Text(
                          "Clothing\nStore",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: ScopedModelDescendant<UsuarioModel>(
                          builder: (context, child, model) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  model.usuarioEstaOuNaoLogado()
                                      ? "Olá ${model.dadosUsuario['nome']}"
                                      : "Olá,",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if(model.usuarioEstaOuNaoLogado()){
                                      model.deslogar();
                                    }else {
                                      Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => LoginPage(),
                                            ),
                                          );
                                    }
                                  },
                                  child: Text(
                                    model.usuarioEstaOuNaoLogado()
                                        ? 'Sair'
                                        : 'Entre ou cadastre-se',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                DrawerTile(
                  icon: Icons.home,
                  text: "Inicio",
                  pageController: pageController,
                  page: 0, //corresponde a pagina 0
                ),
                DrawerTile(
                  icon: Icons.list,
                  text: "Produtos",
                  pageController: pageController,
                  page: 1, //corresponde a pagina 1
                ),
                DrawerTile(
                  icon: Icons.location_on,
                  text: "Lojas",
                  pageController: pageController,
                  page: 2, //corresponde a pagina 2
                ),
                DrawerTile(
                  icon: Icons.playlist_add_check,
                  text: "Meus pedidos",
                  pageController: pageController,
                  page: 3, //corresponde a pagina 3
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
