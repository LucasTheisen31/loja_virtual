import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

//Model guarda o estado de alguma coisa, no caso ira guardar o estado do login do app
class UsuarioModel extends Model {
  //atrinutos
  FirebaseAuth _auth = FirebaseAuth.instance;

  User? firebaseUsuario;

  Map<String, dynamic> dadosUsuario = Map();

  bool carregandoUsuario = false;

  //encontrar o Modelfornecido pelo ScopedModel diretamente ScopedModel.of<tipoObjeto>
  static UsuarioModel of(BuildContext context) => ScopedModel.of<UsuarioModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _carregarDadosUsuarioAtual();
  }

  //metodos
  cadastrarUsuario(
      {required Map<String, dynamic> dadosUsuario,
      required String senha,
      required VoidCallback sucessoCadastro,
      required VoidCallback falhaCadastro}) {
    carregandoUsuario = true;
    notifyListeners();

    _auth
        .createUserWithEmailAndPassword(
      //tenta criar um usuario
      email: dadosUsuario['email'],
      password: senha,
    )
        .then((value) {
      //se cadastrar com sucesso
      firebaseUsuario = value.user;
      _salvarDadosUsuario(dadosUsuario);
      sucessoCadastro();
      carregandoUsuario = false;
      notifyListeners();
    }).catchError((onError) {
      //se der erro ao cadastrar
      falhaCadastro();
      carregandoUsuario = false;
      notifyListeners();
    });
  }

  login(
      {required String email,
      required String senha,
      required VoidCallback loginSucesso,
      required VoidCallback loginFalha}) {
    carregandoUsuario = true;
    //notifica que algo foi mudado no UsuarioModel e la no widget tudo que estiver dentro o ScopedModelDescendent sera recriado na tela
    notifyListeners(); //Chame esse método sempre que o objeto for alterado, para notificar qualquer cliente que o objeto pode ter sido alterado para atualizar o widget que esta chamando
    _auth.signInWithEmailAndPassword(email: email, password: senha).then((value) async {
      firebaseUsuario = value.user;
      await _carregarDadosUsuarioAtual();
      loginSucesso();
      carregandoUsuario = false;
      notifyListeners();
    }).catchError((onError){
      carregandoUsuario = false;
      loginFalha();
      notifyListeners();
    });

    //notifica que algo foi mudado no UsuarioModel e la no widget tudo que estiver dentro o ScopedModelDescendent sera recriado na tela
    notifyListeners();
  }

  recuperarSenha({required String email}){
    _auth.sendPasswordResetEmail(email: email);
  }

  deslogar() {
    _auth.signOut();
    dadosUsuario = Map(); //reseta o dadosUsuario
    firebaseUsuario = null;
    notifyListeners(); //notifica que o usuario foi modificado
  }

  bool usuarioEstaOuNaoLogado() {
    //retorna true se tiver um usuario logado
    return firebaseUsuario != null;
  }

  Future<Null> _carregarDadosUsuarioAtual() async {
    if(firebaseUsuario == null){
      firebaseUsuario = _auth.currentUser;
    }
    if(firebaseUsuario != null){
      if(dadosUsuario['nome'] == null){
        DocumentSnapshot<Map<String, dynamic>> documentoUsuario = await FirebaseFirestore.instance.collection('usuarios').doc(firebaseUsuario!.uid).get();
        dadosUsuario = documentoUsuario.data()!;
      }
    }
    notifyListeners();
  }

  _salvarDadosUsuario(Map<String, dynamic> dadosUsuario) {
    this.dadosUsuario = dadosUsuario;
    FirebaseFirestore.instance
        .collection('usuarios')
        .doc(firebaseUsuario!.uid)
        .set(dadosUsuario);
  }
}
