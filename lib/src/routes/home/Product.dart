//---- Packages
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:sigepweb/sigepweb.dart';

//---- Datas
import 'package:agricultura/src/data/user.dart';

class Product extends StatefulWidget {
  Product({Key key, this.item}) : super(key: key);
  final item;
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  //---- Variables

  bool freteBuscado = false;

  List images = [];

  Map sedex = {"name": "", "price": "", "time_delivery": ""};
  Map pac = {"name": "", "price": "", "time_delivery": ""};

  TextEditingController _cepController = TextEditingController();

  var item;
  var _snack = GlobalKey<ScaffoldState>();

  //---- Functions

  correios(String cep) async {
    var sigep = Sigepweb(contrato: SigepContrato.semContrato());
    var calcPrecoPrazo = await sigep.calcPrecoPrazo(
        cepOrigem: "70002900", cepDestino: cep, valorPeso: 1.0);
    for (var item in calcPrecoPrazo) {
      print("${item.nome}: R\$ ${item.valor}");
      if (item.nome == "Sedex") {
        setState(() {
          sedex["name"] = item.nome.toString();
          sedex["price"] = item.valor.toString();
          sedex["time_delivery"] = item.prazoEntrega.toString();
          freteBuscado = true;
        });
      } else {
        setState(() {
          pac["name"] = item.nome.toString();
          pac["price"] = item.valor.toString();
          pac["time_delivery"] = item.prazoEntrega.toString();
          freteBuscado = true;
        });
      }
    }
  }

  imagesL() {
    for (var x = 0; x < 20; x++) {
      try {
        images.add(item["image"][x]);
        print("Add");
      } catch (e) {
        print(e);
      }
    }
  }

  addInUser(String text) {
    List usuario;
    setState(() {
      usuario = user[text];
    });
    print("Usuario: " + usuario.toString());
    if (usuario.length >= 1) {
      for (var x = 0; x < usuario.length; x++) {
        if (usuario[x] == item["id"]) {
          usuario.forEach((element) {
            if (element == item["id"]) {
              setState(() {
                usuario.remove(element);
              });
              _snack.currentState.showSnackBar(SnackBar(
                content: Text(
                  "Removido do $text",
                  style: TextStyle(color: Colors.green),
                ),
                backgroundColor: Colors.white,
              ));
              print("$text removido");
              print(usuario);
            }
          });
        } else {
          setState(() {
            usuario.add(item["id"]);
            user[text] = usuario;
          });
          _snack.currentState.showSnackBar(SnackBar(
            content: Text(
              "Adicionado no $text",
              style: TextStyle(color: Colors.green),
            ),
            backgroundColor: Colors.white,
          ));
          print("Adiciona");
        }
      }
    } else {
      setState(() {
        usuario.add(item["id"]);
        user[text] = usuario;
      });
      _snack.currentState.showSnackBar(SnackBar(
        content: Text(
          "Adicionado no $text",
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.white,
      ));
      print("Primeiro $text do perfil :)");
    }
    print(usuario.length.toString() +
        " id cadastrado com valor: " +
        user[text].toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    print("-------- Product.dart---------");
    item = widget.item;
    imagesL();
    setState(() {
      item["views"] += 1;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _snack,
        backgroundColor: Colors.green,
        body: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40)),
                child: Container(
                  color: Colors.white,
                  width: 1000,
                  height: 330,
                  child: Column(children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.green,
                                    size: 44,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              Spacer(),
                              IconButton(
                                  tooltip: "Adicionar no carrinho",
                                  icon: Icon(
                                    Icons.add_shopping_cart_sharp,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    addInUser("car_shop");
                                  }),
                              IconButton(
                                  tooltip: "Compartilhar",
                                  icon: Icon(
                                    Icons.share,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {}),
                              IconButton(
                                  tooltip: "Adicionar no favoritos",
                                  icon:
                                      Icon(Icons.favorite, color: Colors.green),
                                  onPressed: () {
                                    addInUser("favorites");
                                  }),
                            ],
                          ),
                        ),
                        CarouselSlider.builder(
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.file(
                                    File(images[index]),
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.fill,
                                  ));
                            },
                            options: CarouselOptions(
                                height: 220,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                enableInfiniteScroll: false))
                      ],
                    ),
                  ]),
                ),
              ),
              Text(
                "${item["title"]}",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              Text(
                "${item["subtitle"]}",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      color: Colors.white,
                      child: TextFormField(
                        controller: _cepController,
                        onChanged: (e) {
                          if (_cepController.text.length == 8) {
                            print("Igual a oito");
                          }
                          print(e);
                        },
                        cursorColor: Colors.green,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.place_rounded,
                              color: Colors.green,
                            ),
                            border: InputBorder.none,
                            hintText: "CEP do destino",
                            contentPadding: EdgeInsets.all(20)),
                      ),
                    )),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  width: 200,
                  height: 40,
                  child: RaisedButton(
                    onPressed: () async {
                      if (_cepController.text.length == 8) {
                        await correios(_cepController.text);
                      } else {
                        _snack.currentState.showSnackBar(SnackBar(
                          content: Text(
                            "CEP ${_cepController.text} inválido",
                            style: TextStyle(color: Colors.green),
                          ),
                          backgroundColor: Colors.white,
                        ));
                      }
                    },
                    color: Colors.white,
                    child: Text(
                      "Ver frete",
                      style: TextStyle(color: Colors.green, fontSize: 16),
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.green,
              ),
              AnimatedCrossFade(
                  firstChild: Text(""),
                  secondChild: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: 200,
                        color: Colors.white,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  sedex["name"],
                                  style: TextStyle(color: Colors.green),
                                ),
                                Spacer(),
                                Text(
                                  "R\$" + sedex["price"].toString(),
                                  style: TextStyle(color: Colors.green[200]),
                                )
                              ],
                            ),
                            Divider(color: Colors.green),
                            Row(
                              children: [
                                Text(
                                  pac["name"],
                                  style: TextStyle(color: Colors.green),
                                ),
                                Spacer(),
                                Text(
                                  "R\$" + pac["price"].toString(),
                                  style: TextStyle(color: Colors.green[200]),
                                )
                              ],
                            )
                          ],
                        ),
                      )),
                  crossFadeState: freteBuscado == true
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 400)),
            ],
          ),
        ));
  }
}
