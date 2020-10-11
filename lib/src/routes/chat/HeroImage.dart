//---- Packages
import 'package:flutter/material.dart';
import 'dart:io';

class PageHero extends StatelessWidget {
  PageHero(this.image);
  //---- Variables

  final image;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Hero(
            tag: image,
            child: Column(children: [
              Padding(
                  padding: EdgeInsets.only(right: 340, top: 30),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.green,
                      size: 36,
                    ),
                    onPressed: () => Navigator.pop(context),
                  )),
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    File(image),
                    filterQuality: FilterQuality.high,
                    height: size.height * 0.7,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.save_alt),
                    onPressed: () {},
                    color: Colors.green,
                    iconSize: 36,
                    tooltip: "Salvar no dispositivo",
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {},
                    color: Colors.green,
                    iconSize: 36,
                    tooltip: "Compartilhar",
                  ),
                ],
              )
            ])));
  }
}
