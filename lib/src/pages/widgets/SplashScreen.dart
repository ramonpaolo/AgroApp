//---- Packages
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child:
            Text("Green", style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
    );
  }
}
