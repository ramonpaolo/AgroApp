//----  Packages
import 'package:flutter/material.dart';
import 'package:agricultura/src/firebase/api_firebase.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart' as AuthFire;
import 'dart:async';

//---- Screens
import 'package:agricultura/src/pages/Anonimous.dart';
import 'package:agricultura/src/routes/user/User.dart';
import 'package:agricultura/src/routes/store/Store.dart';
import 'package:agricultura/src/routes/home/Home.dart';

//---- Functions
import 'package:agricultura/src/pages/widgets/showModal.dart';

class Nav extends StatefulWidget {
  Nav({Key key, this.data}) : super(key: key);
  final Map data;
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  //---- Variables

  int _page = 0;

  LocalUser localUser = LocalUser();

  setScreen(index) {
    try {
      switch (index) {
        case 0:
          return Home();
          break;
        case 1:
          return Store(
            user: user,
          );
          break;
        case 2:
          return User(data: widget.data);
          break;
        default:
          Home();
      }
    } catch (e) {
      switch (index) {
        case 0:
          return Home();
          break;
        default:
          return Anonimous();
      }
    }
  }

  @override
  void initState() {
    print("------------- Nav.dart ---------------");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.green[500],
        body: setScreen(_page),
        bottomNavigationBar: CurvedNavigationBar(
          items: [
            Icon(Icons.home, color: Colors.green),
            Icon(Icons.local_grocery_store, color: Colors.green),
            Icon(Icons.person, color: Colors.green),
          ],
          index: _page,
          height: 50.0,
          backgroundColor: Colors.green,
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
                      showModal(context, widget.data, size);
                    },
                    child: Icon(Icons.add),
                  )
                : null
            : null);
  }
}
