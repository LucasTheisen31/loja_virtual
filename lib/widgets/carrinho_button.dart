import 'package:flutter/material.dart';
import 'package:loja_virtual/pages/carrinho_page.dart';

class CarrinhoButton extends StatelessWidget {
  const CarrinhoButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        Icons.shopping_cart,
        color: Colors.white,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CarrinhoPage(),
          ),
        );
      },
    );
  }
}
