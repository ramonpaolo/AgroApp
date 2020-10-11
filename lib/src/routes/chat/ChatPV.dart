//---- Packages
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

//---- Screens
import 'package:agricultura/src/routes/chat/showModal.dart';

//---- Datas
import 'package:agricultura/src/data/chat.dart';

class ChatPV extends StatefulWidget {
  ChatPV({Key key, this.name, this.messages, this.image, this.id, this.user})
      : super(key: key);
  final name;
  final messages;
  final image;
  final id;
  final user;

  @override
  _ChatPVState createState() => _ChatPVState();
}

class _ChatPVState extends State<ChatPV> {
  //---- Variables

  List messages;
  List _images = [];

  String _text;

  var _image;

  var id;
  //---- Functions

  void imagem() async {
    var imagePicker =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    setState(() {
      _image = imagePicker.path;
      messages.insert(0, {
        "type": "img",
        "name": "${widget.user["name"]}",
        "content": "$_image"
      });
      _images.add(_image);
    });
    //print(messages[0]["content"]);
  }

  void galery() async {
    var imagePicker =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = imagePicker.path;
      messages.insert(0, {
        "type": "img",
        "name": "${widget.user["name"]}",
        "content": "$_image"
      });
      _images.add(_image);
    });
  }

  @override
  void initState() {
    print("-------------- ChatPV.dart -----------------");
    messages = users[widget.id]["mensagen"];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //This cause error in bottomSheet
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60),
                bottomRight: Radius.circular(60)),
            child: Container(
                color: Colors.green,
                height: 140,
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 3),
                              child: BackButton(
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Container(
                                  height: 50,
                                  width: 270,
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(2),
                                        child: ClipRRect(
                                          child: Image.asset(widget.image),
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                      ),
                                      Text(
                                        widget.name,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Container(
                                  height: 60,
                                  width: 60,
                                  color: Colors.white,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.dehaze,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      showModalDrazer(_images, context, widget);
                                    },
                                    tooltip: "Menu usuário",
                                  )),
                            ),
                          ],
                        )),
                    Divider(
                      height: 8,
                      color: Colors.green,
                    ),
                    Text(
                      "On-line",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )
                  ],
                )),
          ),
          Container(
              padding: EdgeInsets.only(bottom: 30),
              width: 1000,
              height: 530,
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    child: GestureDetector(
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: messages[index]["name"] ==
                                        "${widget.user["name"]}"
                                    ? 200
                                    : 0,
                                bottom: 5,
                                right: messages[index]["name"] ==
                                        "${widget.user["name"]}"
                                    ? 5
                                    : 140),
                            child: Container(
                                width: 1000,
                                padding: EdgeInsets.all(10),
                                child: Card(
                                    color: messages[index]["name"] ==
                                            "${widget.user["name"]}"
                                        ? Colors.green[600]
                                        : Colors.white,
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            top:
                                                messages[index]["type"] == "img"
                                                    ? 15
                                                    : 0),
                                        child: messages[index]["type"] == "img"
                                            ? Column(
                                                children: [
                                                  Image.file(
                                                    File(messages[index]
                                                        ["content"]),
                                                    filterQuality:
                                                        FilterQuality.high,
                                                    fit: BoxFit.fill,
                                                  ),
                                                  messages[index]["name"] ==
                                                          widget.user["name"]
                                                      ? ListTile(
                                                          title: Text(
                                                          "${widget.user["name"]}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white70),
                                                        ))
                                                      : ListTile(
                                                          title: Text(
                                                          "${widget.name}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ))
                                                ],
                                              )
                                            : messages[index]["name"] ==
                                                    "${widget.user["name"]}"
                                                ? ListTile(
                                                    title: Text(
                                                      "${messages[index]["content"]}",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    subtitle: Text(
                                                      "${messages[index]["name"]}",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white70),
                                                    ))
                                                : ListTile(
                                                    title: Text(
                                                        "${messages[index]["content"]}"),
                                                    subtitle:
                                                        Text("${widget.name}"),
                                                  )))))),
                    borderRadius: BorderRadius.circular(40),
                  );
                },
              ))
        ]),
      ),
      bottomSheet: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.green,
                  child: IconButton(
                      tooltip: "Arquivos",
                      icon: Icon(
                        Icons.attachment,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        showModal(context, imagem, galery);
                      }),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 15),
                  color: Colors.green[100],
                  width: 300,
                  height: 60,
                  child: TextField(
                    onChanged: (value) {
                      _text = value;
                      print(_text);
                    },
                    autocorrect: true,
                    onSubmitted: (value) {
                      setState(() {
                        messages.insert(0, {
                          "type": "txt",
                          "content": "$_text",
                          "name": "${widget.user["name"]}"
                        });
                      });
                    },
                    maxLines: 60,
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.green[900],
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: "Digite sua mensagem aqui..."),
                  ),
                )),
          ),
          IconButton(
              icon: Icon(Icons.arrow_forward_ios, color: Colors.green),
              onPressed: () {
                setState(() {
                  messages.insert(0, {
                    "type": "txt",
                    "content": "$_text",
                    "name": "${widget.user["name"]}"
                  });
                });
              })
        ],
      ),
    );
  }
}

