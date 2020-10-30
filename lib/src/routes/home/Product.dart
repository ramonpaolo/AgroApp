//---- Packages
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';
import 'package:sigepweb/sigepweb.dart';

//---- API
import 'package:agricultura/src/firebase/api_firebase.dart';

//---- Screens
import 'package:agricultura/src/routes/home/HeroImage.dart';

class Product extends StatefulWidget {
  Product({Key key, this.item}) : super(key: key);
  final item;

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  //---- Variables

  bool freteFoiBuscado = false;

  int _indexPageCarousel = 0;

  List images = [];

  Map sedex = {"name": "", "price": "", "time_delivery": ""};
  Map pac = {"name": "", "price": "", "time_delivery": ""};

  TextEditingController _cepController = TextEditingController();

  var item;
  var _snack = GlobalKey<ScaffoldState>();

  //---- Functions

  Future calcularFrete(String cepDestino) async {
    var sigep = Sigepweb(contrato: SigepContrato.semContrato());
    var calcPrecoPrazo = await sigep.calcPrecoPrazo(
        cepOrigem: "${item["cep_origem"]}",
        cepDestino: cepDestino,
        valorPeso: item["weight"]);

    for (CalcPrecoPrazoItemModel item in calcPrecoPrazo) {
      if (item.nome == "Sedex") {
        await setSedex(item);
      } else {
        await setPac(item);
      }
    }
  }

  setSedex(CalcPrecoPrazoItemModel item) {
    setState(() {
      sedex["price"] = item.valor.toString();
      sedex["time_delivery"] = item.prazoEntrega.toString();
      freteFoiBuscado = true;
    });
  }

  setPac(CalcPrecoPrazoItemModel item) {
    setState(() {
      pac["price"] = item.valor.toString();
      pac["time_delivery"] = item.prazoEntrega.toString();
      freteFoiBuscado = true;
    });
  }

  getImages() {
    for (int x = 0; x < 20; x++) {
      try {
        images.add(item["image"][x]);
      } catch (e) {
        print(e);
      }
    }
  }

