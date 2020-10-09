// ---- Variables
import 'dart:io';
import 'package:agricultura/src/routes/home/Product.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

//---- Datas
import 'package:agricultura/src/data/home.dart';

class Products extends StatefulWidget {
  Products({Key key, this.category}) : super(key: key);
  final List category;
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
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
            Divider(
              height: 30,
              color: Colors.green,
            ),
            Container(
              width: size.width,
              height: size.height * 0.25,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          PageTransition(
                              child: Product(
                                item: widget.category[index],
                              ),
                              type: PageTransitionType.scale)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: size.width * 0.548,
                            child: Card(
                              child: Stack(
                                alignment: Alignment.bottomLeft,
                                children: [
                                  Image.file(
                                    File(widget.category[index]["image"][0]),
                                    fit: BoxFit.fill,
                                    filterQuality: FilterQuality.high,
                                  ),
                                  ListTile(
                                    title: Text(
                                      widget.category[index]["title"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                        widget.category[index]["subtitle"],
                                        style: TextStyle(color: Colors.white)),
                                    trailing: Text(
                                        "R\$" + widget.category[index]["price"],
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ),
                          )));
                },
                itemCount: widget.category.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
