//----  Packages
import 'package:flutter/material.dart';
import 'package:agricultura/src/firebase/api_firebase.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart' as AuthFire;
import 'dart:async';

//---- Screens
import 'package:agricultura/src/models/Anonimous.dart';
import 'package:agricultura/src/routes/user/User.dart';
import 'package:agricultura/src/routes/store/Store.dart';
import 'package:agricultura/src/routes/home/Home.dart';

//---- Functions
import 'package:agricultura/src/models/widgets/showModal.dart';

class Nav extends StatefulWidget {
  Nav({Key key}) : super(key: key);
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  //---- Variables

  int _page = 0;

  Map data = {};

  LocalUser localUser = LocalUser();

  Future _setData() async {
    try {
      final document = await firebaseFirestore
          .collection("users")
          .doc(AuthFire.FirebaseAuth.instance.currentUser.uid)
          .get();
      data = document.data();
      return data;
    } catch (e) {
      return null;
    }
  }

  setScreen(index) {
    if (AuthFire.FirebaseAuth.instance.currentUser.isAnonymous) {
      switch (index) {
        case 0:
          return Home();
          break;

        default:
          return Anonimous();
      }
    } else {
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
    _setData();
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
                      showModal(context, data, size);
                    },
                    child: Icon(Icons.add),
                  )
                : null
            : null);
  }
}
