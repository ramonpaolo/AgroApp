//---- Packages
import 'dart:ui';
import 'package:agricultura/src/routes/home/showModal.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

//---- Datas
import 'package:agricultura/src/data/home.dart';

class AddContent extends StatefulWidget {
  AddContent({Key key, this.name}) : super(key: key);
  final String name;
  @override
  _AddContentState createState() => _AddContentState();
}

class _AddContentState extends State<AddContent> {
  //---- Variables

  TextEditingController _titleController = TextEditingController();
  TextEditingController _subtitleController = TextEditingController();
  TextEditingController _describeController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  var image;

  //---- Functions

  Future imagem() async {
    var imagePicker =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    setState(() {
      image = imagePicker.path;
    });
  }

  Future galery() async {
    var imagePicker =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      image = imagePicker.path;
    });
  }

  title(String text) {
    setState(() {
      text = _titleController.text;
    });
    print(_titleController.text);
  }

  subtitle(String text) {
    setState(() {
      text = _subtitleController.text;
    });
    print(_subtitleController.text);
  }

  describe(String text) {
    setState(() {
      text = _describeController.text;
    });
    print(_describeController.text);
  }

  price(String text) {
    setState(() {
      text = _priceController.text;
    });
    print(_priceController.text);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.only(top: 50, left: 30, right: 30),
            child: Container(
                width: size.width,
                height: size.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              tooltip: "Abrir Pasta",
                              icon: Icon(
                                Icons.attach_file,
                                color: Colors.green,
                                semanticLabel: "Escolher arquivo",
                              ),
                              onPressed: galery),
                          IconButton(
                              tooltip: "Tirar foto",
                              icon: Icon(
                                Icons.add_a_photo,
                                color: Colors.green,
                                semanticLabel: "Tirar foto",
                              ),
                              onPressed: imagem),
                        ],
                      ),
                      image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Card(
                                  child: Image.file(
                                File(image),
                                width: size.width * 0.5,
                              )))
                          : Text("Adicione uma imagem"),
                      Divider(
                        color: Colors.white,
                      ),
                      formulario("Titulo", 1, 0, _titleController, title,
                          TextInputType.name),
                      Divider(
                        color: Colors.white,
                      ),
                      formulario("Subtítulo", 3, 15, _subtitleController,
                          subtitle, TextInputType.text),
                      Divider(
                        color: Colors.white,
                      ),
                      formulario("Describe", 3, 15, _describeController,
                          describe, TextInputType.text),
                      Divider(
                        color: Colors.white,
                      ),
                      formulario("Price", 1, 1, _priceController, price,
                          TextInputType.number),
                      Divider(
                        color: Colors.white,
                      ),
                      Text(
                          "Clique no botão para visualizar o conteudo antes de ser postado.",
                          style: TextStyle(fontSize: 12)),
                      Text(
                        "Segure o botão para adicionar o conteudo e sair.",
                        style: TextStyle(fontSize: 12),
                      ),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: RaisedButton.icon(
                            splashColor: Colors.white,
                            onPressed: () {
                              showModal(context, image, size, _titleController,
                                  _subtitleController);
                            },
                            onLongPress: () async {
                              setState(() {
                                plantas.insert(0, {
                                  "id": 3,
                                  "favorite": false,
                                  "title": "${_titleController.text}",
                                  "subtitle": "${_subtitleController.text}",
                                  "image": "$image",
                                  "checbox": false,
                                  "author": "${widget.name}",
                                  "image_author": "assets/images/eu.jpg",
                                  "describe": "${_describeController.text}",
                                  "views": 0,
                                  "price": "${_priceController.text}",
                                });
                              });
                              await Future.delayed(Duration(seconds: 1),
                                  () => Navigator.pop(context));
                            },
                            icon: Icon(
                              Icons.check,
                              color: Colors.white,
                              semanticLabel: "Check",
                            ),
                            label: Text(
                              "Adicionar a venda",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.green,
                          ))
                    ],
                  ),
                ))));
  }

  Widget formulario(
      String hintText,
      int maxLines,
      double top,
      TextEditingController controller,
      Function fun,
      TextInputType textInputType) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Container(
          height: 50,
          color: Colors.green[200],
          child: TextField(
            controller: controller,
            onChanged: (e) {
              fun(e);
            },
            keyboardType: textInputType,
            textAlign: TextAlign.start,
            textCapitalization: TextCapitalization.words,
            maxLines: maxLines,
            cursorColor: Colors.green[900],
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20, top: top),
                border: InputBorder.none,
                hintText: hintText,
                fillColor: Colors.white),
          ),
        ));
  }
}
