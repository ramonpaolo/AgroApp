//---- Packages
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

//---- Screens
import 'package:agricultura/src/auth/cadastro.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //---- Variables
  bool obscuteText = true;

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
                  padding: EdgeInsets.only(top: 150, left: 360),
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
                                  type: PageTransitionType.leftToRight)))),
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
                              false),
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
                                true),
                          ))
                    ],
                  ),
                )),
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: RaisedButton(
                onPressed: () {},
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
                onPressed: () {},
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
                onPressed: () {},
                textColor: Colors.white,
                child: Container(
                  width: 130,
                  height: 50,
                  child: Row(children: [
                    Image.asset(
                      "assets/images/facebook.png",
                      width: 20,
                      color: Colors.white,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text("Login Facebook"))
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

  Widget formulario(TextInputType keyBoardType, String hintText,
      bool obscureText, Icon prefixIcon, bool suffixIcon) {
    return TextFormField(
      keyboardType: keyBoardType,
      obscureText: obscureText,
      cursorColor: Colors.white,
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
