//---- Packages
import 'package:flutter/material.dart';
import 'package:simple_splashscreen/simple_splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'dart:convert';

//---- Screens
import 'package:agricultura/src/models/onboarding/screen_initial.dart';
import 'package:agricultura/src/models/Nav.dart';
import 'package:agricultura/src/models/widgets/SplashScreen.dart';

//---- API
import 'package:agricultura/src/firebase/api_firebase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: Index(),
    theme: ThemeData(cardColor: Colors.white, fontFamily: "Noto Sans"),
    title: "Agro é tudo",
  ));
}

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  //---- Variables

  Map dataUser = {"email": null};

  //---- Functions

  Future _readData() async {
    try {
      final file = await LocalUser().getData();
      setState(() {
        dataUser = jsonDecode(file.readAsStringSync());
      });
      print(dataUser);
      return dataUser;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    print("------------ main.dart------------");
    _readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Simple_splashscreen(
        context: context,
        splashscreenWidget: Splash(),
        gotoWidget: dataUser["email"] != null ? Nav() : Instruction(),
        timerInSeconds: 2);
  }
}
