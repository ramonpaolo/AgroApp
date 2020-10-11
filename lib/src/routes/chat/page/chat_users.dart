//---- Packages
import 'package:flutter/material.dart';

//---- Screens
import 'package:agricultura/src/routes/chat/ChatPV.dart';

Widget chatUsers(
    {Size size, Map searchedUser, BuildContext context, Map data, List users}) {
  return SizedBox(
      width: size.width,
      height: size.height * 0.8,
      child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(60), topRight: Radius.circular(60)),
          child: Container(
              color: Colors.white,
              child: Column(children: [
                Divider(
                  color: Colors.white,
                ),
                Text(
                  "Fazendeiros amigos",
                  style: TextStyle(color: Colors.green, fontSize: 18),
                ),
                SizedBox(
                    width: size.width,
                    height: size.height <= 700
                        ? size.height * 0.59
                        : size.height * 0.656,
                    child: searchedUser != null
                        ? Padding(
                            padding: EdgeInsets.only(top: 20, left: 10),
                            child: ListTile(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatPV(
                                            name: searchedUser["name"],
                                            user: data,
                                            messages: searchedUser["mensagen"],
                                            image: searchedUser["image"],
                                            id: searchedUser["id"],
                                          ))),
                              contentPadding:
                                  EdgeInsets.only(left: 20, right: 20, top: 5),
                              title: Text(searchedUser["name"]),
                              leading: ClipRRect(
                                child: Image.asset("assets/images/eu.jpg"),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              subtitle: searchedUser["mensagen"][0]["type"] ==
                                      "img"
                                  ? Row(children: [
                                      Text("Imagem"),
                                      Icon(
                                        Icons.camera_alt,
                                        color: Colors.green,
                                        size: 18,
                                      )
                                    ])
                                  : Text(
                                      searchedUser["mensagen"][0]["content"]),
                            ))
                        : ListView.builder(
                            padding: EdgeInsets.only(left: 10, top: 20),
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatPV(
                                              name: users[index]["name"],
                                              messages: users[index]
                                                  ["mensagen"],
                                              user: data,
                                              image: users[index]["image"],
                                              id: users[index]["id"],
                                            ))),
                                contentPadding: EdgeInsets.only(
                                    left: 20, right: 20, top: 5),
                                title: Text(users[index]["name"]),
                                leading: ClipRRect(
                                  child: Image.asset("assets/images/eu.jpg"),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                subtitle: users[index]["mensagen"][0]["type"] ==
                                        "img"
                                    ? Row(children: [
                                        Text("Imagem"),
                                        Icon(
                                          Icons.camera_alt,
                                          color: Colors.green,
                                          size: 18,
                                        )
                                      ])
                                    : Text(
                                        users[index]["mensagen"][0]["content"]),
                              );
                            }))
              ]))));
}
