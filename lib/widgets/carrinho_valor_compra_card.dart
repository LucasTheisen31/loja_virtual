import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:loja_virtual/models/carrinho_model.dart';

class ValorCompraCard extends StatelessWidget {
  const ValorCompraCard({
    Key? key,
    required this.finalizarPedido,
  }) : super(key: key);

  final VoidCallback finalizarPedido;

  @override
  Widget build(BuildContext context) {
    return Card(
      //espaçamento exterior ao card
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Container(
        //espaçamento dentro do card
        padding: const EdgeInsets.all(16),
        child: ScopedModelDescendant<CarrinhoModel>(
          builder: (context, child, model) {
            double valorSubTotal = model.getValorProdutosDoCarrinho();
            double valorDescontro = model.getValorDesconto();
            double valorEntrega = model.getValorFrete();
            double valorTotal = (valorSubTotal + valorEntrega - valorDescontro);
            model.atualizarPrecos();
            return Column(
              //para ocupar o maior expaço possivel na horizontal
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Resumo do Pedido",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal'),
                    Text('R\$ ${valorSubTotal.toStringAsFixed(2)}'),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Desconto'),
                    Text('R\$ -${valorDescontro.toStringAsFixed(2)}'),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Entrega'),
                    Text('R\$ ${valorEntrega.toStringAsFixed(2)}'),
                  ],
                ),
                const Divider(),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'R\$ ${valorTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      finalizarPedido();
                    },
                    child: const Text(
                      "Finalizar Pedido",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
