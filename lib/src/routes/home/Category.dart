//---- Packages
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:io';

//---- Screens
import 'package:agricultura/src/routes/home/Product.dart';

//---- Datas
import 'package:agricultura/src/data/home.dart';

class Category extends StatefulWidget {
  Category({Key key, this.category}) : super(key: key);
  final Map category;
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  //---- Variables

  List produtosDaCategoriaEscolhida = [];

  Map category = {"name": ""};

  //---- Functions

  buscarProdutosNaCategoria() async {
    for (var x = 0; x < produtos.length; x++) {
      if (produtos[x]["category"] == category["name"]) {
        setState(() {
          produtosDaCategoriaEscolhida.add(produtos[x]);
        });
      }
    }
  }

  @override
  void initState() {
    print("----------Category.dart-----------");
    category["name"] = widget.category["name"];
    buscarProdutosNaCategoria();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
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
                category["name"],
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ],
          ),
          Container(
            width: 200,
            height: 1000,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                        width: 1000,
                        height: size.height <= 700
                            ? size.height * 0.32
                            : size.height * 0.25,
                        child: Card(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Container(
                                  height: size.height <= 700
                                      ? size.height * 0.2
                                      : size.height * 0.15,
                                  child: Image.file(
                                    File(produtosDaCategoriaEscolhida[index]
                                        ["image"][0]),
                                    fit: BoxFit.fill,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                      produtosDaCategoriaEscolhida[index]
                                          ["title"]),
                                  subtitle: Text(
                                      produtosDaCategoriaEscolhida[index]
                                          ["subtitle"]),
                                  trailing: Text(
                                    "R\$" +
                                        produtosDaCategoriaEscolhida[index]
                                            ["price"],
                                    style: TextStyle(color: Colors.green),
                                  ),
                                )
                              ],
                            ))),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      PageTransition(
                          child: Product(
                            item: produtosDaCategoriaEscolhida[index],
                          ),
                          type: PageTransitionType.rightToLeft)),
                );
              },
              itemCount: produtosDaCategoriaEscolhida.length,
            ),
          ),
        ],
      )),
    );
  }
}
