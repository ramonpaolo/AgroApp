import 'package:agricultura/src/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Anonimous extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "Se cadaste para ter acesso a essa página",
            style: TextStyle(color: Colors.white, fontSize: size.width * 0.05),
          ),
        ),
        Center(
          child: TextButton(
            child: Text(
              "Logar/Cadastrar",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
          ),
        )
      ],
    );
  }
}
