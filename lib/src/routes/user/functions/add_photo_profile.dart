//---- Packages
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

Future addPhotoProfile(var _snack, dataUser, BuildContext context) async {
  final image = await ImagePicker.platform
      .pickImage(source: ImageSource.gallery, imageQuality: 85);

  await FirebaseStorage.instance
      .ref("photoUsers")
      .child(FirebaseAuth.instance.currentUser.uid)
      .putFile(File(image.path));
  final directoryImageProfile = FirebaseStorage.instance
      .ref("photoUsers")
      .child(FirebaseAuth.instance.currentUser.uid);
  try {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({
      "image": await directoryImageProfile.getDownloadURL(),
    });
    Navigator.pop(context);
    _snack.currentState.showSnackBar(SnackBar(
      content: Text(
        "Atualizado com sucesso. Saia do App e volte para carregar as mudanças",
        style: TextStyle(color: Colors.green),
      ),
      backgroundColor: Colors.white,
    ));
  } catch (e) {
    print(e);
    _snack.currentState.showSnackBar(SnackBar(
      content: Text("Erro ao fazer o upload"),
      backgroundColor: Colors.red,
    ));
  }
}
