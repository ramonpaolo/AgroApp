//---- Packages
import 'package:flutter/material.dart';

//---- Screens
import 'package:agricultura/src/routes/home/AddContent.dart';

showModal(BuildContext context, Map data, Size size) {
  return showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      context: context,
      builder: (c) {
        return ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              width: size.width,
              height: 600,
              color: Colors.white,
              child: Column(children: [
                Image.asset(
                  "assets/images/reuniao.jpg",
                  height: 200,
                  filterQuality: FilterQuality.high,
                ),
                Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Ficamos felizes em saber que você deseja publicar um produto para venda. Te desejamos muita sorte em sua nova jornada.",
                      style: TextStyle(fontSize: 16),
                    )),
                ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                        width: size.width * 0.9,
                        height: size.height * 0.07,
                        child: RaisedButton.icon(
                            color: Colors.green,
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddContent(
                                          name: data["name"],
                                        ))),
                            icon: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Continuar",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ))))
              ]),
            ));
      });
}
