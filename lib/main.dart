//---- Packages
import 'package:flutter/material.dart';
import 'package:simple_splashscreen/simple_splashscreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

//---- Screens
import 'package:agricultura/src/models/Nav.dart';
import 'package:agricultura/src/auth/login.dart';
import 'package:agricultura/src/models/Splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: Index(),
    theme: ThemeData(cardColor: Colors.white, fontFamily: "Roboto"),
    title: "Agro é tudo",
  ));
}

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  String data = "";

  Future<File> _getData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/data.json");
    return file;
  }

  Future _readData() async {
    try {
      final file = await _getData();
      final decode = await jsonDecode(file.readAsStringSync());
      setState(() {
        data = "tem";
      });
      print(await decode);
      return decode;
    } catch (e) {
      print("Error: " + e.toString());
      setState(() {
        data = "nao";
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    print("------------ main.dart------------");
    _readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Simple_splashscreen(
        context: context,
        splashscreenWidget: Splash(),
        gotoWidget: data == "tem" ? Nav() : Login(),
        timerInSeconds: 2);
  }
}
