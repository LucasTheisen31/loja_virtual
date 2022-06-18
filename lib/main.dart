import 'package:flutter/material.dart';
import 'package:loja_virtual/models/usuario_model.dart';
import 'package:loja_virtual/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/carrinho_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); //Cria e inicializa uma instância do aplicativo Firebase.
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    /*ScopedModel Um conjunto de utilitários que permitem passar facilmente um modelo de dados de um widget pai para seus descendentes.
    Além disso, ele também reconstrói todos os filhos que usam o modelo quando o modelo é atualizado*/
    return ScopedModel<UsuarioModel>(
      model: UsuarioModel(),
      //tudo que estiver abaixo do ScopedModel vai ter acesso ao UsuarioModel, e vai ser modificado caso algo aconteça no UsuarioModel
      child: ScopedModelDescendant<UsuarioModel>(
        builder: (context, child, model) {
          return ScopedModel<CarrinhoModel>(
            model: CarrinhoModel(usuario: model),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Flutter Clothing",
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                  primaryColor: Color.fromARGB(255, 4, 125, 141),
                  appBarTheme: AppBarTheme(
                    color: Color.fromARGB(255, 4, 125, 141),
                  )),
              home: HomePage(),
            ),
          );
        },
      ),
    );
  }
}
