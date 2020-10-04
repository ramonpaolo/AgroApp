//---- Packages
import 'package:flutter/material.dart';
import 'package:simple_splashscreen/simple_splashscreen.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

//---- Screens
import 'package:agricultura/src/models/Nav.dart';
import 'package:agricultura/src/auth/login.dart';
import 'package:agricultura/src/models/Splash.dart';

void main() {
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
  Future<File> _getData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/data.json");
    return file;
  }

  Future _readData() async {
    try {
      final file = await _getData();
      final decode = jsonDecode(file.readAsStringSync());
      print(decode);
      return decode;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Simple_splashscreen(
        context: context,
        splashscreenWidget: Splash(),
        gotoWidget: _readData() != null ? Nav() : Login(),
        timerInSeconds: 2);
  }
}
