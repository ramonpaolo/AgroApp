//---- Packages
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
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

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  //---- Functions

  Future<File> _getData() async {
    final directory = await getApplicationDocumentsDirectory();
    var file = File("${directory.path}/data.json");
    return file;
  }

  Future _saveData(name, email, password) async {
    final path = await _getData();
    final file = {"name": "$name", "email": "$email", "password": "$password"};
    var en = jsonEncode(file);
    await path.writeAsString(en);
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
                          onPressed: () => Navigator.pop(context)),
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
                  await _saveData(_controllerName.text, _controllerEmail.text,
                      _controllerPassword.text);
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: Nav(),
                          type: PageTransitionType.bottomToTop,
                          duration: Duration(milliseconds: 600)));
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
                onPressed: () {},
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
