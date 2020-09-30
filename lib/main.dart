//---- Packages
import 'package:flutter/material.dart';
import 'package:simple_splashscreen/simple_splashscreen.dart';

//---- Screens
import 'package:agricultura/src/models/Splash.dart';
import 'package:agricultura/src/models/Nav.dart';

void main() {
  runApp(MaterialApp(
    home: Index(),
    theme: ThemeData(cardColor: Colors.white),
    title: "Agro é tudo",
  ));
}

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  @override
  Widget build(BuildContext context) {
    return Simple_splashscreen(
        context: context,
        splashscreenWidget: Splash(),
        gotoWidget: Nav(),
        timerInSeconds: 2);
  }
}
