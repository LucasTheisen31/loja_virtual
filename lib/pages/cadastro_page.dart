import 'package:flutter/material.dart';
import 'package:loja_virtual/models/usuario_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CadastroPage extends StatefulWidget {
  CadastroPage({Key? key}) : super(key: key);

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _nomeControler = TextEditingController();

  final _emailControler = TextEditingController();

  final _senhaControler = TextEditingController();

  final _enderecoControler = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Criar Conta'),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UsuarioModel>(
        builder: (context, child, model) {
          if (model.carregandoUsuario) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          } else {
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _nomeControler,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintText: 'Nome Completo',
                    ),
                    validator: (text) {
                      if (text!.isEmpty) {
                        return "Digite o nome";
                      }
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _emailControler,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'E-mail',
                    ),
                    validator: (text) {
                      if (text!.isEmpty) {
                        return "Digite o e-mail";
                      }
                      if (!text.contains('@')) {
                        return "E-mail inválido";
                      }
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _senhaControler,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Senha',
                    ),
                    validator: (text) {
                      if (text!.isEmpty) {
                        return "Digite a senha";
                      }
                      if (text.length < 6) {
                        return "Senha deve ter no minimo 6 caracteres";
                      }
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _enderecoControler,
                    decoration: InputDecoration(
                      hintText: 'Endereço',
                    ),
                    validator: (text) {
                      if (text!.isEmpty) {
                        return "Digite o endereço";
                      }
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 44,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Map<String, dynamic> dadosUsuario = {
                            'nome': _nomeControler.text.trim(),
                            'email': _emailControler.text.trim(),
                            'endereco': _enderecoControler.text.trim()
                          };

                          model.cadastrarUsuario(
                              dadosUsuario: dadosUsuario,
                              senha: _senhaControler.text,
                              sucessoCadastro: _sucessoCadastro,
                              falhaCadastro: _falhaCadastro);
                        }
                      },
                      child: Text("Cadastrar"),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                          fontSize: 18,
                        ),
                        primary: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _sucessoCadastro() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Usuario cadastrado com sucesso!'),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(Duration(seconds: 2)).then((value){
      Navigator.of(context).pop();
    });
  }

  void _falhaCadastro() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Falha ao cadastrar usuario!'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
