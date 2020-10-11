//---- Packages
import 'package:agricultura/src/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

//---- Screens
import 'package:agricultura/src/models/Nav.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  //---- Variables

  bool obscuteText = true;

  FirebaseAuth auth = FirebaseAuth.instance;

  String textShowDialog = "";

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  Widget actionButtonShowDialog = Text("");

  //---- Functions

  Future cadastroEmailSenha(email, senha) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: senha);

      User user = FirebaseAuth.instance.currentUser;

      await user.sendEmailVerification();

      setState(() {
        textShowDialog =
            "Você tem até 1 hora para confirmar o Email ou sua conta será cancelada";
        actionButtonShowDialog = TextButton(
            onPressed: () async => await Navigator.pushReplacement(
                context,
                PageTransition(
                    child: Nav(),
                    type: PageTransitionType.bottomToTop,
                    duration: Duration(milliseconds: 600))),
            child: Text("Ok"));
      });

      await _saveData(_controllerName.text, email, senha);
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        setState(() {
          textShowDialog = "Essa senha não pertence a esse email";
          actionButtonShowDialog = TextButton(
            onPressed: () => Navigator.pop(
              context,
            ),
            child: Text("Ok"),
          );
        });
      } else if (e.code == "email-already-in-use") {
        setState(() {
          textShowDialog = "Email já cadastrado";
          actionButtonShowDialog = TextButton(
            onPressed: () => Navigator.pop(
              context,
            ),
            child: Text("Ok"),
          );
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future loginGoogle() async {
    try {
      await _googleSignIn.signIn();

      await auth.createUserWithEmailAndPassword(
          email: _googleSignIn.currentUser.email,
          password: _googleSignIn.currentUser.displayName);

      await FirebaseAuth.instance.currentUser.sendEmailVerification();

      await _saveData(
          _googleSignIn.currentUser.displayName,
          _googleSignIn.currentUser.email,
          _googleSignIn.currentUser.displayName);

      await Navigator.pushReplacement(context,
          PageTransition(child: Nav(), type: PageTransitionType.bottomToTop));
    } catch (e) {
      print(e);
    }
  }

  Future<File> _getData() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future _saveData(name, email, password) async {
    final file = await _getData();
    final dataUser = {
      "name": "$name",
      "email": "$email",
      "password": "$password"
    };
    return await file.writeAsString(jsonEncode(dataUser));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(120)),
                  child: Container(
                      color: Colors.white,
                      width: 1000,
                      height: 200,
                      child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image.asset(
                                "assets/images/agricultura.png",
                                filterQuality: FilterQuality.high,
                              ),
                            ),
                          ))),
                ),
                Padding(
                    padding: EdgeInsets.only(
                      top: 150,
                    ),
                    child: Tooltip(
                      message: "Logar",
                      child: IconButton(
                          iconSize: 38,
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: Login(),
                                  type: PageTransitionType.rightToLeft))),
                    )),
              ],
            ),
            Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  child: Column(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Container(
                            color: Colors.white,
                            child: formulario(
                                TextInputType.name,
                                "Digite seu nome completo",
                                false,
                                Icon(
                                  Icons.person,
                                  color: Colors.green,
                                ),
                                false,
                                _controllerName),
                          )),
                      Divider(
                        height: 20,
                        color: Colors.green,
                      ),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Container(
                            color: Colors.white,
                            child: formulario(
                                TextInputType.emailAddress,
                                "Digite seu email",
                                false,
                                Icon(
                                  Icons.email,
                                  color: Colors.green,
                                ),
                                false,
                                _controllerEmail),
                          )),
                      Divider(
                        height: 20,
                        color: Colors.green,
                      ),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Container(
                            color: Colors.white,
                            child: formulario(
                                TextInputType.visiblePassword,
                                "Digite sua senha",
                                obscuteText,
                                Icon(
                                  Icons.vpn_key,
                                  color: Colors.green,
                                ),
                                true,
                                _controllerPassword),
                          )),
                    ],
                  ),
                )),
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: RaisedButton(
                onPressed: () async {
                  await cadastroEmailSenha(
                      _controllerEmail.text, _controllerPassword.text);
                  await showDialog(
                      context: (context),
                      child: AlertDialog(
                          content: Text("$textShowDialog"),
                          actions: [actionButtonShowDialog]));
                },
                child: Container(
                    width: 150,
                    height: 50,
                    child: Center(child: Text("Cadastrar"))),
                color: Colors.white,
              ),
            ),
            Divider(
              color: Colors.green,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: RaisedButton(
                onPressed: () async {
                  await loginGoogle();
                },
                child: Container(
                  width: 150,
                  height: 50,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset(
                            "assets/images/google.jpg",
                            width: 30,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text("Cadastro Google"))
                      ]),
                ),
                color: Colors.white,
              ),
            ),
            Divider(
              color: Colors.green,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: RaisedButton(
                onPressed: () {},
                textColor: Colors.white,
                child: Container(
                  width: 150,
                  height: 50,
                  child: Row(children: [
                    Image.asset(
                      "assets/images/facebook.png",
                      width: 20,
                      color: Colors.white,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text("Cadastro Facebook"))
                  ]),
                ),
                color: Colors.blue[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget formulario(
      TextInputType keyBoardType,
      String hintText,
      bool obscureText,
      Icon prefixIcon,
      bool suffixIcon,
      TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: keyBoardType,
      obscureText: obscureText,
      cursorColor: Colors.green,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          fillColor: Colors.white,
          focusColor: Colors.white,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon
              ? IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    setState(() {
                      obscuteText = !obscuteText;
                    });
                  })
              : null,
          contentPadding: EdgeInsets.all(20),
          hoverColor: Colors.white),
    );
  }
}
