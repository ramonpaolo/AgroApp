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

  List myProduts = [];

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

  getMyProduts() async {
    for (var x = 0; x < produtos.length; x++) {
      if (produtos[x]["author"] == widget.data["name"]) {
        setState(() {
          myProduts.add(produtos[x]);
        });
      } else {
        print("Não é meu");
      }
    }
  }

  Future<File> _getData() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future _deleteData() async {
    final path = await _getData();
    await path.delete();
  }

  @override
  void initState() {
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
    getMyProduts();
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
                            padding: EdgeInsets.only(top: 30),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(200),
                                child: Image.network(
                                  "${widget.data["image"]}",
                                  filterQuality: FilterQuality.high,
                                  fit: BoxFit.fill,
                                  height: 160,
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
                        onPressed: () async {
                          await showModalConf(
                              context: context,
                              localizacao: localizacao,
                              firebaseAuth: FirebaseAuth.instance,
                              googleSignIn: _googleSignIn,
                              deleteData: _deleteData);
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
            myProduts.length == 0
                ? Text(
                    "Sem anúncio",
                    style: TextStyle(color: Colors.white),
                  )
                : construtor(myProduts),
            TextButton.icon(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                  } catch (e) {
                    await _googleSignIn.signOut();
                  }
                  await _deleteData();
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
        return GestureDetector(
            onLongPress: () async =>
                await showModal(context: context, item: item, index: index),
            onTap: () => Navigator.push(
                  context,
                  PageTransition(
                      child: Visualizar(data: item[index]),
                      type: PageTransitionType.bottomToTop),
                ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                    width: 170,
                    child: Card(
                      child: Column(
                        children: [
                          Container(
                            height: 110,
                            child: Image.file(
                              File(item[index]["image"][0]),
                              fit: BoxFit.fill,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                          ListTile(
                            title: Text(item[index]["title"]),
                            subtitle: Text(item[index]["subtitle"]),
                            trailing: Padding(
                                padding: EdgeInsets.only(top: 6),
                                child: Tooltip(
                                  message: "Vizualizações",
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
                          ),
                        ],
                      ),
                    ))));
      },
      itemCount: item.length,
    ),
  );
}
