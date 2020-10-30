//---- Packages
import 'package:agricultura/src/routes/home/widgets/dragable_scrollable.dart';
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

  Object order;

  List produtosDaCategoriaEscolhida = [];

  Map category = {"name": ""};

  //---- Functions

  buscarProdutosNaCategoria() async {
    for (var x = 0; x < productsOrderView.docs.length; x++) {
      if (await productsOrderView.docs[x]["category"] == category["name"]) {
        setState(() {
          produtosDaCategoriaEscolhida.add(productsOrderView.docs[x]);
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
                                        "${produtosDaCategoriaEscolhida[index]["image"][0]}",
                                    filterQuality: FilterQuality.medium,
                                    useOldImageOnUrlChange: true,
                                    width: 200,
                                    height: 140,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder:
                                        (context, url, progress) =>
                                            LinearProgressIndicator(
                                                value: progress.progress),
                                  ),
                                  ListTile(
                                    title: Text(
                                        "${produtosDaCategoriaEscolhida[index]["title"]}"),
                                    subtitle: Text(
                                        "${produtosDaCategoriaEscolhida[index]["subtitle"]}"),
                                    trailing: Text(
                                      "R\$${produtosDaCategoriaEscolhida[index]["price"]}",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  )
                                ],
                              )),
                          onTap: () => Navigator.push(
                              context,
                              PageTransition(
                                  child: Product(
                                    item: produtosDaCategoriaEscolhida[index],
                                  ),
                                  type: PageTransitionType.rightToLeft)),
                        )));
              },
              itemCount: produtosDaCategoriaEscolhida.length,
            ),
          ),
          DraggableScrollable()
        ],
      )),
    );
  }
}
