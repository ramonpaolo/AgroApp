//---- Packages
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

//---- API
import 'package:agricultura/src/firebase/api_firebase.dart';

//---- Screens
import 'package:agricultura/src/pages/Nav.dart';

class AuthenticationFunctions {
  //---- Variables

  FirebaseAuth auth = FirebaseAuth.instance;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  DocumentSnapshot dataUserr;

  String nameUser;

  TextButton actionButtonShowDialog;

  //---- Functions
  Future searchUser() async {
    dataUserr = await firebaseFirestore
        .collection("users")
        .doc(auth.currentUser.uid)
        .get();
  }

  Future<File> getData() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future saveData(
      {String name,
      String email,
      String password,
      GoogleSignIn googleSignIn,
      FirebaseAuth auth}) async {
    final file = await getData();

    print("Dado do usuário: ${dataUserr.data()}");

    await file.writeAsString(jsonEncode(dataUserr.data()));
  }

  //------------------------- CADASTRO.DART -------------------------

  Future cadastroEmailSenha(
      {String email, String senha, String name, BuildContext context}) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: senha);

      await dataUser.addUser({
        "car_shop": [],
        "favorites": [],
        "image": auth.currentUser.photoURL == null
            ? null
            : auth.currentUser.photoURL,
        "email": email,
        "name": name,
        "password": senha,
        "screen": "true"
      });

      await searchUser();

      await saveData();

      User userr = FirebaseAuth.instance.currentUser;

      await userr.sendEmailVerification();

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
      print("Error 'cadastroEmailSenha': $e");
    }
  }

  Future cadastroGoogle(BuildContext context) async {
    try {
      await _googleSignIn.signIn();

      await cadastroEmailSenha(
          email: _googleSignIn.currentUser.email,
          senha: _googleSignIn.currentUser.email,
          name: _googleSignIn.currentUser.displayName,
          context: context);
    } catch (e) {
      print("Error in 'cadastroGoogle': $e");
    }
  }

  //------------------------- LOGIN.DART -------------------------

  Future loginEmailSenha(
      {String email, String senha, BuildContext context}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: senha);

      await searchUser();

      await saveData();

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

      await loginEmailSenha(
          context: context,
          email: _googleSignIn.currentUser.email,
          senha: _googleSignIn.currentUser.email);
    } catch (e) {
      print("Error 'loginGoogle': $e");
    }
  }
}
