//---- Packages
import 'dart:io';
import 'package:flutter/material.dart';

//----Screens
import 'package:agricultura/src/routes/store/showModal.dart';

//---- Datas
import 'package:agricultura/src/data/home.dart';

class Store extends StatefulWidget {
  Store({Key key, this.user}) : super(key: key);
  final user;
  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  //---- Variables

  bool animated = true;
  bool pesquisa = false;

  double height = 76.0;

  Map planta;
  Map user;

  List produtosNoCarrinho = [];

  TextEditingController _searchController = TextEditingController();

  var key = GlobalKey<ScaffoldState>();

  //---- Functions

  quantidadeProdutosNoCarrinho() {
    List car_shop = user["car_shop"];
    for (var x = 0; x < car_shop.length; x++) {
      for (var y = 0; y < produtos.length; y++) {
        if (produtos[y]["id"] == car_shop[x]) {
          print(produtos[y]);
          setState(() {
            produtosNoCarrinho.add(produtos[y]);
          });
        } else {
          print("Não é igual");
        }
      }
    }
  }

  Future search(search) async {
    for (var x = 0; x < produtos.length; x++) {
      if (search == produtos[x]["title"]) {
        print("'Chat.dart': Esse mesmo: $search");
        setState(() {
          planta = produtos[x];
          pesquisa = true;
        });
        return planta;
      } else if (x == produtos.length) {
        print("Não tem : (");
        return search;
      }
    }
  }

  @override
  void initState() {
    print("---------------------- Store.dart-------------");
    user = widget.user;
    print("Data user: " + user.toString());
    quantidadeProdutosNoCarrinho();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.green,
        key: key,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 40, left: 20, right: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Colors.green,
                              ),
                              tooltip: "Search",
                              onPressed: () {
                                setState(() {
                                  animated = !animated;
                                });
                                if (animated == true) {
                                  setState(() {
                                    height = 70;
                                  });
                                } else {
                                  setState(() {
                                    height = 0;
                                  });
                                }
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: Colors.green,
                              ),
                              tooltip: "Favorite",
                              onPressed: () {
                                produtosNoCarrinho.forEach((element) {
                                  if (element["checbox"] == true) {
                                    setState(() {
                                      element["favorite"] =
                                          !element["favorite"];
                                    });
                                  }
                                });
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Colors.green,
                              ),
                              tooltip: "Clear",
                              onPressed: () {
                                produtosNoCarrinho.removeWhere(
                                    (element) => element["checbox"] == true);
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.select_all,
                                color: Colors.green,
                              ),
                              tooltip: "Select all",
                              onPressed: () {
                                produtosNoCarrinho.forEach((element) {
                                  if (element["checbox"] == false) {
                                    setState(() {
                                      element["checbox"] = true;
                                    });
                                  } else {
                                    setState(() {
                                      element["checbox"] = false;
                                    });
                                  }
                                });
                              }),
                        ],
                      ),
                    ),
                  )),
              AnimatedCrossFade(
                  firstChild: Text(""),
                  secondChild: Padding(
                    padding: EdgeInsets.only(
                        top: 20, bottom: 20, left: 30, right: 30),
                    child: ClipRRect(
                      child: Container(
                        color: Colors.white,
                        child: TextField(
                          cursorColor: Colors.green[900],
                          controller: _searchController,
                          onChanged: (value) {
                            search(value);
                          },
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Pesquise aqui...",
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.green,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    pesquisa = false;
                                  });
                                },
                              )),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  crossFadeState: animated
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: Duration(milliseconds: 500)),
              ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60)),
                  child: Container(
                    color: Colors.white,
                    width: 1000,
                    height: size.height <= 700
                        ? size.height * 0.65 + height
                        : size.height * 0.714 + height,
                    child: Column(children: [
                      Container(
                        width: 1000,
                        height: size.height <= 700
                            ? size.height * 0.55 + height
                            : size.height * 0.64 + height,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 40),
                          child: pesquisa == true
                              ? Dismissible(
                                  onDismissed: (direction) {
                                    setState(() {
                                      produtosNoCarrinho.remove(planta["id"]);
                                    });

                                    key.currentState.showSnackBar(SnackBar(
                                      content: Text(
                                        "Excluido o produto: ${planta["title"]}",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      duration: Duration(seconds: 3),
                                      backgroundColor: Colors.white,
                                    ));
                                  },
                                  background: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                        color: Colors.red,
                                        child: Align(
                                          alignment: Alignment(-0.5, 0),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        )),
                                  ),
                                  direction: DismissDirection.startToEnd,
                                  key: Key(DateTime.now().toString()),
                                  child: CheckboxListTile(
                                      subtitle: IconButton(
                                          icon: Icon(Icons.favorite,
                                              color: planta["favorite"]
                                                  ? Colors.green
                                                  : Colors.black),
                                          onPressed: () {
                                            setState(() {
                                              planta["favorite"] =
                                                  !planta["favorite"];
                                            });
                                          }),
                                      contentPadding: EdgeInsets.all(10),
                                      title: Text(planta["title"]),
                                      secondary: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.file(
                                              File(planta["image"]))),
                                      key: Key(DateTime.now().toString()),
                                      value: planta["checbox"],
                                      checkColor: Colors.white,
                                      activeColor: Colors.green,
                                      onChanged: (v) {
                                        setState(() {
                                          planta["checbox"] = v;
                                        });
                                      }))
                              : ListView.builder(
                                  itemCount: produtosNoCarrinho.length,
                                  itemBuilder: (context, index) {
                                    return Dismissible(
                                        onDismissed: (direction) {
                                          setState(() {
                                            produtos.remove(
                                                produtosNoCarrinho[index]
                                                    ["id"]);
                                          });
                                          key.currentState
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                              "Excluido o produto: ${produtosNoCarrinho[index]["title"]}",
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                            duration: Duration(seconds: 3),
                                            backgroundColor: Colors.white,
                                          ));
                                        },
                                        background: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Container(
                                              color: Colors.red,
                                              child: Align(
                                                alignment: Alignment(-0.5, 0),
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                ),
                                              )),
                                        ),
                                        direction: DismissDirection.startToEnd,
                                        key: Key(DateTime.now().toString()),
                                        child: ListTile(
                                          subtitle: Text(
                                              produtosNoCarrinho[index]
                                                  ["subtitle"]),
                                          contentPadding: EdgeInsets.all(10),
                                          title: Text(produtosNoCarrinho[index]
                                              ["title"]),
                                          leading: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.file(File(
                                                  produtosNoCarrinho[index]
                                                      ["image"][0]))),
                                          key: Key(DateTime.now().toString()),
                                        ));
                                  }),
                        ),
                      ),
                      SizedBox(
                          width: 400,
                          height: 50,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: RaisedButton(
                                splashColor: Colors.white,
                                onPressed: () {
                                  showModal(context);
                                },
                                color: Colors.green,
                                child: Text(
                                  "Finalizar Compra",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ))),
                    ]),
                  )),
            ],
          ),
        ));
  }
}
