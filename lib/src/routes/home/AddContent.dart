//---- Packages
import 'dart:convert';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

//---- Screens
import 'package:agricultura/src/routes/home/widgets/showModal.dart';

//---- Datas
import 'package:agricultura/src/data/home.dart';
import 'package:path_provider/path_provider.dart';

class AddContent extends StatefulWidget {
  AddContent({Key key, this.name}) : super(key: key);
  final String name;

  @override
  _AddContentState createState() => _AddContentState();
}

class _AddContentState extends State<AddContent> {
  //---- Variables
  int selectedCategory;

  List _images = [];
  List<DropdownMenuItem<int>> listDrop = [];

  Map dataUser;

  String category;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _subtitleController = TextEditingController();
  TextEditingController _describeController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _cepOrigemController = TextEditingController();

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

  Future<File> getData() async {
    final file = await getApplicationDocumentsDirectory();
    return File("${file.path}/data.json");
  }

  Future readData() async {
    var file = await getData();
    var read = jsonDecode(file.readAsStringSync());
    setState(() {
      dataUser = read;
    });
    return dataUser;
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

  weight(String text) {
    setState(() {
      text = _weightController.text;
    });
    print(_weightController.text);
  }

  cepOrigem(String text) {
    setState(() {
      text = _cepOrigemController.text;
    });
    print(_cepOrigemController.text);
  }

  loadData() {
    listDrop.add(DropdownMenuItem(
      child: Text(
        "Adubos",
      ),
      value: 1,
    ));
    listDrop.add(DropdownMenuItem(
      child: Text(
        "Cosméticos",
      ),
      value: 2,
    ));
    listDrop.add(DropdownMenuItem(
      child: Text(
        "Eletrônicos",
      ),
      value: 3,
    ));
    listDrop.add(DropdownMenuItem(
      child: Text(
        "Ferramentas",
      ),
      value: 4,
    ));
    listDrop.add(DropdownMenuItem(
      child: Text(
        "Ter na casa",
      ),
      value: 5,
    ));
  }

  @override
  void initState() {
    print("------- AddContet.dart -------");
    readData();
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
                      formulario(
                          "Peso do Produto",
                          1,
                          _weightController,
                          weight,
                          TextInputType.number,
                          false,
                          TextCapitalization.none,
                          50),
                      Divider(
                        color: Colors.white,
                      ),
                      formulario(
                          "CEP origem",
                          1,
                          _cepOrigemController,
                          cepOrigem,
                          TextInputType.number,
                          false,
                          TextCapitalization.none,
                          50),
                      ClipRRect(
                        child: DropdownButton(
                            value: selectedCategory,
                            hint: Text("Selecione a categoria"),
                            dropdownColor: Colors.green[200],
                            items: listDrop,
                            onChanged: (value) {
                              if (value == 1) {
                                setState(() {
                                  category = "Adubos";
                                });
                              } else if (value == 2) {
                                setState(() {
                                  category = "Cosméticos";
                                });
                              } else if (value == 3) {
                                setState(() {
                                  category = "Eletrônicos";
                                });
                              } else if (value == 4) {
                                setState(() {
                                  category = "Ferramentas";
                                });
                              } else if (value == 5) {
                                setState(() {
                                  category = "Ter na casa";
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
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 30),
                        child: ClipRRect(
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
                                        "title": _titleController.text,
                                        "subtitle": _subtitleController.text,
                                        "describe": _describeController.text,
                                        "image": _images,
                                        "category": category,
                                        "price": _priceController.text,
                                        "views": 0,
                                        "weight": double.parse(
                                            _weightController.text),
                                        "author": dataUser["name"],
                                        "image_author": dataUser["image"],
                                        "cep_origem":
                                            int.parse(_cepOrigemController.text)
                                      });
                                    });
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
                                ))),
                      )
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
