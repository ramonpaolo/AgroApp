import 'package:flutter/material.dart';
import 'dart:io';

showModalConf(context, localizacao, FirebaseAuth, _googleSignIn, _saveData,
    Login, setState) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Localização $localizacao"),
                      Switch(
                        value: localizacao,
                        onChanged: (v) {
                          setState(() {
                            localizacao = v;
                          });
                        },
                        activeColor: Colors.green,
                      )
                    ],
                  ),
                  TextButton.icon(
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance.currentUser.delete();
                        } catch (e) {
                          await _googleSignIn.disconnect();
                        }
                        await _saveData();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
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

showModal(context, item, index) {
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
                child: Image.file(
                  File(item[index]["image"]),
                  height: 140,
                  filterQuality: FilterQuality.high,
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
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.share,
                      color: Colors.green,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              ListTile(
                title: Text(item[index]["title"]),
                subtitle: Text(item[index]["subtitle"]),
                trailing: Text(
                  "R\$" + item[index]["price"],
                  style: TextStyle(color: Colors.green),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    item[index]["describe"],
                    style: TextStyle(fontSize: 16),
                  )),
            ],
          ),
        ));
      });
}