/*import 'package:flutter/material.dart';
import 'dart:async';

import 'package:image_picker/image_picker.dart';

class ChatPV extends StatefulWidget {
  ChatPV({Key key, this.name, this.messages, this.image}) : super(key: key);
  final String name;
  final messages;
  final String image;
  @override
  _ChatPVState createState() => _ChatPVState();
}

class _ChatPVState extends State<ChatPV> {
  List messages;
  String _text;
  var imagen;
  void imagem() async {
    var image =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    setState(() {
      imagen = image;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    messages = widget.messages;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60),
                bottomRight: Radius.circular(60)),
            child: Container(
                color: Colors.green,
                height: size.height * 0.2,
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 3),
                              child: BackButton(
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Container(
                                  height: size.height * 0.09,
                                  width: size.width * 0.65,
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(2),
                                        child: ClipRRect(
                                          child: Image.asset(widget.image),
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                      ),
                                      Text(
                                        widget.name,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Container(
                                  height: 60,
                                  width: 60,
                                  color: Colors.white,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.dehaze,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (c) {
                                            return Container(
                                              height: size.height * 0.5,
                                              child: Column(
                                                children: [Text("AAA")],
                                              ),
                                            );
                                          });
                                    },
                                    tooltip: "Menu usuário",
                                  )),
                            ),
                          ],
                        )),
                    Divider(
                      height: 8,
                      color: Colors.green,
                    ),
                    Text(
                      "On-line",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )
                  ],
                )),
          ),
          Container(
              width: 1000,
              height: 200,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ClipRRect(
                    child: GestureDetector(
                        child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(messages[index]),
                      ),
                    )),
                    borderRadius: BorderRadius.circular(40),
                  );
                },
                itemCount: messages.length,
              ))
        ]),
      ),
      bottomSheet: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.green,
                  child: IconButton(
                      tooltip: "Arquivos",
                      icon: Icon(
                        Icons.attachment,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (bc) {
                              return Container(
                                height: size.height * 0.35,
                                child: Column(
                                  children: [
                                    Container(
                                        child: Row(children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: size.width * 0.1),
                                        child: IconButton(
                                          icon: Icon(Icons.image),
                                          iconSize: 88.0,
                                          tooltip: "Tirar foto",
                                          color: Colors.green,
                                          onPressed: imagem,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: size.width * 0.3),
                                        child: IconButton(
                                          icon: Icon(Icons.filter),
                                          iconSize: 88.0,
                                          tooltip: "Pegar na galeria",
                                          onPressed: () {},
                                          color: Colors.green,
                                        ),
                                      )
                                    ])),
                                  ],
                                ),
                              );
                            });
                      }),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 15),
                  color: Colors.green[100],
                  width: size.width * 0.8,
                  height: size.height * 0.08,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _text = value;
                      });
                    },
                    autocorrect: false,
                    autofocus: false,
                    onSubmitted: (value) => messages.add(_text),
                    maxLines: 60,
                    minLines: 1,
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.green[900],
                    expands: false,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: "Digite sua mensagem aqui..."),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
 */
