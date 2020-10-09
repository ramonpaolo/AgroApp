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

  Map category = {"name": ""};

  List produtosDaCategoriaEscolhida = [];

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
                  indent: size.width * 0.3,
                ),
                Text(
                  category["name"],
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                              height: size.height * 0.32,
                              child: Card(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 130,
                                        child: Image.file(
                                          File(produtosDaCategoriaEscolhida[
                                              index]["image"][0]),
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
                                          "R\$25,00",
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
                              height: size.height * 0.32,
                              child: Card(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        child: Image.file(
                                          File(produtosDaCategoriaEscolhida[
                                              index]["image"][0]),
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
                                          "R\$25,00",
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
            )
          ],
        ),
      ),
    );
  }
}
