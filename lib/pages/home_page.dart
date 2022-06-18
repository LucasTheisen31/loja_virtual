import 'package:flutter/material.dart';
import 'package:loja_virtual/tabs/home_tab.dart';
import 'package:loja_virtual/tabs/lista_pedidos_tab.dart';
import 'package:loja_virtual/widgets/carrinho_button.dart';
import '../tabs/categoria_tab.dart';
import '../tabs/lista_lojas_tab.dart';
import '../widgets/custom_drawer.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final _pageControler = PageController(); //controlador das paginas do PageView

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageControler,
      //para controlar em qual pagina esta
      physics: NeverScrollableScrollPhysics(),
      //nao permite arrastar entre uma tela e outra
      children: [
        //primeira pagina -> 0
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(pageController: _pageControler),
          floatingActionButton: CarrinhoButton(),
        ),
        //segunda pagina -> 1
        Scaffold(
          appBar: AppBar(
            title: Text("Categorias"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(pageController: _pageControler),
          body: Container(
            child: CategoriaTab(),
          ),
          floatingActionButton: CarrinhoButton(),
        ),
        //terceira pagina -> 2
        Scaffold(
          appBar: AppBar(
            title: Text('Lojas'),
            centerTitle: true,
          ),
          drawer: CustomDrawer(pageController: _pageControler),
          body: ListaLojasTab(),
        ),
        //quarta pagina -> 3
        Scaffold(
          appBar: AppBar(
            title: Text('Meus Pedidos'),
            centerTitle: true,
          ),
          body: ListaPedidosTab(),
          drawer: CustomDrawer(pageController: _pageControler),
        ),
      ],
    );
  }
}
