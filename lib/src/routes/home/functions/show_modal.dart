//---- Packages
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';

int _pagePhoto = 0;

Future showModal(context, _images, size, _titleController, _subtitleController,
    _describeController, _priceController) {
  return showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      ),
      context: context,
      builder: (c) {
        return ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            child: BottomSheet(
                onClosing: () {},
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Container(
                          padding: EdgeInsets.all(20),
                          width: 1000,
                          height: 1000,
                          child: SingleChildScrollView(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ListTile(
                                title: Text(
                                  _titleController.text,
                                  style: TextStyle(fontSize: 16),
                                ),
                                subtitle: Text(
                                  _subtitleController.text,
                                  style: TextStyle(fontSize: 14),
                                ),
                                trailing: Text(
                                  "R\$${_priceController.text}",
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 14),
                                ),
                              ),
                              _images.length >= 1
                                  ? CarouselSlider.builder(
                                      itemCount: _images.length,
                                      itemBuilder: (context, index) {
                                        return ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: Stack(
                                              alignment: Alignment(1, 1),
                                              children: [
                                                Image.file(
                                                  File(_images[index]),
                                                  filterQuality:
                                                      FilterQuality.high,
                                                  fit: BoxFit.fill,
                                                ),
                                              ],
                                            ));
                                      },
                                      options: CarouselOptions(
                                          pauseAutoPlayOnTouch: true,
                                          enlargeCenterPage: true,
                                          autoPlay: true,
                                          initialPage: 0,
                                          viewportFraction: 0.9,
                                          onPageChanged: (context, index) {
                                            setState(() {
                                              _pagePhoto = context;
                                            });
                                          }))
                                  : Text("Adicione uma imagem antes"),
                              Text("${_pagePhoto + 1}/${_images.length}",
                                  style: TextStyle(color: Colors.green)),
                              Divider(
                                color: Colors.white,
                              ),
                              Text("${_describeController.text}")
                            ],
                          )));
                    },
                  );
                }));
      });
}
