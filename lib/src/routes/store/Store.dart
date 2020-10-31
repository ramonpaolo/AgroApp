//---- Packages
import 'package:agricultura/src/routes/home/Product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agricultura/src/firebase/api_firebase.dart';

//----Screens
import 'package:agricultura/src/routes/store/showModal.dart';
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

  double height = 76.0;

  List produtosNoCarrinho = [];
  List produtoPesquisado;

  TextEditingController _searchController = TextEditingController();

  var key = GlobalKey<ScaffoldState>();

  //---- Functions

  Future quantidadeProdutosNoCarrinho() async {
    setState(() {
      produtosNoCarrinho.clear();
    });

    DocumentSnapshot user;

    user = await dataUser.getDataUser();

    print("car_shop: ${await user['car_shop']}");

    for (var x = 0; x < productsOrderView.docs.length; x++) {
      for (var y = 0; y < await user['car_shop'].length; y++) {
        if (await user['car_shop'][y] ==
            await productsOrderView.docs[x]["id"]) {
          produtosNoCarrinho.add(productsOrderView.docs[x]);
        }
      }
    }
    return produtosNoCarrinho;
  }

  Future search(search) async {
    for (var x = 0; x < productsOrderMinPrice.docs.length; x++) {
      if (search == await productsOrderMinPrice.docs[x]["title"]) {
        print("'Chat.dart': Esse mesmo: $search");
        setState(() {
          produtoPesquisado.add(productsOrderMinPrice.docs[x].data());
          pesquisa = true;
        });
        return produtoPesquisado;
      } else if (x == productsOrderMinPrice.docs.length - 1) {
        print("Não tem : (");
        return search;
      }
    }
  }

  @override
  void initState() {
    print("---------------------- Store.dart-------------");
    user = widget.user;
    setState(() {
      produtosNoCarrinho.clear();
    });
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
                  padding: EdgeInsets.only(top: 30, left: 20, right: 20),
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
                        top: 20, bottom: 30, left: 30, right: 30),
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
                    return ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60)),
                        child: Container(
                            color: Colors.white,
                            width: 1000,
                            height: size.height <= 700
                                ? size.height * 0.66 + height
                                : size.height * 0.725 + height,
                            child: Column(children: [
                              Container(
                                width: 1000,
                                height: size.height <= 700
                                    ? size.height * 0.55 + height
                                    : size.height * 0.64 + height,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 40),
                                  child: pesquisa == true
                                      ? ListView.builder(
                                          itemBuilder: (context, index) {
                                            return Dismissible(
                                                onDismissed: (direction) {
                                                  setState(() {
                                                    produtosNoCarrinho.remove(
                                                        produtoPesquisado[
                                                            index]);
                                                  });
                                                  key.currentState
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                      "Excluido o produto: ${produtoPesquisado[index]["title"]}",
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
                                                child: CheckboxListTile(
                                                    subtitle: IconButton(
                                                        icon: Icon(
                                                            Icons.favorite,
                                                            color: produtoPesquisado[
                                                                        index]
                                                                    ["favorite"]
                                                                ? Colors.green
                                                                : Colors.black),
                                                        onPressed: () {
                                                          setState(() {
                                                            produtoPesquisado[
                                                                        index][
                                                                    "favorite"] =
                                                                !produtoPesquisado[
                                                                        index][
                                                                    "favorite"];
                                                          });
                                                        }),
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    title: Text(
                                                        produtoPesquisado[index]
                                                            ["title"]),
                                                    /*
                                                  secondary: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.file(
                                                          File(produtoPesquisado[index]["image"]))),*/
                                                    key: Key(DateTime.now()
                                                        .toString()),
                                                    value:
                                                        produtoPesquisado[index]
                                                            ["checbox"],
                                                    checkColor: Colors.white,
                                                    activeColor: Colors.green,
                                                    onChanged: (v) {
                                                      setState(() {
                                                        produtoPesquisado[index]
                                                            ["checbox"] = v;
                                                      });
                                                    }));
                                          },
                                          itemCount: produtoPesquisado.length,
                                        )
                                      : ListView.builder(
                                          itemCount: produtosNoCarrinho.length,
                                          itemBuilder: (context, index) {
                                            return Dismissible(
                                                onDismissed: (direction) {
                                                  setState(() {
                                                    //Adicionar ainda o remover o ID do produto no usuário
                                                  });
                                                  key.currentState
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                      "Excluido o produto: ${produtosNoCarrinho[index]["title"]}",
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
                                                        produtosNoCarrinho[
                                                            index]["title"]),
                                                    subtitle: Text(
                                                        produtosNoCarrinho[
                                                            index]["subtitle"]),
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
                                                            produtosNoCarrinho[
                                                                    index]
                                                                ["image"][0],
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
                                        onPressed: () {
                                          showModal(context);
                                        },
                                        color: Colors.green,
                                        child: Text(
                                          "Finalizar Compra",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ))),
                            ])));
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                },
                future: quantidadeProdutosNoCarrinho(),
              ),
            ],
          ),
        ));
  }
}
