//---- Packages
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

//---- Functions
import 'package:agricultura/src/routes/user/functions/show_modal.dart';

//---- Screens
import 'package:agricultura/src/routes/user/EditProdut.dart';

Widget construtor(List item, Size size) {
  return Container(
      width: 1000,
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: item.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onLongPress: () async =>
                  await showModal(context: context, item: item[index]),
              onTap: () => Navigator.push(
                  context,
                  PageTransition(
                      child: EditProdut(data: item[index]),
                      type: PageTransitionType.bottomToTop)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    width: 200,
                    child: Card(
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: item[index]["image"][0],
                            filterQuality: FilterQuality.low,
                            width: size.width * 0.5,
                            useOldImageOnUrlChange: true,
                            height: size.height <= 700
                                ? size.height * 0.18
                                : size.height * 0.15,
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
                              title: Text("${item[index]["title"]}",
                                  style: TextStyle(fontSize: 14)),
                              subtitle: Text("${item[index]["subtitle"]}"),
                              trailing: Column(
                                children: [
                                  Text("R\$${item[index]["price"]}",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.green)),
                                  Tooltip(
                                    message: "Visualizações",
                                    child: Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.green,
                                      size: 22,
                                    ),
                                  ),
                                  Text("${item[index]["views"]}",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.green))
                                ],
                              ))
                        ],
                      ),
                    ),
                  )));
        },
      ));
}