  Future addInUser(text) async {
    bool haveProduct = false;
    bool adicionarProduto = true;

    setState(() {
      dataUser.getDataUser();
    });

    if (await user[text].length >= 1) {
      for (var y = 0; y < user[text].length; y++) {
        if (await user[text][y] == await item["id"]) {
          print("O ${await user[text][y]} é igual a ${await item["id"]}");
          setState(() {
            haveProduct = true;
          });
        }
      }
    } else {
      print("0");
    }
    if (haveProduct == false) {
      if (text == "car_shop") {
        _snack.currentState.showSnackBar(SnackBar(
            content: Text(
                "O produto ${item["title"]} foi adicionado no carrinho",
                style: TextStyle(color: Colors.green)),
            backgroundColor: Colors.white,
            duration: Duration(seconds: 2),
            action: SnackBarAction(
                label: "Desfazer",
                onPressed: () {
                  setState(() {
                    adicionarProduto = false;
                  });
                })));
        await Future.delayed(
            Duration(seconds: 3),
            () async => adicionarProduto == true
                ? await dataUser.setCarShop(item["id"])
                : null);
      } else {
        _snack.currentState.showSnackBar(SnackBar(
            content: Text(
                "O produto ${item["title"]} foi adicionado no favoritos",
                style: TextStyle(color: Colors.green)),
            backgroundColor: Colors.white,
            duration: Duration(seconds: 2),
            action: SnackBarAction(
                label: "Desfazer",
                onPressed: () {
                  setState(() {
                    adicionarProduto = false;
                  });
                })));
        await Future.delayed(
            Duration(seconds: 3),
            () async => adicionarProduto == true
                ? await dataUser.setFavorites(item["id"])
                : null);
      }
    } else {
      if (text == "car_shop") {
        _snack.currentState.showSnackBar(
          SnackBar(
            content: Text(
              "Remover ${item["title"]} de carrinho?",
              style: TextStyle(color: Colors.green),
            ),
            backgroundColor: Colors.white,
            action: SnackBarAction(
                label: "Remover",
                onPressed: () async =>
                    await dataUser.removeCarShop(item["id"])),
          ),
        );
      } else {
        _snack.currentState.showSnackBar(
          SnackBar(
            content: Text(
              "Remover ${item["title"]} de favoritos?",
              style: TextStyle(color: Colors.green),
            ),
            backgroundColor: Colors.white,
            action: SnackBarAction(
                label: "Remover",
                onPressed: () async =>
                    await dataUser.removeFavorites(item["id"])),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    print("-------- Product.dart---------");
    item = widget.item;
    getImages();

    dataUser.setViews(item);
    dataUser.getDataUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                  width: size.width,
                  height: size.height * 0.45,
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
                                  onPressed: () async =>
                                      await addInUser("car_shop")),
                              IconButton(
                                  tooltip: "Compartilhar",
                                  icon: Icon(
                                    Icons.share,
                                    color: Colors.green,
                                  ),
                                  onPressed: () async {
                                    await Share.share(
                                        item["title"] + ". " + item["subtitle"],
                                        subject: "Pesquise por esse produto");
                                  }),
                              IconButton(
                                  tooltip: "Adicionar no favoritos",
                                  icon:
                                      Icon(Icons.favorite, color: Colors.green),
                                  onPressed: () async {
                                    await addInUser("favorites");
                                  }),
                            ],
                          ),
                        ),
                        CarouselSlider.builder(
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: GestureDetector(
                                    onTap: () async => await Navigator.push(
                                        context,
                                        PageTransition(
                                            child: PageHero(
                                              images[index],
                                              item["title"] +
                                                  DateTime.now().toString(),
                                            ),
                                            type: PageTransitionType.size,
                                            alignment: Alignment.topCenter,
                                            duration:
                                                Duration(milliseconds: 400))),
                                    child: Hero(
                                      tag: "${images[index]}",
                                      child: CachedNetworkImage(
                                        imageUrl: images[index],
                                        filterQuality: FilterQuality.high,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover)),
                                        ),
                                        useOldImageOnUrlChange: true,
                                        progressIndicatorBuilder:
                                            (context, child, loadingProgress) {
                                          return loadingProgress == null
                                              ? child
                                              : LinearProgressIndicator(
                                                  value:
                                                      loadingProgress.progress,
                                                );
                                        },
                                      ),
                                    ),
                                  ));
                            },
                            options: CarouselOptions(
                              height: size.height * 0.30,
                              initialPage: _indexPageCarousel,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: false,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _indexPageCarousel = index;
                                });
                              },
                            )),
                        Divider(
                          color: Colors.white,
                          height: 10,
                        ),
                        Container(
                          width: (images.length * 25).ceilToDouble(),
                          height: 10,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Container(
                                      color: _indexPageCarousel == index
                                          ? Colors.green[300]
                                          : Colors.green[100],
                                      width: 20,
                                    ),
                                  ));
                            },
                            itemCount: images.length,
                          ),
                        )
                      ],
                    ),
                  ]),
                ),
              ),
              Text(
                "${item["title"]}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              Text(
                "${item["subtitle"]}",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "${item["describe"]}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      letterSpacing: 0.2,
                      wordSpacing: 0.5,
                      fontStyle: FontStyle.normal,
                      fontFamily: "Noto Sans"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      width: size.width,
                      color: Colors.white,
                      child: TextFormField(
                        controller: _cepController,
                        onChanged: (e) {
                          if (_cepController.text.length == 8) {
                            print("Igual a oito");
                          }
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
                  width: size.width * 0.5,
                  height: 40,
                  child: RaisedButton(
                    onPressed: () async {
                      if (_cepController.text.length == 8) {
                        await calcularFrete(
                          _cepController.text,
                        );
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
                        width: size.width * 0.5,
                        color: Colors.white,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Sedex",
                                  style: TextStyle(color: Colors.green),
                                ),
                                Text(
                                  sedex["time_delivery"] + " dias",
                                  style: TextStyle(color: Colors.green[300]),
                                ),
                                Text(
                                  "R\$" + sedex["price"].toString(),
                                  style: TextStyle(color: Colors.green[200]),
                                )
                              ],
                            ),
                            Divider(color: Colors.green),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Pac",
                                  style: TextStyle(color: Colors.green),
                                ),
                                Text(
                                  pac["time_delivery"] + " dias",
                                  style: TextStyle(color: Colors.green[300]),
                                ),
                                Text(
                                  "R\$" + pac["price"].toString(),
                                  style: TextStyle(color: Colors.green[200]),
                                )
                              ],
                            )
                          ],
                        ),
                      )),
                  crossFadeState: freteFoiBuscado == true
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 400)),
            ],
          ),
        ));
  }
}
