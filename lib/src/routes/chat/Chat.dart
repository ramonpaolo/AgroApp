//---- Packages
import 'package:flutter/material.dart';
import 'dart:async';

//---- Screens
import 'package:agricultura/src/routes/chat/ChatPV.dart';

//---- Datas
import 'package:agricultura/src/data/chat.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  //---- Variables

  Map user = {"name": null};

  TextEditingController _searchController = TextEditingController();

  //---- Functions

  Future search(search) async {
    for (var x = 0; x <= users.length; x++) {
      if (search == users[x]["name"]) {
        print("'Chat.dart': Esse mesmo: $search");
        setState(() {
          user["name"] = users[x]["name"];
          user["mensagen"] = users[x]["mensagen"];
          user["image"] = users[x]["image"];
        });
        return user;
      } else if (x == users.length) {
        print("Não tem : (");
        return search;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    print(users[0]["mensagen"][0]["content"]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Center(
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(top: 30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Container(
                    width: size.width * 0.7,
                    height: size.height * 0.08,
                    color: Colors.white,
                    child: Row(children: [
                      Padding(
                        padding: EdgeInsets.all(3),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset(
                            "assets/eu.jpg",
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Center(
                            child: Text(
                          "Ramon Paolo Maran",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        )),
                      )
                    ])),
              )),
          Padding(
            padding: EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: Colors.white,
                child: TextField(
                  cursorColor: Colors.green[900],
                  controller: _searchController,
                  onChanged: (value) {
                    search(_searchController.text);
                    if (value.isEmpty) {
                      setState(() {
                        _searchController.text = null;
                        user["name"] = null;
                      });
                    }
                  },
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            user["name"] = null;
                          });
                        },
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.green,
                      ),
                      border: InputBorder.none),
                ),
              ),
            ),
          ),
          SizedBox(
              width: size.width,
              height:
                  size.height <= 700 ? size.height * 0.645 : size.height * 0.7,
              child: PageView(children: [
                SizedBox(
                    width: size.width,
                    height: size.height * 0.8,
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60)),
                        child: Container(
                            color: Colors.white,
                            child: Column(children: [
                              Divider(
                                color: Colors.white,
                              ),
                              Text(
                                "Fazendeiros amigos",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 18),
                              ),
                              SizedBox(
                                  width: size.width,
                                  height: size.height <= 700
                                      ? size.height * 0.59
                                      : size.height * 0.656,
                                  child: user["name"] != null
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              top: 20, left: 10),
                                          child: GestureDetector(
                                              onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatPV(
                                                            name: user["name"],
                                                            messages: user[
                                                                "mensagen"],
                                                            image:
                                                                user["image"],
                                                          ))),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40),
                                                            child: Image.asset(
                                                              user["image"],
                                                              width: 60,
                                                            )),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Text(
                                                            "${user["name"]}",
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                          ),
                                                        )
                                                      ]),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 70),
                                                    child: Text(
                                                      "${user["mensagen"][0]["content"]}",
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ),
                                                  ),
                                                  Divider(
                                                    color: Colors.green[700],
                                                    height: 30,
                                                  ),
                                                ],
                                              )))
                                      : ListView.builder(
                                          padding: EdgeInsets.only(
                                              left: 10, top: 20),
                                          itemCount: users.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatPV(
                                                            name: users[index]
                                                                ["name"],
                                                            messages: users[
                                                                    index]
                                                                ["mensagen"],
                                                            image: users[index]
                                                                ["image"],
                                                            id: users[index]
                                                                ["id"],
                                                          ))),
                                              contentPadding:
                                                  EdgeInsets.all(20),
                                              title: Text(users[index]["name"]),
                                              leading: ClipRRect(
                                                child: Image.asset(
                                                    "assets/eu.jpg"),
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              subtitle: Text(
                                                  "${users[index]["mensagen"][0]["content"]}"),
                                            );
                                          }))
                            ])))),
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60)),
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
                          height: size.height <= 700
                              ? size.height * 0.59
                              : size.height * 0.656,
                          child: ListView.builder(
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Container(
                                  width: 1000,
                                  height: 100,
                                  padding: EdgeInsets.all(20),
                                  child: ListTile(
                                    title: Text("Grupo $index"),
                                    leading: ClipRRect(
                                      child: Image.asset("assets/eu.jpg"),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    subtitle: Text("$index"),
                                  ));
                            },
                          ),
                        )
                      ]),
                      color: Colors.white,
                    ))
              ]))
        ],
      ),
    ));
  }
}
