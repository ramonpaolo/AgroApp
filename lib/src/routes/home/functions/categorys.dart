//---- Packages
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

//---- Screens
import 'package:agricultura/src/routes/home/Product.dart';
import 'package:agricultura/src/routes/home/Category.dart';

Widget categorys(List category, Size size) {
  return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
    return Container(
      width: size.width,
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
              padding: EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    PageTransition(
                        child: Category(
                          category: category[index],
                        ),
                        type: PageTransitionType.bottomToTop)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                      width: 120,
                      color: Colors.white,
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Image.asset(
                            category[index]["image"],
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                            height: size.height,
                            width: size.width,
                          ),
                          Padding(
                              padding: EdgeInsets.only(bottom: 10, left: 10),
                              child: Text(
                                category[index]["name"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Noto sans",
                                    fontSize: 16),
                              ))
                        ],
                      )),
                ),
              ));
        },
        itemCount: category.length,
      ),
    );
  }, childCount: 1));
}

Widget itemFounds(List produtoPesquisado, Size size) {
  return SliverList(
    delegate: SliverChildBuilderDelegate((context, index) {
      return Container(
          width: 1000,
          height: size.height * 0.8,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      PageTransition(
                          child: Product(
                            item: produtoPesquisado[index],
                          ),
                          type: PageTransitionType.bottomToTop)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                        width: size.width * 0.5,
                        child: Card(
                          child: ListTile(
                            title: Text(produtoPesquisado[index]["title"]),
                            subtitle:
                                Text(produtoPesquisado[index]["subtitle"]),
                            trailing: Text(
                              "R\$${produtoPesquisado[index]["price"]}",
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ),
                      )));
            },
            itemCount: produtoPesquisado.length,
          ));
    }, childCount: 1),
  );
}
