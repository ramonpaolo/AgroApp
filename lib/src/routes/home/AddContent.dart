//---- Packages
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

//---- Screens
import 'package:agricultura/src/routes/home/widgets/showModal.dart';

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

  List _images = [];
  List<DropdownMenuItem<int>> listDrop = [];

  int selectedCategory;

  String category = "";

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
      _images.insert(_images.length, image);
    });
  }

  Future galery() async {
    var imagePicker =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      image = imagePicker.path;
      _images.insert(_images.length, image);
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

  loadData() {
    listDrop.add(DropdownMenuItem(
      child: Text(
        "Plantas",
      ),
      value: 1,
    ));
    listDrop.add(DropdownMenuItem(
      child: Text(
        "Adubo",
      ),
      value: 2,
    ));
    listDrop.add(DropdownMenuItem(
      child: Text(
        "Cosméticos",
      ),
      value: 3,
    ));
    listDrop.add(DropdownMenuItem(
      child: Text(
        "Peças",
      ),
      value: 4,
    ));
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.only(top: 20),
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
                      _images.length >= 1
                          ? CarouselSlider.builder(
                              itemCount: _images.length,
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Stack(
                                      alignment: Alignment(1, 1),
                                      children: [
                                        Image.file(
                                          File(_images[index]),
                                          filterQuality: FilterQuality.high,
                                          fit: BoxFit.fill,
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _images.removeAt(index);
                                              });
                                            })
                                      ],
                                    ));
                              },
                              options: CarouselOptions(
                                  enlargeCenterPage: true,
                                  enableInfiniteScroll: false,
                                  autoPlay: true,
                                  initialPage: 0,
                                  onPageChanged: (context, index) =>
                                      print(context)))
                          : Text("Adicione uma imagem"),
                      Divider(
                        color: Colors.white,
                      ),
                      formulario(
                          "Titulo",
                          1,
                          _titleController,
                          title,
                          TextInputType.name,
                          false,
                          TextCapitalization.words,
                          50),
                      Divider(
                        color: Colors.white,
                      ),
                      formulario(
                          "Subtítulo",
                          3,
                          _subtitleController,
                          subtitle,
                          TextInputType.text,
                          false,
                          TextCapitalization.sentences,
                          50),
                      Divider(
                        color: Colors.white,
                      ),
                      formulario(
                          "Descrição",
                          20,
                          _describeController,
                          describe,
                          TextInputType.multiline,
                          false,
                          TextCapitalization.sentences,
                          90),
                      Divider(
                        color: Colors.white,
                      ),
                      formulario(
                          "Preço",
                          1,
                          _priceController,
                          price,
                          TextInputType.number,
                          true,
                          TextCapitalization.sentences,
                          50),
                      Divider(
                        color: Colors.white,
                      ),
                      ClipRRect(
                        child: DropdownButton(
                            value: selectedCategory,
                            hint: Text("Selecione a categoria"),
                            dropdownColor: Colors.green[200],
                            items: listDrop,
                            onChanged: (value) {
                              if (value == 1) {
                                setState(() {
                                  category = "Plantas";
                                });
                              } else if (value == 2) {
                                setState(() {
                                  category = "Adubos";
                                });
                              } else if (value == 3) {
                                setState(() {
                                  category = "Cosméticos";
                                });
                              } else if (value == 4) {
                                setState(() {
                                  category = "Peças";
                                });
                              }
                              setState(() {
                                selectedCategory = value;
                              });
                            }),
                      ),
                      Text(
                          "Clique no botão para visualizar o conteudo antes de ser postado.",
                          style: TextStyle(fontSize: 12)),
                      Text(
                        "Segure o botão para adicionar o conteudo e sair.",
                        style: TextStyle(fontSize: 12),
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: Container(
                              width: size.width * 0.6,
                              height: size.height * 0.07,
                              child: RaisedButton.icon(
                                splashColor: Colors.white,
                                onPressed: () {
                                  showModal(
                                      context,
                                      _images,
                                      size,
                                      _titleController,
                                      _subtitleController,
                                      _describeController,
                                      _priceController);
                                },
                                onLongPress: () async {
                                  setState(() {
                                    produtos.insert(0, {
                                      "id": 0,
                                      "favorite": false,
                                      "title": "${_titleController.text}",
                                      "subtitle": "${_subtitleController.text}",
                                      "image": _images,
                                      "checbox": false,
                                      "author": "${widget.name}",
                                      "category": category,
                                      "image_author": "assets/images/eu.jpg",
                                      "describe": "${_describeController.text}",
                                      "views": 0,
                                      "price": "${_priceController.text}",
                                    });
                                  });
                                  print(category);
                                  Navigator.pop(context);
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
                              )))
                    ],
                  ),
                ))));
  }

  Widget formulario(
      String hintText,
      int maxLines,
      TextEditingController controller,
      Function fun,
      TextInputType textInputType,
      bool prefix,
      TextCapitalization textCapitalization,
      double size) {
    return Padding(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              height: size,
              color: Colors.green[200],
              child: TextField(
                controller: controller,
                onChanged: (e) {
                  fun(e);
                },
                keyboardType: textInputType,
                textAlign: TextAlign.start,
                textCapitalization: textCapitalization,
                maxLines: maxLines,
                cursorColor: Colors.green[900],
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: 20, top: size * 0.1, bottom: size * 0.1),
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: TextStyle(color: Colors.white),
                    prefixText: prefix ? "R\$" : null,
                    fillColor: Colors.white),
              ),
            )));
  }
}
