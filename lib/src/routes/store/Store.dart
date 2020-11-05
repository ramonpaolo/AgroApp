//---- Packages
import 'package:agricultura/src/routes/home/Product.dart';
import 'package:agricultura/src/routes/store/functions/buy_products.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agricultura/src/firebase/api_firebase.dart';

//----Screens
import 'package:agricultura/src/routes/store/widgets/showModal.dart';
import 'package:page_transition/page_transition.dart';

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

  double height = 0.0;

  List produtosNoCarrinho = [];
  List produtoPesquisado = [];

  TextEditingController _searchController = TextEditingController();

  var _snack = GlobalKey<ScaffoldState>();

  //---- Functions

  Future quantidadeProdutosNoCarrinho() async {
    DocumentSnapshot user;
    produtosNoCarrinho.clear();

    user = await dataUser.getDataUser();

    for (var x = 0; x < productsOrderView.docs.length; x++) {
      for (var y = 0; y < await user['car_shop'].length; y++) {
        if (await user['car_shop'][y] ==
            await productsOrderView.docs[x]["id"]) {
          produtosNoCarrinho.add(productsOrderView.docs[x].data());
        }
      }
    }
    if (produtosNoCarrinho.length > user["car_shop"].length) {
      for (var x = 0; x < produtosNoCarrinho.length; x++) {
        if (user["car_shop"].length > x) {
          produtosNoCarrinho.removeAt(produtosNoCarrinho.length - 1);
        }
      }
    }
    return produtosNoCarrinho;
  }

  Future search(String search) async {
    //---- Manter a váriavel limpa para novas pesquisas
    produtoPesquisado.clear();

    for (var x = 0; x < produtosNoCarrinho.length; x++) {
      if (await produtosNoCarrinho[x]["title"].contains(search)) {
        print("'Chat.dart': Igual a: $search");
        produtoPesquisado.add(produtosNoCarrinho[x]);
        setState(() {
          pesquisa = true;
        });
      }
    }
    return produtoPesquisado;
  }

  setSizeScreen(Size size) {
    setState(() {
      if (animated == true) {
        height = size.height * 0.37;
      } else {
        height = size.height * 0.28;
      }
    });
  }

  @override
  void initState() {
    print("---------------------- Store.dart-------------");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    setSizeScreen(size);
    return Scaffold(
        backgroundColor: Colors.green,
        key: _snack,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      top: size.height * 0.035,
                      left: size.width * 0.05,
                      right: size.width * 0.05),
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
                                setSizeScreen(size);
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: Colors.green,
                              ),
                              tooltip: "Favorite",
                              onPressed: () {
                                produtosNoCarrinho.forEach((element) {
                                  print(element);
                                });
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Colors.green,
                              ),
                              tooltip: "Clear",
                              onPressed: () {
                                produtosNoCarrinho.removeWhere((element) {
                                  print(element);
                                });
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.select_all,
                                color: Colors.green,
                              ),
                              tooltip: "Select all",
                              onPressed: () {
                                produtosNoCarrinho.forEach((element) {
                                  print(element);
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
                        top: size.height * 0.024,
                        bottom: size.height * 0.032,
                        left: size.width * 0.08,
                        right: size.width * 0.08),
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
              FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return RefreshIndicator(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60)),
                        child: Container(
                            color: Colors.white,
                            width: size.width,
                            height: size.height <= 700
                                ? size.height * 0.66 + height
                                : size.height <= 800
                                    ? size.height * 0.725 + height
                                    : size.height * 0.44 + height,
                            child: Column(children: [
                              Container(
                                width: size.width,
                                height: size.height <= 700
                                    ? size.height * 0.55 + height
                                    : size.height <= 800
                                        ? size.height * 0.64 + height
                                        : size.height * 0.37 + height,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: size.width * 0.05,
                                      right: size.width * 0.05),
                                  child: pesquisa == true
                                      ? ListView.builder(
                                          itemBuilder: (context, index) {
                                            return Dismissible(
                                              onDismissed: (direction) {
                                                _snack.currentState
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                    "Excluido o produto: ${produtoPesquisado[index]["title"]}",
                                                  ),
                                                  duration:
                                                      Duration(seconds: 3),
                                                  backgroundColor: Colors.white,
                                                ));
                                              },
                                              background: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Container(
                                                    color: Colors.red,
                                                    child: Align(
                                                      alignment:
                                                          Alignment(-0.5, 0),
                                                      child: Icon(
                                                        Icons.delete,
                                                        color: Colors.white,
                                                      ),
                                                    )),
                                              ),
                                              direction:
                                                  DismissDirection.startToEnd,
                                              key: Key(
                                                  DateTime.now().toString()),
                                              child: ListTile(
                                                title: Text(
                                                    "${produtoPesquisado[index]["title"]}"),
                                                subtitle: Text(
                                                    "${produtoPesquisado[index]["subtitle"]}"),
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                                trailing: Text(
                                                  "R\$${produtoPesquisado[index]["price"]}",
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                ),
                                                leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "${produtoPesquisado[index]["image"][0]}",
                                                    filterQuality:
                                                        FilterQuality.high,
                                                    useOldImageOnUrlChange:
                                                        true,
                                                    width: size.width * 0.1,
                                                    fit: BoxFit.cover,
                                                    progressIndicatorBuilder:
                                                        (context, child,
                                                            loadingProgress) {
                                                      return loadingProgress ==
                                                              null
                                                          ? child
                                                          : LinearProgressIndicator();
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: produtoPesquisado.length,
                                        )
                                      : ListView.builder(
                                          itemCount: produtosNoCarrinho.length,
                                          itemBuilder: (context, index) {
                                            return Dismissible(
                                                onDismissed: (direction) async {
                                                  DatasUser().removeCarShop(
                                                      await produtosNoCarrinho[
                                                          index]["id"]);
                                                  _snack.currentState
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                      "Removido de carrinho o produto: ${produtosNoCarrinho[index]["title"]}",
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    ),
                                                    duration:
                                                        Duration(seconds: 3),
                                                    backgroundColor:
                                                        Colors.white,
                                                  ));
                                                },
                                                background: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Container(
                                                      color: Colors.red,
                                                      child: Align(
                                                        alignment:
                                                            Alignment(-0.5, 0),
                                                        child: Icon(
                                                          Icons.delete,
                                                          color: Colors.white,
                                                        ),
                                                      )),
                                                ),
                                                direction:
                                                    DismissDirection.startToEnd,
                                                key: Key(
                                                    DateTime.now().toString()),
                                                child: GestureDetector(
                                                  onTap: () async =>
                                                      await Navigator.push(
                                                          context,
                                                          PageTransition(
                                                              child: Product(
                                                                item:
                                                                    produtosNoCarrinho[
                                                                        index],
                                                              ),
                                                              type: PageTransitionType
                                                                  .bottomToTop)),
                                                  child: ListTile(
                                                    title: Text(
                                                        "${produtosNoCarrinho[index]["title"]}"),
                                                    subtitle: Text(
                                                        "${produtosNoCarrinho[index]["subtitle"]}"),
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    trailing: Text(
                                                      "R\$${produtosNoCarrinho[index]["price"]}",
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    ),
                                                    leading: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "${produtosNoCarrinho[index]["image"][0]}",
                                                        filterQuality:
                                                            FilterQuality.high,
                                                        useOldImageOnUrlChange:
                                                            true,
                                                        width: size.width * 0.1,
                                                        fit: BoxFit.cover,
                                                        progressIndicatorBuilder:
                                                            (context, child,
                                                                loadingProgress) {
                                                          return loadingProgress ==
                                                                  null
                                                              ? child
                                                              : LinearProgressIndicator();
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  key: Key(DateTime.now()
                                                      .toString()),
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
                                        onPressed: () async {
                                          await showModal(
                                            context: context,
                                            products: produtosNoCarrinho,
                                          );
                                        },
                                        color: Colors.green,
                                        child: Text(
                                          "Finalizar Compra",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      )))
                            ])),
                      ),
                      onRefresh: () async =>
                          await quantidadeProdutosNoCarrinho(),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      backgroundColor: Colors.green[100],
                    ));
                  }
                },
                future: quantidadeProdutosNoCarrinho(),
              ),
            ],
          ),
        ));
  }
}
