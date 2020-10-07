import 'package:agricultura/src/auth/login.dart';
import 'package:agricultura/src/models/instructions/app.dart';
import 'package:agricultura/src/models/instructions/user.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Instruction extends StatefulWidget {
  @override
  _InstructionState createState() => _InstructionState();
}

class _InstructionState extends State<Instruction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 380,
                  height: 600,
                  child: PageView(
                    children: [App(), User()],
                  ),
                ),
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    width: 200,
                    height: 50,
                    child: RaisedButton(
                      color: Colors.white,
                      onPressed: () async {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: Login(),
                                type: PageTransitionType.bottomToTop));
                      },
                      child: Text(
                        "Fazer Login",
                        style: TextStyle(color: Colors.green, fontSize: 18),
                      ),
                    ),
                  )),
            ],
          ),
        ));
  }
}
