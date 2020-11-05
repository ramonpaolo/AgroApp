//---- Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:share/share.dart';

//---- API
import 'package:agricultura/src/firebase/api_firebase.dart';

//---- Functions
import 'package:agricultura/src/routes/user/functions/dialog_delete_user.dart';

//---- Screens
import 'package:agricultura/src/auth/Login.dart';

showModalConf(
    {BuildContext context,
    GoogleSignIn googleSignIn,
    List myProduts,
    Map dataUser}) {
  return showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      context: (context),
      builder: (context) {
        return ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              padding: EdgeInsets.all(40),
              color: Colors.white,
              width: 1000,
              height: 212,
              child: Column(
                children: [
                  Text("Bem vindo a configurações ${dataUser["name"]}"),
                  Divider(color: Colors.white),
                  TextButton.icon(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        await LocalUser().deleteData();
                        try {
                          await googleSignIn.signOut();
                        } catch (e) {
                          print(e);
                        }
                        await Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      icon: Icon(
                        Icons.logout,
                        semanticLabel: "Logout",
                      ),
                      label: Text(
                        "Logout",
                      )),
                  TextButton.icon(
                      onPressed: () async {
                        await showDialogDeleteUser(
                            context: context,
                            myProduts: myProduts,
                            googleSignIn: googleSignIn);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      label: Text(
                        "Deletar conta",
                        style: TextStyle(color: Colors.red),
                      ))
                ],
              ),
            ));
      });
}

showModal({BuildContext context, QueryDocumentSnapshot item}) {
  return showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      context: (context),
      builder: (context) {
        return SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.all(20),
          height: 500,
          width: 1000,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  item["image"][0],
                  height: 140,
                  filterQuality: FilterQuality.low,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.download_rounded,
                      color: Colors.green,
                    ),
                    onPressed: () async {
                      await ImageDownloader.downloadImage(
                        await item["image"][0],
                        destination:
                            AndroidDestinationType.custom(directory: "Agro")
                              ..subDirectory("${item["title"]}.png"),
                      );
                      try {
                        await ImageDownloader.open(
                            "/storage/emulated/0/Agro/${item["title"]}.png");
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.share,
                      color: Colors.green,
                    ),
                    onPressed: () async {
                      await Share.share(item["image"][0]);
                    },
                  ),
                ],
              ),
              ListTile(
                title: Text(item["title"]),
                subtitle: Text(item["subtitle"]),
                trailing: Text(
                  "R\$${item["price"]}",
                  style: TextStyle(color: Colors.green),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    item["describe"],
                    style: TextStyle(fontSize: 16),
                  )),
            ],
          ),
        ));
      });
}
