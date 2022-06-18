import 'package:flutter/material.dart';

class FreteCard extends StatelessWidget {
  const FreteCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(
          'Cálcular Frete',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
          textAlign: TextAlign.start,
        ),
        leading: Icon(Icons.location_on),
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite seu CEP',
              ),
            ),
          )
        ],
      ),
    );
  }
}
