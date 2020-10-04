//---- Packages
import 'package:agricultura/src/data/home.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

//---- Screens
import 'package:agricultura/src/routes/user/Visualizar.dart';

class User extends StatefulWidget {
  User({Key key, this.data}) : super(key: key);
  final data;
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  List myPlantas = [];

  myplantas() async {
    for (var x = 0; x < plantas.length; x++) {
      if (plantas[x]["author"] == widget.data["name"]) {
        setState(() {
          myPlantas.add(plantas[x]);
        });
      } else {
        print("Não é meu");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    print("--------------- User.dart--------------");
    myplantas();
    super.initState();
  }

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
                child: Container(
                    width: 1000,
                    height: 210,
                    color: Colors.white,
                    child: Column(children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: Image.asset(
                            "${myPlantas[0]["image_author"]}",
                            height: 180,
                          ),
                        ),
                      ),
                      Text(
                        "${widget.data["name"]}",
                        style: TextStyle(fontSize: 16),
                      )
                    ]))),
            Divider(
              color: Colors.green,
            ),
            Text(
              "Meus anúncios",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            Container(
              width: 1000,
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                      width: 130,
                      child: Card(
                        child: Column(
                          children: [
                            Image.asset(
                              "${myPlantas[index]["image"]}",
                              height: 80,
                            ),
                            ListTile(
                              title: Text("${myPlantas[index]["title"]}"),
                              subtitle: Text("${myPlantas[index]["subtitle"]}"),
                              onTap: () => Navigator.push(
                                  context,
                                  PageTransition(
                                      child: Visualizar(
                                        name: myPlantas[index]["title"],
                                      ),
                                      type: PageTransitionType.bottomToTop)),
                            )
                          ],
                        ),
                      ));
                },
                itemCount: myPlantas.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
