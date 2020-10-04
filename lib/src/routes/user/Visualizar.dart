import 'package:flutter/material.dart';

class Visualizar extends StatefulWidget {
  Visualizar({Key key, this.name, this.subtitle, this.image}) : super(key: key);
  final String name;
  final String subtitle;
  final String image;
  @override
  _VisualizarState createState() => _VisualizarState();
}

class _VisualizarState extends State<Visualizar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40)),
                child: Center(
                  child: Container(
                    width: 1000,
                    height: 200,
                    color: Colors.white,
                    child: Text("${widget.name}"),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
