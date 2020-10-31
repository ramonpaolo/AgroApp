// ---- Packages
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

//---- Screens
import 'package:agricultura/src/routes/home/Product.dart';

class Products extends StatefulWidget {
  Products({Key key, this.produtsOfCategory}) : super(key: key);
  final List produtsOfCategory;

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  Object order;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: size.width * 0.8, top: 30),
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 36,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            produtos(size),
          ],
        ),
      ),
    );
  }

  Widget produtos(Size size) {
    return Container(
      width: size.width,
      height: size.height * 0.34,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  PageTransition(
                      child: Product(
                        item: widget.produtsOfCategory[index],
                      ),
                      type: PageTransitionType.scale)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: size.width * 0.548,
                    child: Card(
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: widget.produtsOfCategory[index]["image"]
                                [0],
                            filterQuality: FilterQuality.high,
                            height: size.height * 0.2,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover)),
                            ),
                            progressIndicatorBuilder:
                                (context, child, loadingProgress) {
                              return loadingProgress == null
                                  ? child
                                  : LinearProgressIndicator();
                            },
                          ),
                          ListTile(
                            title: Text(
                              "${widget.produtsOfCategory[index]["title"]}",
                            ),
                            subtitle: Text(
                              "${widget.produtsOfCategory[index]["subtitle"]}",
                            ),
                            trailing: Text(
                                "R\$${widget.produtsOfCategory[index]["price"]}",
                                style: TextStyle(color: Colors.green)),
                          ),
                        ],
                      ),
                    ),
                  )));
        },
        itemCount: widget.produtsOfCategory.length,
      ),
    );
  }
}
