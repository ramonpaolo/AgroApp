//---- Packages
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

//---- Screens
import 'package:agricultura/src/auth/login.dart';
import 'package:agricultura/src/routes/user/Visualizar.dart';
import 'package:agricultura/src/routes/user/showModal.dart';

//---- Datas
import 'package:agricultura/src/data/home.dart';

class User extends StatefulWidget {
  User({Key key, this.data}) : super(key: key);
  final data;
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  //---- Variables
  bool localizacao = true;

  List myPlantas = [];
  List menorToMaior = [];

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Widget icon = Tooltip(
      message: "Email Não verificado",
      child: Icon(
        Icons.info_outline,
        color: Colors.green,
      ));

  //---- Functios

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

  Future<File> _getData() async {
    final directory = await getApplicationDocumentsDirectory();
    var file = File("${directory.path}/data.json");
    return file;
  }

  Future _saveData() async {
    final path = await _getData();
    await path.delete();
  }

  @override
  void initState() {
    // TODO: implement initState
    print("--------------- User.dart--------------");

    try {
      if (FirebaseAuth.instance.currentUser.emailVerified) {
        setState(() {
          icon = Tooltip(
              message: "Email verificado",
              child: Icon(
                Icons.verified_user,
                color: Colors.green,
              ));
        });
      } else {
        FirebaseAuth.instance.currentUser.reload();
      }
    } catch (e) {
      print(e);
    }
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
                                child: myPlantas.length >= 1
                                    ? Image.asset(
                                        "${myPlantas[0]["image_author"]}",
                                        height: 180,
                                      )
                                    : Icon(
                                        Icons.person,
                                        semanticLabel: "Sem Foto de perfil",
                                        color: Colors.green,
                                        size: 168,
                                      )),
                          ),
                          Text(
                            "${widget.data["name"]}",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          )
                        ]))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    icon,
                    IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          showModalConf(context, localizacao, FirebaseAuth,
                              _googleSignIn, _saveData, Login, setState);
                        }),
                  ],
                )
              ],
            ),
            Divider(
              color: Colors.green,
            ),
            Text(
              "Meus anúncios",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            myPlantas.length == 0
                ? Text(
                    "Sem anúncio",
                    style: TextStyle(color: Colors.white),
                  )
                : construtor(myPlantas),
            TextButton.icon(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                  } catch (e) {
                    await _googleSignIn.signOut();
                  }
                  await _saveData();
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

Widget construtor(List item) {
  return Container(
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
                        child: Image.file(
                          File(item[index]["image"]),
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      ListTile(
                          title: Text("${item[index]["title"]}"),
                          subtitle: Text("${item[index]["subtitle"]}"),
                          onTap: () => Navigator.push(
                                context,
                                PageTransition(
                                    child: Visualizar(
                                      name: item[index]["title"],
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
                                      item[index]["views"].toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    )
                                  ],
                                ),
                              )),
                          onLongPress: () => showModal(context, item, index)),
                    ],
                  ),
                )));
      },
      itemCount: item.length,
    ),
  );
}
