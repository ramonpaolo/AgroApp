//---- Packages
import 'package:flutter/material.dart';
import 'dart:async';

//---- Datas
import 'package:agricultura/src/data/category.dart';

//---- API
import 'package:agricultura/src/firebase/api_firebase.dart';

//---- Screens
import 'package:agricultura/src/routes/home/functions/categorys.dart';
import 'package:agricultura/src/routes/home/widgets/sub_category.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //---- Variables

  bool animated = true;

  List produtoPesquisado = [];

  String pesquisa;

  TextEditingController _pesquisa = TextEditingController();

  //---- Functions

  Future refreshProduts() async {
    setState(() {
      productsOrderMinPrice = productsOrderMinPrice;
      productsOrderName = productsOrderName;
      productsOrderView = productsOrderView;
    });
  }

  Future setProdutoPesquisado({String search, int array}) async {
    setState(() {
      pesquisa = search;
      produtoPesquisado.add(productsOrderView.docs[array]);
    });
  }

  Future search(String search) async {
    //Manter a variavel limpa para novas pesquisas
    setState(() {
      produtoPesquisado.clear();
    });

    for (int x = 0; x < productsOrderView.docs.length; x++) {
      if (productsOrderView.docs[x]["title"].contains(search)) {
        await setProdutoPesquisado(search: search, array: x);
      }
    }
  }

  void clearDataSearch(String value) {
    if (value.isEmpty) {
      setState(() {
        _pesquisa.clear();
        animated = true;
        pesquisa = null;
        produtoPesquisado.clear();
      });
    } else {
      search(_pesquisa.text);
    }
  }

  @override
  void initState() {
    print("---------- Home.dart ---------");
    showAllProducts.showAllProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    centerTitle: true,
                    floating: true,
                    backgroundColor: Colors.green,
                    elevation: 0.0,
                    title: Container(
                      width: 1000,
                      height: 50,
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        controller: _pesquisa,
                        onSubmitted: (value) {
                          clearDataSearch(value);
                        },
                        onChanged: (value) {
                          setState(() {
                            animated = false;
                          });
                          value = _pesquisa.text;
                          clearDataSearch(value);
                        },
                        showCursor: true,
                        strutStyle: StrutStyle(leading: 0.4),
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.green[900],
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.green,
                          ),
                          suffixIcon: _pesquisa.text.length >= 1
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    clearDataSearch("");
                                  })
                              : null,
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40)),
                    ),
                  ),
                  pesquisa == null
                      ? categorys(category, size)
                      : itemFounds(produtoPesquisado, size),
                  sliverList(
                      productsOrderView.docs, size, "Os principais de outubro"),
                  sliverList(
                      productsOrderName.docs, size, "Ordenado pelo Nome"),
                  sliverList(
                      productsOrderMinPrice.docs, size, "Os menores preços"),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.green[100],
                ),
              );
            }
          },
          future: showAllProducts.showAllProducts(),
        ),
      ),
      onRefresh: refreshProduts,
      color: Colors.green,
    );
  }
}
