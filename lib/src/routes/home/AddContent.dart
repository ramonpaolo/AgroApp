//---- Packages
import 'dart:ui';
import 'package:agricultura/src/data/home.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddContent extends StatefulWidget {
  @override
  _AddContentState createState() => _AddContentState();
}

class _AddContentState extends State<AddContent> {
  //---- Variables

  TextEditingController _titleController = TextEditingController();
  TextEditingController _subtitleController = TextEditingController();

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
      _titleController.text = text;
    });
    print(_titleController.text);
  }

  subtitle(String text) {
    setState(() {
      _subtitleController.text = text;
    });
    print(_subtitleController.text);
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
                                  child: Image.asset(
                                image,
                                width: size.width * 0.5,
                              )))
                          : Text("Adicione uma imagem"),
                      Divider(
                        color: Colors.white,
                      ),
                      formulario("Titulo", 1, 0, _titleController, title),
                      Divider(
                        color: Colors.white,
                      ),
                      formulario(
                          "Subtítulo", 3, 15, _subtitleController, subtitle),
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
                              showModalBottomSheet(
                                  backgroundColor: Colors.white,
                                  context: context,
                                  builder: (c) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Container(
                                                    height: size.height * 0.42,
                                                    color: Colors.green[200],
                                                    padding: EdgeInsets.all(20),
                                                    child: Column(children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(200),
                                                        child: Image.asset(
                                                          image,
                                                          width:
                                                              size.width * 0.7,
                                                          height:
                                                              size.height * 0.2,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width: 1000,
                                                          height: 100,
                                                          child:
                                                              ListView.builder(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              5,
                                                                          top:
                                                                              2),
                                                                  width: 100,
                                                                  height: 50,
                                                                  child: ClipRRect(
                                                                      borderRadius: BorderRadius.circular(90),
                                                                      child: Image.asset(
                                                                        image,
                                                                        fit: BoxFit
                                                                            .fill,
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
                            },
                            onLongPress: () {
                              setState(() {
                                plantas.insert(0, {
                                  "id": 3,
                                  "favorite": false,
                                  "title": "${_titleController.text}",
                                  "subtitle": "${_subtitleController.text}",
                                  "image": "$image",
                                  "checbox": false
                                });
                              });
                              Future.delayed(Duration(seconds: 1),
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

  Widget formulario(String hintText, int maxLines, double top,
      TextEditingController controller, Function fun) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Container(
          height: 50,
          color: Colors.green[200],
          child: TextField(
            onChanged: (e) {
              fun(e);
            },
            keyboardType: TextInputType.text,
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
