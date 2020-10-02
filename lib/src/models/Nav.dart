//----  Packages
import 'package:flutter/material.dart';

//---- Screens
import 'package:agricultura/src/routes/chat/Chat.dart';
import 'package:agricultura/src/routes/store/Store.dart';
import 'package:agricultura/src/routes/home/Home.dart';
import 'package:agricultura/src/routes/home/AddContent.dart';

class Nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  //---- Variables

  int _page = 0;
  List pages = [Home(), Chat(), Store()];
  double sizeIcon = 40;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.green[500],
        body: pages[_page],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.green),
              title: Text("Home", style: TextStyle(color: Colors.green)),
              activeIcon: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Container(
                    width: sizeIcon,
                    height: sizeIcon,
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
                    width: sizeIcon,
                    height: sizeIcon,
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
                    width: sizeIcon,
                    height: sizeIcon,
                    color: Colors.green,
                    child: Icon(
                      Icons.local_grocery_store,
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
            ? FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: () {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      context: context,
                      builder: (c) {
                        return Container(
                          width: size.width,
                          height: 600,
                          color: Colors.white,
                          child: Column(children: [
                            Image.asset(
                              "assets/reuniao.jpg",
                              height: 200,
                            ),
                            Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "Ficamos felizes em saber que você deseja publicar um produto para venda. Te desejamos muita sorte em sua nova jornada.",
                                  style: TextStyle(fontSize: 16),
                                )),
                            RaisedButton.icon(
                                color: Colors.green,
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddContent())),
                                icon: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "Continuar",
                                  style: TextStyle(color: Colors.white),
                                ))
                          ]),
                        );
                      });
                },
                child: Icon(Icons.add),
              )
            : null);
  }
}
