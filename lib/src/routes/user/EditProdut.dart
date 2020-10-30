//---- Packages
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//---- API
import 'package:agricultura/src/firebase/api_firebase.dart';

//---- Widgets
import 'package:agricultura/src/routes/user/functions/form.dart';

class EditProdut extends StatefulWidget {
  EditProdut({Key key, this.data}) : super(key: key);
  final QueryDocumentSnapshot data;

  @override
  _EditProdutState createState() => _EditProdutState();
}

class _EditProdutState extends State<EditProdut> {
  //---- Variables

  bool editTitle = true;
  bool editSubtitle = true;
  bool editDescribe = true;

  int _indexImage = 0;

  List _images = [];

  Map produto;

  TextEditingController _describeController = TextEditingController();
  TextEditingController _subtitleController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _cepController = TextEditingController();

  var _snack = GlobalKey<ScaffoldState>();
  var _form = GlobalKey<FormState>();

  //---- Functions

  getImages() {
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

  updateProduct() {
    setState(() {
      produto["title"] = _titleController.text;
      produto["subtitle"] = _subtitleController.text;
      produto["describe"] = _describeController.text;
      produto["price"] = double.parse(_priceController.text);
      produto["cep_origem"] = _cepController.text;
    });
  }

  void snackBar(String text) {
    _snack.currentState.showSnackBar(SnackBar(
      content: Text(
        "$text",
        style: TextStyle(color: Colors.green),
      ),
      backgroundColor: Colors.white,
    ));
  }

  @override
  void initState() {
    print("-------- EditProdut.dart ---------");
    produto = widget.data.data();

    _titleController.text = produto["title"];
    _subtitleController.text = produto["subtitle"];
    _describeController.text = produto["describe"];
    _priceController.text = produto["price"].toString();
    _cepController.text = produto["cep_origem"].toString();

    getImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _snack,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_form.currentState.validate()) {
            await updateProduct();

            try {
              setState(() {
                dataUser.updateProduct(widget.data.id, produto);
              });
              snackBar("Atualizado com sucesso");
              await Future.delayed(
                  Duration(milliseconds: 1500), () => Navigator.pop(context));
            } catch (e) {
              print(e);
              snackBar("Error para atualizar");
            }
          }
        },
        child: Text("Att", style: TextStyle(color: Colors.green)),
        backgroundColor: Colors.white,
      ),
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
                                        child: Image.network(
                                          _images[index],
                                          filterQuality: FilterQuality.low,
                                          fit: BoxFit.fill,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            return loadingProgress == null
                                                ? child
                                                : LinearProgressIndicator();
                                          },
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
            Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      campText(
                          controller: _titleController,
                          subtitle: "Titulo",
                          minValue: 4,
                          maxValue: 20,
                          minLines: 1,
                          maxLines: 1),
                      Divider(color: Colors.white),
                      campText(
                          controller: _subtitleController,
                          subtitle: "Subtíitulo",
                          minValue: 4,
                          maxValue: 20,
                          minLines: 1,
                          maxLines: 1),
                      Divider(color: Colors.white),
                      campText(
                          controller: _describeController,
                          subtitle: "Descrição",
                          minValue: 30,
                          maxValue: 300,
                          minLines: 2,
                          maxLines: 50),
                      Divider(color: Colors.white),
                      campText(
                          controller: _priceController,
                          subtitle: "Preço",
                          minValue: 2,
                          maxValue: 6,
                          minLines: 1,
                          maxLines: 1),
                      Divider(color: Colors.white),
                      campText(
                          controller: _cepController,
                          subtitle: "CEP",
                          minValue: 8,
                          maxValue: 8,
                          minLines: 1,
                          maxLines: 1),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
