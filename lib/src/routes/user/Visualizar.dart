//---- Packages
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class Visualizar extends StatefulWidget {
  Visualizar({Key key, this.data}) : super(key: key);
  final Map data;

  @override
  _VisualizarState createState() => _VisualizarState();
}

class _VisualizarState extends State<Visualizar> {
  //---- Variables

  int _indexImage = 0;

  List _images = [];

  Map produto;

  //---- Functions

  quantidadeImagens() {
    for (var x = 0; x < 20; x++) {
      try {
        setState(() {
          _images.add(produto["image"][x]);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    print("-------- Visualizar.dart ---------");
    produto = widget.data;
    quantidadeImagens();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40)),
                child: Center(
                    child: Container(
                        width: 1000,
                        height: 275,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CarouselSlider.builder(
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: EdgeInsets.all(20),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.file(
                                          File(_images[index]),
                                          filterQuality: FilterQuality.high,
                                          fit: BoxFit.fill,
                                        )));
                              },
                              itemCount: _images.length,
                              options: CarouselOptions(
                                autoPlay: true,
                                initialPage: _indexImage,
                                enableInfiniteScroll: false,
                                autoPlayCurve: Curves.easeOut,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _indexImage = index;
                                  });
                                },
                              ),
                            ),
                            Center(
                                child: Container(
                              width: (_images.length * 25).ceilToDouble(),
                              height: 10,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          child: Container(
                                            width: 20,
                                            color: _indexImage == index
                                                ? Colors.green[300]
                                                : Colors.green[100],
                                          )));
                                },
                                itemCount: _images.length,
                              ),
                            ))
                          ],
                        )))),
            Divider(
              color: Colors.green,
            ),
            Text(
              produto["title"],
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            Divider(
              color: Colors.green,
              height: 5,
            ),
            Text(
              produto["subtitle"],
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Divider(
              color: Colors.green,
            ),
            Text(
              produto["describe"],
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  textBaseline: TextBaseline.ideographic,
                  wordSpacing: 2,
                  fontStyle: FontStyle.normal,
                  fontFamily: "Noto Sans"),
            )
          ],
        ),
      ),
    );
  }
}
