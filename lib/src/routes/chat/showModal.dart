import 'package:flutter/material.dart';

showModal(context, imagem, galery) {
  return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      builder: (c) {
        return ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              height: 150,
              child: Column(
                children: [
                  Container(
                      child: Row(children: [
                    Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Column(children: [
                          IconButton(
                            icon: Icon(Icons.camera_alt),
                            iconSize: 88.0,
                            tooltip: "Tirar foto",
                            color: Colors.green,
                            onPressed: imagem,
                          ),
                          Text("Tirar foto")
                        ])),
                    Padding(
                        padding: EdgeInsets.only(left: 130),
                        child: Column(children: [
                          IconButton(
                            icon: Icon(Icons.attach_file),
                            iconSize: 88.0,
                            tooltip: "Pegar na galeria",
                            color: Colors.green,
                            onPressed: galery,
                          ),
                          Text("Pegar Arquivo")
                        ]))
                  ])),
                ],
              ),
            ));
      });
}
