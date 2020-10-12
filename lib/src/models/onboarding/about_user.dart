import 'package:flutter/material.dart';

class AboutUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(1000),
          child: Image.asset(
            "assets/images/eu.jpg",
            width: 300,
          ),
        ),
        Text(
          "Ramon Paolo Maran",
          style: TextStyle(color: Colors.white),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
              "Desenvolvedor a 2 anos. Cursando técnico em desenvolvimento de sistemas na Etec de Itapeva e autodidata a 2 anos",
              style: TextStyle(color: Colors.white)),
        )
      ],
    ));
  }
}
