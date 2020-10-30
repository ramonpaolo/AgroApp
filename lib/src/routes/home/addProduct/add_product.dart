//---- Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//---- API
import 'package:agricultura/src/firebase/api_firebase.dart';

Future addProduct(
    {int id,
    List images,
    String title,
    String subtitle,
    String describe,
    String category,
    String price,
    String weight,
    String cepOrigem,
    BuildContext context}) async {
  await AddProduct().addPhoto(images, id.toString());

  await AddProduct().getPhoto(
      path: "photoProduts/${FirebaseAuth.instance.currentUser.uid}/$id",
      fileName: images.length);

  await AddProduct().addProduct({
    "id": id,
    "title": title,
    "subtitle": subtitle,
    "describe": describe,
    "image": linkPhotos,
    "category": category,
    "price": double.parse(price),
    "views": 0,
    "weight": double.parse(weight),
    "id_author": FirebaseAuth.instance.currentUser.uid,
    "cep_origem": int.parse(cepOrigem)
  });

  Navigator.pop(context);
}
