//---- Packages
import 'package:flutter/material.dart';

//---- Screens
import 'package:agricultura/src/routes/chat/ChatPV.dart';

Widget chatGroups({Size size, List grupos}) {
  return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60), topRight: Radius.circular(60)),
      child: Container(
        width: size.width,
        height: 200,
        child: Column(children: [
          Divider(
            color: Colors.white,
          ),
          Text(
            "Grupos",
            style: TextStyle(color: Colors.green, fontSize: 18),
          ),
          Container(
            width: size.width,
            height:
                size.height <= 700 ? size.height * 0.59 : size.height * 0.656,
            child: ListView.builder(
              itemCount: grupos.length,
              itemBuilder: (context, index) {
                return Container(
                    width: 1000,
                    height: 100,
                    padding: EdgeInsets.all(20),
                    child: ListTile(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatPV(
                                    name: grupos[index]["name"],
                                    messages: grupos[index]["mensagen"],
                                    image: grupos[index]["image"],
                                    id: grupos[index]["id"],
                                  ))),
                      title: Text(grupos[index]["name"]),
                      leading: ClipRRect(
                        child: Image.asset(grupos[index]["image"]),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      subtitle: grupos[index]["mensagen"][0]["type"] == "img"
                          ? Row(children: [
                              Text("Imagem"),
                              Icon(
                                Icons.camera_alt,
                                color: Colors.green,
                                size: 18,
                              )
                            ])
                          : Text(grupos[index]["mensagen"][0]["content"]),
                    ));
              },
            ),
          )
        ]),
        color: Colors.white,
      ));
}
