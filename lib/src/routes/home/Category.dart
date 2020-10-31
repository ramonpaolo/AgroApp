//---- Packages
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

//---- API
import 'package:agricultura/src/firebase/api_firebase.dart';

//---- Screens
import 'package:agricultura/src/routes/home/Product.dart';

class Category extends StatefulWidget {
  Category({Key key, this.category}) : super(key: key);
  final Map category;

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  //---- Variables

  GetProductsCategory getProductsCategory = GetProductsCategory();

  Map category = {"name": ""};

  List _produtosCategoria = [];

  //---- Functions

  Future setProducts() async {
    await getProductsCategory.getProducts(category["name"], order);
    _produtosCategoria = getProductsCategory.produtosCategoriaEscolhida;
    return _produtosCategoria;
  }

  @override
  void initState() {
    print("----------Category.dart-----------");
    category["name"] = widget.category["name"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.green,
        body: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: Colors.green,
                    height: 40,
                  ),
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 34,
                          ),
                          onPressed: () => Navigator.pop(context)),
                      Divider(
                        indent: size.width * 0.25,
                      ),
                      Text(
                        "${category["name"]}",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ],
                  ),
                  Container(
                    width: size.width,
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                                width: 200,
                                child: GestureDetector(
                                  child: Card(
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl:
                                                "${_produtosCategoria[index]["image"][0]}",
                                            filterQuality: FilterQuality.medium,
                                            useOldImageOnUrlChange: true,
                                            width: 200,
                                            height: 140,
                                            fit: BoxFit.cover,
                                            progressIndicatorBuilder: (context,
                                                    url, progress) =>
                                                LinearProgressIndicator(
                                                    value: progress.progress),
                                          ),
                                          ListTile(
                                            title: Text(
                                                "${_produtosCategoria[index]["title"]}"),
                                            subtitle: Text(
                                                "${_produtosCategoria[index]["subtitle"]}"),
                                            trailing: Text(
                                              "R\$${_produtosCategoria[index]["price"]}",
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                          )
                                        ],
                                      )),
                                  onTap: () => Navigator.push(
                                      context,
                                      PageTransition(
                                          child: Product(
                                            item: _produtosCategoria[index],
                                          ),
                                          type:
                                              PageTransitionType.rightToLeft)),
                                )));
                      },
                      itemCount: _produtosCategoria.length,
                    ),
                  ),
                  Container(
                    width: size.width,
                    height: size.height <= 700
                        ? size.height * 0.55
                        : size.height * 0.64,
                    child: DraggableScrollableSheet(
                      expand: false,
                      minChildSize: size.height <= 700 ? 0.15 : 0.1,
                      maxChildSize: size.height <= 700 ? 0.45 : 0.4,
                      initialChildSize: size.height <= 700 ? 0.15 : 0.1,
                      builder: (context, scrollController) {
                        return AnimatedBuilder(
                            animation: scrollController,
                            builder: (context, child) {
                              return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(40),
                                          topRight: Radius.circular(40))),
                                  child: SingleChildScrollView(
                                      controller: scrollController,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 5),
                                            width: 24,
                                            height: 8,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                color: Colors.green),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 20, top: 10),
                                              child: Column(
                                                children: [
                                                  Text("Selecionar Ordem"),
                                                  ListTile(
                                                      title: Text(
                                                          "Ordenar por nome"),
                                                      trailing: Radio(
                                                          value: "nome",
                                                          groupValue: order,
                                                          activeColor:
                                                              Colors.green,
                                                          onChanged:
                                                              (value) async {
                                                            print(value);
                                                            setState(() {
                                                              _produtosCategoria
                                                                  .clear();
                                                              order = value;
                                                            });
                                                            await GetProductsCategory()
                                                                .getProducts(
                                                                    category[
                                                                        "name"],
                                                                    order);
                                                            await setProducts();
                                                          })),
                                                  ListTile(
                                                      title: Text(
                                                          "Ordenar por preço"),
                                                      trailing: Radio(
                                                          value: "preco",
                                                          groupValue: order,
                                                          activeColor:
                                                              Colors.green,
                                                          onChanged:
                                                              (value) async {
                                                            print(value);
                                                            setState(() {
                                                              _produtosCategoria
                                                                  .clear();
                                                              order = value;
                                                            });
                                                            await GetProductsCategory()
                                                                .getProducts(
                                                                    category[
                                                                        "name"],
                                                                    order);
                                                            await setProducts();
                                                          })),
                                                  ListTile(
                                                      title: Text("Nenhum"),
                                                      trailing: Radio(
                                                          value: "none",
                                                          groupValue: order,
                                                          activeColor:
                                                              Colors.green,
                                                          onChanged:
                                                              (value) async {
                                                            print(value);
                                                            setState(() {
                                                              _produtosCategoria
                                                                  .clear();
                                                              order = value;
                                                            });
                                                            await GetProductsCategory()
                                                                .getProducts(
                                                                    category[
                                                                        "name"],
                                                                    order);
                                                            await setProducts();
                                                          })),
                                                ],
                                              ))
                                        ],
                                      )));
                            });
                      },
                    ),
                  )
                ],
              ));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          future: setProducts(),
        ));
  }
}
