import 'package:agricultura/src/auth/login.dart';
import 'package:agricultura/src/models/instructions/app.dart';
import 'package:agricultura/src/models/instructions/user.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Instruction extends StatefulWidget {
  @override
  _InstructionState createState() => _InstructionState();
}

class _InstructionState extends State<Instruction> {
  int _page = 0;
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
                    height: 560,
                    child: CarouselSlider(
                        items: [App(), User()],
                        options: CarouselOptions(
                          height: 1000,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          initialPage: 0,
                          enableInfiniteScroll: false,
                          viewportFraction: 1,
                          onPageChanged: (page, i) {
                            setState(() {
                              _page = page;
                            });
                          },
                        ))

                    /* PageView(
                    children: [App(), User()],
                  ),*/
                    ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Container(
                        color:
                            _page == 0 ? Colors.green[100] : Colors.green[300],
                        width: 20,
                        height: 10,
                      )),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Container(
                          color: _page == 1
                              ? Colors.green[100]
                              : Colors.green[300],
                          width: 20,
                          height: 10,
                        )),
                  )
                ],
              ),
              Divider(
                color: Colors.green,
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
