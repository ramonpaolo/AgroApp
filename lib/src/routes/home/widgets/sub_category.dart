//---- Packages
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

//---- Screens
import 'package:agricultura/src/routes/home/Product.dart';
import 'package:agricultura/src/routes/home/Products.dart';

Widget sliverList(List item, Size size, String title) {
  return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
    return Column(
      children: [
        Divider(
          height: 20,
          color: Colors.green,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            color: Colors.white,
            width: size.width * 0.9,
            height: size.height * 0.06,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: TextStyle(color: Colors.green, fontSize: 16)),
                ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      height: size.height * 0.036,
                      child: RaisedButton(
                        color: Colors.green[200],
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: Products(
                                    produtsOfCategory: item,
                                  ),
                                  type: PageTransitionType.rightToLeft));
                        },
                        child: Text("Veja tudo",
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                      ),
                    ))
              ],
            ),
          ),
        ),
        Divider(
          height: 8,
          color: Colors.green,
        ),
        Container(
            width: size.width,
            height: 230,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: item.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        PageTransition(
                            child: Product(item: item[index]),
                            type: PageTransitionType.bottomToTop)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          width: 205,
                          child: Card(
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: "${item[index]["image"][0]}",
                                  filterQuality: FilterQuality.low,
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
                                  title: Text("${item[index]["title"]}",
                                      style: TextStyle(fontSize: 14)),
                                  subtitle: Text("${item[index]["subtitle"]}",
                                      style: TextStyle(fontSize: 12)),
                                  trailing: Text(
                                    "R\$${item[index]["price"]}",
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 14),
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
  }, childCount: 1));
}
