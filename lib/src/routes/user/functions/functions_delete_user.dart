import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

//---- API
import 'package:agricultura/src/firebase/api_firebase.dart';

Future deleteUserFirebase(
    {BuildContext context, List myProduts, GoogleSignIn googleSignIn}) async {
  try {
    for (var x = 0; x < myProduts.length; x++) {
      for (var y = 0; y < 20; y++) {
        try {
          await FirebaseStorage.instance
              .ref(
                  "photoProduts/${FirebaseAuth.instance.currentUser.uid}/${myProduts[x]["id"]}/$y")
              .delete();
        } catch (e) {
          print("Não foi possível apagar por $e");
        }
      }
    }
    print("Algumas imagens apagadas");
  } catch (e) {
    print("Não possível apagar photoProduts por $e");
  }
  try {
    await FirebaseStorage.instance
        .ref("photoUsers/${FirebaseAuth.instance.currentUser.uid}")
        .delete();
  } catch (e) {
    print("Não possível apagar foto de perfil");
  }

  try {
    for (var x = 0; x < productsOrderName.docs.length; x++) {
      if (productsOrderName.docs[x]["id_author"] ==
          FirebaseAuth.instance.currentUser.uid) {
        await FirebaseFirestore.instance
            .collection("products")
            .doc(productsOrderName.docs[x].id)
            .delete();
      }
    }
  } catch (e) {
    print("Não possível apagar products");
  }

  try {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .delete();
    await FirebaseAuth.instance.currentUser.delete();
  } catch (e) {
    print("Não possível apagar usuário");
  }
  try {
    await LocalUser().deleteData();
  } catch (e) {
    print("Não foi possível apagar local user: $e");
  }
  try {
    await googleSignIn.disconnect();
  } catch (e) {
    print("desconectar do google não deu certo");
  }
}
