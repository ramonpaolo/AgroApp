//---- Packages
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

//---- Screens
import 'package:agricultura/src/auth/Login.dart';
import 'package:agricultura/src/pages/onboarding/about_developer.dart';
import 'package:agricultura/src/pages/onboarding/about_app.dart';

class Instruction extends StatefulWidget {
  @override
  _InstructionState createState() => _InstructionState();
}

class _InstructionState extends State<Instruction> {
  //---- Variables

  int _page = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.green,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                    width: size.width,
                    height: size.height * 0.8,
                    child: CarouselSlider(
                        items: [AboutApp(), AboutUser()],
                        options: CarouselOptions(
                          height: size.height,
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
                        ))),
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
                    width: size.width * 0.6,
                    height: size.height * 0.07,
                    child: RaisedButton(
                      color: Colors.white,
                      onPressed: () async {
                        await Navigator.pushReplacement(
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
