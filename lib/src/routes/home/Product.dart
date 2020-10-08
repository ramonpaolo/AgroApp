//---- Packages
import 'package:agricultura/src/data/user.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class Product extends StatefulWidget {
  Product({Key key, this.item}) : super(key: key);
  final item;
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  var item;
  List images = [];
  var _snack = GlobalKey<ScaffoldState>();
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

  @override
  void initState() {
    // TODO: implement initState
    print("-------- Product.dart---------");
    item = widget.item;
    imagesL();
    setState(() {
      item["views"] += 1;
    });
    print(item["image"][0]);
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
                                  onPressed: () {}),
                              IconButton(
                                  tooltip: "Compartilhar",
                                  icon: Icon(
                                    Icons.share,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {}),
                              IconButton(
                                  tooltip: "Adicionar no favoritos",
                                  icon: Icon(Icons.favorite),
                                  onPressed: () {
                                    List usuario;
                                    setState(() {
                                      usuario = user["favorites"];
                                    });
                                    print("Usuario" + usuario.toString());
                                    if (usuario.length >= 1) {
                                      for (var x = 0; x < usuario.length; x++) {
                                        if (usuario[x] == item["id"]) {
                                          if (x == usuario.length - 1) {
                                            _snack.currentState
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                "Já está em seu favoritos",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                              action: SnackBarAction(
                                                textColor: Colors.green[400],
                                                label: "Tirar favorito",
                                                onPressed: () {
                                                  usuario.forEach((element) {
                                                    if (element == item["id"]) {
                                                      setState(() {
                                                        usuario.remove(element);
                                                      });
                                                      print(
                                                          "Favorito removido");
                                                    }
                                                  });
                                                  //user.removeWhere(
                                                  //    (key, value) => key == "favorite" ? value == item["id"]);
                                                },
                                              ),
                                              backgroundColor: Colors.white,
                                            ));
                                          }
                                        } else {
                                          setState(() {
                                            usuario.add(item["id"]);
                                            user["favorites"] = usuario;
                                          });
                                        }
                                      }
                                    } else {
                                      setState(() {
                                        usuario.add(item["id"]);
                                        user["favorites"] = usuario;
                                      });
                                      print("Primeiro favorito do perfil :)");
                                    }
                                    print(usuario.length.toString() +
                                        " id cadastrado com valor: " +
                                        user["favorites"].toString());
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
                        cursorColor: Colors.green,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.place_rounded,
                              color: Colors.green,
                            ),
                            border: InputBorder.none,
                            hintText: "CEP",
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
                    onPressed: () {},
                    color: Colors.white,
                    child: Text(
                      "Ver frete",
                      style: TextStyle(color: Colors.green, fontSize: 16),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
