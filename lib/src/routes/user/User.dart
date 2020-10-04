//---- Packages
import 'package:agricultura/src/auth/login.dart';
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

  bool localizacao = true;

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
            Stack(
              alignment: Alignment(1, 1),
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
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          )
                        ]))),
                IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          context: (context),
                          builder: (context) {
                            return Container(
                              padding: EdgeInsets.all(40),
                              color: Colors.white,
                              width: 1000,
                              height: 1000,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Localização $localizacao"),
                                      Switch(
                                        value: localizacao,
                                        onChanged: (v) {
                                          setState(() {
                                            localizacao = v;
                                          });
                                        },
                                        activeColor: Colors.green,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                    }),
              ],
            ),
            Divider(
              color: Colors.green,
            ),
            Text(
              "Meus anúncios",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            Container(
              width: 1000,
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                          width: 170,
                          child: Card(
                            child: Column(
                              children: [
                                Container(
                                  height: 110,
                                  child: Image.asset(
                                    "${myPlantas[index]["image"]}",
                                    fit: BoxFit.fill,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                                ListTile(
                                  title: Text("${myPlantas[index]["title"]}"),
                                  subtitle:
                                      Text("${myPlantas[index]["subtitle"]}"),
                                  onTap: () => Navigator.push(
                                    context,
                                    PageTransition(
                                        child: Visualizar(
                                          name: myPlantas[index]["title"],
                                        ),
                                        type: PageTransitionType.bottomToTop),
                                  ),
                                  trailing: Padding(
                                      padding: EdgeInsets.only(top: 6),
                                      child: Tooltip(
                                        message: "Views",
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.remove_red_eye,
                                              color: Colors.green,
                                            ),
                                            Text(
                                              myPlantas[index]["views"]
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green),
                                            )
                                          ],
                                        ),
                                      )),
                                  onLongPress: () => showModalBottomSheet(
                                      context: (context),
                                      builder: (context) {
                                        return SingleChildScrollView(
                                            child: Container(
                                          padding: EdgeInsets.all(20),
                                          height: 500,
                                          width: 1000,
                                          child: Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Image.asset(
                                                  myPlantas[index]["image"],
                                                  height: 140,
                                                  filterQuality:
                                                      FilterQuality.high,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.download_rounded,
                                                      color: Colors.green,
                                                    ),
                                                    onPressed: () {},
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.share,
                                                      color: Colors.green,
                                                    ),
                                                    onPressed: () {},
                                                  ),
                                                ],
                                              ),
                                              ListTile(
                                                title: Text(
                                                    myPlantas[index]["title"]),
                                                subtitle: Text(myPlantas[index]
                                                    ["subtitle"]),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.all(15),
                                                  child: Text(
                                                    myPlantas[index]
                                                        ["describe"],
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ))
                                            ],
                                          ),
                                        ));
                                      }),
                                )
                              ],
                            ),
                          )));
                },
                itemCount: myPlantas.length,
              ),
            ),
            TextButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                label: Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
