//----  Packages
import 'package:firebase_auth/firebase_auth.dart' as AuthFire;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

//---- Screens
import 'package:agricultura/src/models/Anonimous.dart';
import 'package:agricultura/src/routes/user/User.dart';
import 'package:agricultura/src/models/showModal.dart';
import 'package:agricultura/src/routes/chat/Chat.dart';
import 'package:agricultura/src/routes/store/Store.dart';
import 'package:agricultura/src/routes/home/Home.dart';

//---- Datas
import 'package:agricultura/src/data/user.dart';

class Nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  //---- Variables

  int _page = 0;

  Map data = {};

  //---- Functions

  Future<File> _getData() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future _readData() async {
    try {
      final file = await _getData();
      final userData = await jsonDecode(file.readAsStringSync());
      setState(() {
        data = userData;
      });
      return data;
    } catch (e) {
      return null;
    }
  }

  screen(index) {
    if (AuthFire.FirebaseAuth.instance.currentUser.isAnonymous) {
      switch (index) {
        case 0:
          return Home();
          break;
        case 1:
          return Anonimous();
          break;
        case 2:
          return Anonimous();
          break;
        case 3:
          return Anonimous();
          break;
        default:
          Anonimous();
      }
    } else {
      switch (index) {
        case 0:
          return Home();
          break;
        case 1:
          return Chat(data: data);
          break;
        case 2:
          return Store(
            user: user,
          );
          break;
        case 3:
          return User(data: data);
          break;
        default:
          Home();
      }
    }
  }

  @override
  void initState() {
    print("------------- Nav.dart ---------------");
    _readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.green[500],
        body: screen(_page),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.green),
              title: Text("Home", style: TextStyle(color: Colors.green)),
              activeIcon: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Container(
                    width: 40,
                    height: 40,
                    color: Colors.green,
                    child: Icon(
                      Icons.home,
                      color: Colors.white,
                    )),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat, color: Colors.green),
              title: Text(
                "Chat",
                style: TextStyle(color: Colors.green),
              ),
              activeIcon: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Container(
                    width: 40,
                    height: 40,
                    color: Colors.green,
                    child: Icon(
                      Icons.chat,
                      color: Colors.white,
                    )),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_grocery_store, color: Colors.green),
              title: Text(
                "Store",
                style: TextStyle(color: Colors.green),
              ),
              activeIcon: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Container(
                    width: 40,
                    height: 40,
                    color: Colors.green,
                    child: Icon(
                      Icons.local_grocery_store,
                      color: Colors.white,
                    )),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.green),
              title: Text("Person", style: TextStyle(color: Colors.green)),
              activeIcon: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Container(
                    width: 40,
                    height: 40,
                    color: Colors.green,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    )),
              ),
            ),
          ],
          currentIndex: _page,
          onTap: (value) {
            setState(() {
              _page = value;
            });
          },
        ),
        floatingActionButton: _page == 0
            ? AuthFire.FirebaseAuth.instance.currentUser.isAnonymous == false
                ? FloatingActionButton(
                    backgroundColor: Colors.green,
                    onPressed: () {
                      showModal(context, data, size);
                    },
                    child: Icon(Icons.add),
                  )
                : null
            : null);
  }
}
