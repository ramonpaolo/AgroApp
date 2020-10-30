//---- Packages
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

//---- Functions
import 'package:agricultura/src/auth/authentication_functions.dart';

//---- Screens
import 'package:agricultura/src/auth/Login.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  //---- Variables

  AuthenticationFunctions authenticationFunctions = AuthenticationFunctions();

  bool obscuteText = true;

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  var _form = GlobalKey<FormState>();

  @override
  void initState() {
    print("---------Cadastro.dart------------");
    super.initState();
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
                      message: "Loguin",
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
                  key: _form,
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
                                _controllerName,
                                10,
                                50),
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
                                "Digite seu Email",
                                false,
                                Icon(
                                  Icons.email,
                                  color: Colors.green,
                                ),
                                false,
                                _controllerEmail,
                                15,
                                50),
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
                                "Digite uma Senha",
                                obscuteText,
                                Icon(
                                  Icons.vpn_key,
                                  color: Colors.green,
                                ),
                                true,
                                _controllerPassword,
                                8,
                                24),
                          )),
                    ],
                  ),
                )),
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: RaisedButton(
                onPressed: () async {
                  if (_form.currentState.validate()) {
                    await authenticationFunctions.cadastroEmailSenha(
                        email: _controllerEmail.text,
                        senha: _controllerPassword.text,
                        name: _controllerName.text,
                        context: context);
                  }
                },
                child: Container(
                    width: 150,
                    height: 50,
                    child: Center(
                        child: Row(
                      children: [
                        Icon(
                          Icons.email,
                          color: Colors.green,
                        ),
                        Divider(
                          indent: 16.0,
                        ),
                        Text("Cadastrar")
                      ],
                    ))),
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
                  await authenticationFunctions.cadastroGoogle(context);
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
      TextEditingController controller,
      int minValue,
      int maxValue) {
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
      validator: (value) {
        if (value.isEmpty) {
          return "Campo vazio";
        } else if (value.length < minValue) {
          return "Menor que $minValue";
        } else if (value.length > maxValue) {
          return "Maior que $maxValue";
        }
      },
    );
  }
}
