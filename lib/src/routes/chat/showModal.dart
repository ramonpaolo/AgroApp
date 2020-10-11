//---- Packages
import 'package:flutter/material.dart';
import 'dart:io';

//---- Screens
import 'package:agricultura/src/routes/chat/HeroImage.dart';

showModal({BuildContext context, Function imagem, Function galery}) {
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

showModalDrazer(_images, context, widget) {
  return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      builder: (c) {
        return ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
                height: 1000,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Divider(
                        color: Colors.white,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: Image.asset(
                          widget.image,
                          width: 200,
                        ),
                      ),
                      Text(
                        widget.name,
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(
                          width: 1000,
                          height: 130,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Container(
                                          width: 100,
                                          child: GestureDetector(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PageHero(
                                                            _images[index]))),
                                            child: Hero(
                                                tag: index,
                                                child: Card(
                                                    child: Image.file(
                                                        File(_images[index])))),
                                          ))));
                            },
                            itemCount: _images.length,
                          ))
                    ],
                  ),
                )));
      });
}
