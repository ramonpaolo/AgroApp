import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(left: 24, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Bem Vindo a AgroTudo",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          Text("Um app focado nos agricultores do nosso Brasil",
              style: TextStyle(color: Colors.white, fontSize: 16)),
          Divider(color: Colors.green,),
          ClipRRect(
            child: Image.asset(
              "assets/images/agricultura.png",
            ),
            borderRadius: BorderRadius.circular(1000),
          ),
          Divider(color: Colors.green,),
          Text(
              "A missão desse App é ajudar a você ter toda a facilidade para comprar, vender e conversar com quem você precisa em qualquer lugar no Brasil. Ajudaremos a vender os seus produtos, a comprar o seu adubo e a conversar com quem já passou dificuldades igual ao que vocês está passando",
              style: TextStyle(color: Colors.white, fontSize: 16))
        ],
      ),
    ));
  }
}
