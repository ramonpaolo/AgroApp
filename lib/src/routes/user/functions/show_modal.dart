//---- Packages
import 'package:agricultura/src/routes/user/functions/dialog_delete_user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:share/share.dart';

showModalConf({
  BuildContext context,
  GoogleSignIn googleSignIn,
  List myProduts,
}) {
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
              height: 1000,
              child: Column(
                children: [
                  TextButton.icon(
                      onPressed: () async {
                        await showDialogDeleteUser(
                            context: context,
                            myProduts: myProduts,
                            googleSignIn: googleSignIn);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.green,
                      ),
                      label: Text(
                        "Deletar conta",
                        style: TextStyle(color: Colors.green),
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
