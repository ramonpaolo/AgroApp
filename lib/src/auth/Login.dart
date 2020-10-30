//---- Packages
import 'package:agricultura/src/auth/authentication_functions.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';

//---- Screens
import 'package:agricultura/src/auth/Cadastro.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //---- Variables

  AuthenticationFunctions authenticationFunctions = AuthenticationFunctions();

  bool obscuteText = true;

  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  @override
  void initState() {
    print("----------Login.dart------------");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(120)),
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
                                  filterQuality: FilterQuality.high),
                            ),
                          ))),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 150, left: size.width * 0.88),
                  child: Tooltip(
                      message: "Cadastrar",
                      child: IconButton(
                          iconSize: 38,
                          icon: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.push(
                              context,
                              PageTransition(
                                child: Cadastro(),
                                type: PageTransitionType.leftToRight,
                              )))),
                ),
              ],
            ),
            Divider(
              height: 40,
              color: Colors.green,
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
                              TextInputType.emailAddress,
                              "Digite seu email",
                              false,
                              Icon(
                                Icons.email,
                                color: Colors.green,
                              ),
                              false,
                              _controllerEmail),
                        ),
                      ),
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
                          ))
                    ],
                  ),
                )),
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: RaisedButton(
                onPressed: () async =>
                    await authenticationFunctions.loginEmailSenha(
                        email: _controllerEmail.text,
                        senha: _controllerPassword.text,
                        context: context),
                child: Container(
                    width: 130,
                    height: 50,
                    child: Center(child: Text("Login"))),
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
                  await AuthenticationFunctions().loginGoogle(context);
                },
                child: Container(
                  width: 130,
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
                            child: Text("Login Google"))
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
                onPressed: () async =>
                    await authenticationFunctions.loginAnonymous(context),
                child: Container(
                    width: 130,
                    height: 50,
                    child: Center(child: Text("Login Anônimo"))),
                color: Colors.white,
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
