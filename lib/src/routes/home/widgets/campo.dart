//---- Packages
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:io';

//---- Datas
import 'package:agricultura/src/routes/home/Product.dart';
import 'package:agricultura/src/routes/home/Products.dart';

Widget construtor(
    Size size, List item, String title, BuildContext context, setState) {
  return Column(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          color: Colors.white,
          height: size.height * 0.07,
          width: size.width * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: Colors.green, fontSize: 16)),
              ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    height: size.height * 0.04,
                    child: RaisedButton(
                      color: Colors.green[200],
                      onPressed: () => Navigator.push(
                          context,
                          PageTransition(
                              child: Products(
                                category: item,
                              ),
                              type: PageTransitionType.rightToLeft)),
                      child: Text("Veja tudo",
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                  ))
            ],
          ),
        ),
      ),
      Divider(
        height: 10,
        color: Colors.green,
      ),
      Container(
          width: 1000,
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: item.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      PageTransition(
                          child: Product(
                            item: item[index],
                          ),
                          type: PageTransitionType.bottomToTop)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                        width: size.width * 0.5,
                        child: Card(
                          child: Column(
                            children: [
                              Stack(
                                textDirection: TextDirection.rtl,
                                children: [
                                  Image.file(
                                    File(item[index]["image"][0]),
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.fill,
                                    height: size.height * 0.2,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 100),
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.favorite_border,
                                          color: item[index]["favorite"]
                                              ? Colors.green
                                              : Colors.black,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            item[index]["favorite"] =
                                                !item[index]["favorite"];
                                          });
                                        }),
                                  )
                                ],
                              ),
                              ListTile(
                                title: Text(item[index]["title"]),
                                subtitle: Text(item[index]["subtitle"]),
                                trailing: Text(
                                  "R\$" + item[index]["price"].toString(),
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )));
            },
          ))
    ],
  );
}
