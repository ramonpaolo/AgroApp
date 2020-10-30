//---- Packages
import 'package:agricultura/src/routes/user/functions/functions_delete_user.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

//---- Screens
import 'package:agricultura/src/auth/Login.dart';

showDialogDeleteUser(
    {BuildContext context, List myProduts, GoogleSignIn googleSignIn}) {
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            elevation: 0.0,
            child: Container(
                height: 100,
                child: Column(children: [
                  Divider(
                    color: Colors.white,
                  ),
                  Text("Deseja excluir TODOS os seus dados?"),
                  Divider(color: Colors.white),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancelar",
                              style: TextStyle(color: Colors.red))),
                      TextButton(
                          child: Text("Continuar",
                              style: TextStyle(color: Colors.green)),
                          onPressed: () async {
                            await deleteUserFirebase(
                                context: context,
                                myProduts: myProduts,
                                googleSignIn: googleSignIn);
                            await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          })
                    ],
                  ),
                ])));
      });
}
