//---- Packages
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

//---- Screens
import 'package:agricultura/src/routes/chat/PageHero.dart';

//---- Datas
import 'package:agricultura/src/data/chat.dart';

class ChatPV extends StatefulWidget {
  ChatPV({Key key, this.name, this.messages, this.image, this.id})
      : super(key: key);
  final name;
  final messages;
  final image;
  final id;

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
      messages.insert(0, {"type": "img", "submit": "i", "content": "$_image"});
      _images.add(_image);
    });

    print(messages[0]["content"]);
  }

  void galery() async {
    var imagePicker =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = imagePicker.path;
      messages.insert(0, {"type": "img", "submit": "i", "content": "$_image"});
      _images.add(_image);
    });
  }

  Future<File> _getData() async {
    final directory = await getApplicationDocumentsDirectory();
    var file = File("${directory.path}/data.json");
    return file;
  }

  Future _saveData() async {
    final path = await _getData();
    final file = {
      "id": 1,
      "name": "Dudu",
      "mensagen": [
        {"type": "txt", "submit": "you", "content": "Eaee"}
      ],
      "image": "assets/eu.jpg"
    };
    return await path.writeAsString(file.toString());
  }

  Future _readData() async {
    final data = await _getData();

    var j = await json.decode(data.readAsString().toString());
    print(await j);
  }

  @override
  void initState() {
    // TODO: implement initState
    messages = users[widget.id]["mensagen"];
    print(messages);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //This cause error in bottomSheet
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          RaisedButton(onPressed: _readData),
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
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (c) {
                                            return Container(
                                                height: 1000,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(200),
                                                        child: Image.asset(
                                                          widget.image,
                                                          width: 200,
                                                        ),
                                                      ),
                                                      Text(
                                                        widget.name,
                                                        style: TextStyle(
                                                            fontSize: 24),
                                                      ),
                                                      SizedBox(
                                                          width: 1000,
                                                          height: 130,
                                                          child:
                                                              ListView.builder(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              20),
                                                                  child: ClipRRect(
                                                                      borderRadius: BorderRadius.circular(30),
                                                                      child: Container(
                                                                          width: 100,
                                                                          child: GestureDetector(
                                                                            onTap: () =>
                                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => PageHero(_image))),
                                                                            child:
                                                                                Hero(tag: index, child: Card(child: Image.asset(_images[index]))),
                                                                          ))));
                                                            },
                                                            itemCount:
                                                                _images.length,
                                                          ))
                                                    ],
                                                  ),
                                                ));
                                          });
                                    },
                                    tooltip: "Menu usuário",
                                  )),
                            ),
                          ],
                        )),
                    messages[0]["content"] != null
                        ? Text(messages[0]["content"])
                        : Text("Null"),
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
              height: 530,
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    child: GestureDetector(
                        child: Padding(
                            padding: EdgeInsets.only(
                                left:
                                    messages[index]["submit"] == "i" ? 240 : 0,
                                bottom: 5,
                                right:
                                    messages[index]["submit"] == "i" ? 5 : 240),
                            child: Container(
                                padding: EdgeInsets.all(10),
                                child: Card(
                                    color: messages[index]["submit"] == "i"
                                        ? Colors.green[600]
                                        : Colors.white,
                                    child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: messages[index]["type"] == "img"
                                            ? Image.asset(
                                                messages[index]["content"],
                                                width: 200,
                                                height: 200,
                                              )
                                            : messages[index]["submit"] == "i"
                                                ? Text(
                                                    "${messages[index]["content"]}",
                                                    style: TextStyle(
                                                        color: Colors.white70),
                                                  )
                                                : Text(
                                                    "${messages[index]["content"]}")))))),
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
                        showModalBottomSheet(
                            context: context,
                            builder: (bc) {
                              return Container(
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
                              );
                            });
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
                          "submit": "i",
                          "content": "$_text"
                        });
                      });
                      //messages.add({"type": "txt", "content": "$value"});
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
                  messages.insert(
                      0, {"type": "txt", "submit": "i", "content": "$_text"});
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
