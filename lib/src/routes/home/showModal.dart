import 'package:flutter/material.dart';
import 'dart:io';

showModal(context, image, size, _titleController, _subtitleController) {
  return showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (c) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: Text(
                _titleController.text,
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                _subtitleController.text,
                style: TextStyle(fontSize: 18),
              ),
            ),
            image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                        height: size.height * 0.42,
                        color: Colors.green[200],
                        padding: EdgeInsets.all(20),
                        child: Column(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: Image.file(
                              File(image),
                              width: size.width * 0.7,
                              height: size.height * 0.2,
                            ),
                          ),
                          SizedBox(
                              width: 1000,
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Container(
                                      padding: EdgeInsets.only(left: 5, top: 2),
                                      width: 100,
                                      height: 50,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(90),
                                          child: Image.asset(
                                            image,
                                            fit: BoxFit.fill,
                                          )));
                                },
                                itemCount: 10,
                              ))
                        ])),
                  )
                : Text("Adicione uma imagem antes")
          ],
        );
      });
}
