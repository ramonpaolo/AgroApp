//---- Packages
import 'package:flutter/material.dart';
import 'dart:async';

//---- Screens
import 'package:agricultura/src/routes/chat/page/chat_groups.dart';
import 'package:agricultura/src/routes/chat/page/chat_users.dart';

//---- Datas
import 'package:agricultura/src/data/chat.dart';

class Chat extends StatefulWidget {
  Chat({Key key, this.data}) : super(key: key);
  final Map data;
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  //---- Variables

  Map searchedUser;
  Map dataUser;

  TextEditingController _searchController = TextEditingController();

  //---- Functions

  Future search(search) async {
    for (var x = 0; x <= users.length; x++) {
      if (search == users[x]["name"]) {
        setState(() {
          searchedUser = users[x];
        });
        return searchedUser;
      } else if (x == users.length) {
        return search;
      }
    }
  }

  @override
  void initState() {
    print("------------ Chat.dart -------------");
    setState(() {
      dataUser = widget.data;
    });
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
                            child: Image.network(dataUser["image"])),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Center(
                            child: Text(
                          dataUser["name"],
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
                  textCapitalization: TextCapitalization.words,
                  cursorColor: Colors.green[900],
                  controller: _searchController,
                  onChanged: (value) {
                    search(_searchController.text);
                    if (value.isEmpty) {
                      setState(() {
                        _searchController.text = null;
                        searchedUser.clear();
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
                            searchedUser.clear();
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
                chatUsers(
                    context: context,
                    size: size,
                    searchedUser: searchedUser,
                    data: dataUser,
                    users: users),
                chatGroups(grupos: grupos, size: size)
              ]))
        ],
      ),
    ));
  }
}
