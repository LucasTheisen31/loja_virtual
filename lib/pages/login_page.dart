import 'package:flutter/material.dart';
import 'package:loja_virtual/models/usuario_model.dart';
import 'package:loja_virtual/pages/cadastro_page.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();

  final _senhaController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Entrar'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              //substitui(replacement) a tela de entrar pela tela de cadastro
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => CadastroPage(),
                ),
              );
            },
            child: Text("CRIAR CONTA"),
            style: TextButton.styleFrom(
              primary: Colors.white,
              textStyle: TextStyle(
                fontSize: 15,
              ),
            ),
          )
        ],
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
                    controller: _emailController,
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
                    controller: _senhaController,
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        if (_emailController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Insira seu e-mail para recuperação!'),
                              backgroundColor: Colors.redAccent,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }else{
                          model.recuperarSenha(email: _emailController.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                              Text('E-mail de recuperação enviado!'),
                              backgroundColor: Theme.of(context).primaryColor,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Esqueci minha senha',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          primary: Theme.of(context).primaryColor //splash color
                          ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 44,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {}
                        model.login(
                            email: _emailController.text,
                            senha: _senhaController.text,
                            loginSucesso: _loginSucesso,
                            loginFalha: _loginFalha);
                      },
                      child: Text("Entrar"),
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

  void _loginSucesso() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Usuario logado com sucesso!'),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(Duration(seconds: 2)).then((value) {
      Navigator.of(context).pop();
    });
  }

  void _loginFalha() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Falha ao realizar login!'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
