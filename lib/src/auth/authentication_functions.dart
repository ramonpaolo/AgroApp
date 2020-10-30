//---- Packages
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

//---- API
import 'package:agricultura/src/firebase/api_firebase.dart';

//---- Screens
import 'package:agricultura/src/models/Nav.dart';

class AuthenticationFunctions {
  //---- Variables

  FirebaseAuth auth = FirebaseAuth.instance;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  String name;
  String textShowDialog;

  TextButton actionButtonShowDialog;

  //---- Functions

  Future<File> getData() async {
    final directory = await getApplicationDocumentsDirectory();
    var file = File("${directory.path}/data.json");
    return file;
  }

  /*Future deleteData() async {
    final path = await getData();
    await path.delete();
  }*/

  Future saveData(name, email, password, _googleSignIn, auth) async {
    Map dataUser;

    final file = await getData();

    if (_googleSignIn == null) {
      dataUser = {
        'email': "$email",
        'password': "$password",
        'name': "$name",
        'image': "$auth",
        'screen': "true",
        "car_shop": [],
        "favorites": [],
      };
    } else if (auth == null) {
      dataUser = {
        'email': "$email",
        'password': "$password",
        'name': "${_googleSignIn.currentUser.displayName}",
        'image': "${_googleSignIn.currentUser.photoUrl}",
        'screen': "true",
        "car_shop": [],
        "favorites": [],
      };
    } else {
      dataUser = {
        'email': "$email",
        'password': "$password",
        'name': "$name",
        'image': "null",
        'screen': "true",
        "car_shop": [],
        "favorites": [],
      };
    }
    return await file.writeAsString(jsonEncode(dataUser));
  }

  //------------------------- CADASTRO.DART -------------------------

  Future cadastroEmailSenha(
      {String email, String senha, String name, BuildContext context}) async {
    print("Email: $email. Senha: $senha. Name: $name.");
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: senha);

      User userr = FirebaseAuth.instance.currentUser;

      await userr.sendEmailVerification();

      await saveData(name, email, senha, null, userr.photoURL);

      var user = await LocalUser().readData();

      try {
        await dataUser.addUser(user);
      } catch (e) {
        print("Error in 'cadastroEmailSenha': $e");
      }

      await showDialog(
          context: (context),
          child: AlertDialog(
              content: Text(
                  "Você tem até 1 hora para confirmar o Email ou sua conta será cancelada"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                            child: Nav(), type: PageTransitionType.bottomToTop),
                        (route) => false),
                    child: Text("Ok"))
              ]));
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        await showDialog(
            context: (context),
            child: AlertDialog(
                content: Text("Essa senha não pertence a esse email"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(
                            context,
                          ),
                      child: Text("Ok"))
                ]));
      } else if (e.code == "email-already-in-use") {
        await showDialog(
            context: (context),
            child: AlertDialog(content: Text("Email já cadastrado"), actions: [
              TextButton(
                  onPressed: () => Navigator.pop(
                        context,
                      ),
                  child: Text("Ok"))
            ]));
      }
    } catch (e) {
      print("Error 'cadastroEmailSenha': " + e.toString());
    }
  }

  Future cadastroGoogle(BuildContext context) async {
    try {
      await _googleSignIn.signIn();

      await auth.createUserWithEmailAndPassword(
          email: _googleSignIn.currentUser.email,
          password: _googleSignIn.currentUser.displayName);

      await FirebaseAuth.instance.currentUser.sendEmailVerification();

      await saveData(
          _googleSignIn.currentUser.displayName,
          _googleSignIn.currentUser.email,
          _googleSignIn.currentUser.displayName,
          _googleSignIn,
          null);

      user = await LocalUser().readData();

      try {
        await dataUser.addUser(user);
      } catch (e) {
        print("Error in addUser in Firestore: $e");
      }

      await Navigator.pushAndRemoveUntil(
          context,
          PageTransition(child: Nav(), type: PageTransitionType.bottomToTop),
          (route) => false);
    } catch (e) {
      print("Error in 'cadastroGoogle': $e");
    }
  }

  //------------------------- LOGIN.DART -------------------------

  Future loginEmailSenha(
      {String email, String senha, BuildContext context}) async {
    print("Email $email. Senha $senha.");

    try {
      await auth.signInWithEmailAndPassword(email: email, password: senha);

      await saveData(name, email, email, null, auth);

      await Navigator.pushAndRemoveUntil(
          context,
          PageTransition(child: Nav(), type: PageTransitionType.bottomToTop),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        await showDialog(
            context: (context),
            child: AlertDialog(content: Text("Email não cadastrado")));
      } else if (e.code == "wrong-password") {
        await showDialog(
            context: (context),
            child: AlertDialog(content: Text("Senha errada")));
      }
    } catch (e) {
      print("Error in FirebaseAuthException on 'loginEmailSenha': $e");
    }
  }

  Future loginAnonymous(BuildContext context) async {
    try {
      await auth.signInAnonymously();

      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(child: Nav(), type: PageTransitionType.bottomToTop),
          (route) => false);
    } catch (e) {
      print("Error 'loginAnonymous': $e");
    }
  }

  Future loginGoogle(BuildContext context) async {
    try {
      await _googleSignIn.signIn();

      await saveData(
          _googleSignIn.currentUser.displayName,
          _googleSignIn.currentUser.email,
          _googleSignIn.currentUser.email,
          _googleSignIn,
          null);

      await Navigator.pushAndRemoveUntil(
          context,
          PageTransition(child: Nav(), type: PageTransitionType.bottomToTop),
          (route) => false);
    } catch (e) {
      print("Error 'loginGoogle': " + e.toString());
    }
  }
}
