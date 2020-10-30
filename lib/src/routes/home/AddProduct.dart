//---- Packages
import 'dart:math';
import 'dart:ui';
import 'package:agricultura/src/routes/home/addProduct/categorys_dropdown.dart';
import 'package:agricultura/src/routes/home/addProduct/form.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

//---- Functions
import 'package:agricultura/src/routes/home/functions/show_modal.dart';
import 'package:agricultura/src/routes/home/addProduct/add_product.dart';

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

  Map dataUser;

  String category;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _subtitleController = TextEditingController();
  TextEditingController _describeController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _cepOrigemController = TextEditingController();

  var image;
  var _snack = GlobalKey<ScaffoldState>();

  //---- Functions

  Future imagem() async {
    var imagePicker = await ImagePicker.platform.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxHeight: 250,
        maxWidth: 1000);
    setState(() {
      image = imagePicker.path;
      _images.insert(_images.length, image);
    });
  }

  Future galery() async {
    var imagePicker = await ImagePicker.platform.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxHeight: 250,
        maxWidth: 1000);
    setState(() {
      image = imagePicker.path;
      _images.insert(_images.length, image);
    });
  }

  @override
  void initState() {
    print("------- AddContet.dart -------");
    listDrop.clear();
    loadCategorys();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _snack,
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
                                    int randonId = Random().nextInt(1000000000);
                                    _snack.currentState.showSnackBar(SnackBar(
                                      content: Text(
                                          "Adicionando Produto ${_titleController.text} ...",
                                          style:
                                              TextStyle(color: Colors.green)),
                                      backgroundColor: Colors.white,
                                      duration: Duration(seconds: 30),
                                    ));
                                    await addProduct(
                                        id: randonId,
                                        images: _images,
                                        title: _titleController.text,
                                        subtitle: _subtitleController.text,
                                        describe: _describeController.text,
                                        category: category,
                                        price: _priceController.text,
                                        weight: _weightController.text,
                                        cepOrigem: _cepOrigemController.text,
                                        context: context);
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
}
