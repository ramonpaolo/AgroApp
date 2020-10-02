//---- Packages
import 'package:flutter/material.dart';

class PageHero extends StatelessWidget {
  PageHero(this.image);
  //---- Variables

  final image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Hero(
            tag: image,
            child: Column(children: [
              Padding(
                  padding: EdgeInsets.only(bottom: 100, right: 340, top: 30),
                  child: BackButton(
                    color: Colors.green,
                  )),
              Center(
                  child: Stack(children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      image,
                      width: 400,
                      height: 400,
                      fit: BoxFit.fill,
                    ))
              ])),
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
