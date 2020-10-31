//---- Packages
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

//---- API
import 'package:agricultura/src/firebase/api_firebase.dart';

//---- Functions
import 'package:agricultura/src/routes/user/widgets/myAnuncios.dart';
import 'package:agricultura/src/routes/user/widgets/analytics.dart';
import 'package:agricultura/src/routes/user/functions/show_modal.dart';
import 'package:agricultura/src/routes/user/functions/add_photo_profile.dart';

//---- Screens
import 'package:agricultura/src/auth/Login.dart';

class User extends StatefulWidget {
  User({Key key, this.data}) : super(key: key);
  final data;
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  //---- Variables

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

  var _snack = GlobalKey<ScaffoldState>();

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

    dataUser.showMyProduts(widget.data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _snack,
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
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: widget.data["image"] != 'null'
                                      ? EdgeInsets.only(top: 30)
                                      : EdgeInsets.only(top: 50, bottom: 10),
                                  child: widget.data["image"] != 'null'
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(200),
                                          child: Image.network(
                                            "${widget.data["image"]}",
                                            filterQuality: FilterQuality.high,
                                            fit: BoxFit.fill,
                                            height: 160,
                                          ))
                                      : RaisedButton.icon(
                                          color: Colors.white,
                                          elevation: 0.0,
                                          onPressed: () async {
                                            await showModalBottomSheet(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(40),
                                                            topRight:
                                                                Radius.circular(
                                                                    40))),
                                                context: context,
                                                builder: (context) {
                                                  return Container(
                                                      height:
                                                          size.height * 0.16,
                                                      child: Column(children: [
                                                        Divider(
                                                            color:
                                                                Colors.white),
                                                        Text(
                                                          "Olá ${widget.data["name"]}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                          "Adicione uma foto de perfil clicando no botão a baixo.",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontSize: 14),
                                                        ),
                                                        IconButton(
                                                          icon: Icon(
                                                              Icons.attach_file,
                                                              color:
                                                                  Colors.green),
                                                          onPressed: () async {
                                                            await addPhotoProfile(
                                                                _snack,
                                                                widget.data,
                                                                context);
                                                          },
                                                          tooltip:
                                                              "Adicionar foto de perfil",
                                                        )
                                                      ]));
                                                });
                                          },
                                          icon: Icon(
                                            Icons.person_add,
                                            color: Colors.green,
                                            size: 126,
                                          ),
                                          label: Text("Add imagem"))),
                              Text(
                                "${widget.data["name"]}",
                                style: TextStyle(
                                    fontSize: 14,
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
                            googleSignIn: _googleSignIn,
                            myProduts: myProduts,
                          );
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
                : construtor(myProduts, size),
            myProduts.length > 1
                ? Padding(
                    padding: EdgeInsets.all(20),
                    child: Analytics(data: myProduts),
                  )
                : Text("Anuncie mais produtos para ver o gráfico",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
            TextButton.icon(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                  } catch (e) {
                    await _googleSignIn.signOut();
                  }

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
