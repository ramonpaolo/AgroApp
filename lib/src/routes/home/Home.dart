//---- Packages
import 'dart:io';
import 'package:agricultura/src/data/category.dart';
import 'package:agricultura/src/routes/home/Category.dart';
import 'package:agricultura/src/routes/home/Product.dart';
import 'package:agricultura/src/routes/home/Products.dart';
import 'package:agricultura/src/routes/home/widgets/campo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//---- Datas
import 'package:agricultura/src/data/home.dart';
import 'package:page_transition/page_transition.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //---- Variables

  bool animated = true;

  http.Response response;

  String pesquisa;

  TextEditingController _pesquisa = TextEditingController();

  var dolar;
  var tempo;
  var localization;
  var planta;

  //---- Functions

  //----- Key api: 63c27cec

  Future money() async {
    try {
      //response = await http.get("https://api.hgbrasil.com/finance");
      response = await http.get("https://google");
      var json = await jsonDecode(response.body);

      dolar = await json["results"]["currencies"]["USD"]["buy"];
      print("API Dolar:");
      print(await dolar);
    } catch (e) {
      print(e);
    }
    return await dolar != null ? dolar : null;
    //return dolar;
  }

  Future wheater(woeid) async {
    try {
      //response = await http
      //  .get("https://api.hgbrasil.com/weather?woeid=$woeid&key=63c27cec");
      response = await http.get("https://google");
      tempo = await jsonDecode(response.body);
      print("API Tempo:");
      print(await tempo);
    } catch (e) {
      print(e);
    }
    return await tempo['results']['city'] != null ? tempo : null;
  }

  Future localizatio() async {
    try {
      //response = await http.get(
      //    "https://api.hgbrasil.com/geoip?key=63c27cec&address=remote&precision=false");
      response = await http.get("https://google");
      localization = await jsonDecode(response.body);
      print("API localização:");
      print(await localization);
    } catch (e) {
      print(e);
    }

    return await localization["results"]["woeid"] != null ? localization : null;
  }

  Future<dynamic> datas() async {
    try {
      await localizatio();
      await money();
      await wheater(await localization["results"]["woeid"]);
    } catch (e) {
      return null;
    }
    return {await dolar, await tempo, await localization};
  }

  Future search(search) async {
    for (var x = 0; x <= produtos.length; x++) {
      if (search == produtos[x]["title"]) {
        print("Esse mesmo: $search");
        setState(() {
          pesquisa = search;
          planta = produtos[x];
        });
        return pesquisa;
      } else if (x == produtos.length) {
        print("Não tem :(");
        return search;
      }
    }
  }

  Future json() async {
    setState(() {
      produtos = produtos;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      child: TextField(
                        controller: _pesquisa,
                        onChanged: (value) {
                          setState(() {
                            animated = false;
                          });
                          search(_pesquisa.text);
                          value = _pesquisa.text;
                          if (value.isEmpty) {
                            setState(() {
                              animated = true;
                              pesquisa = null;
                            });
                          }
                        },
                        showCursor: true,
                        strutStyle: StrutStyle(leading: 0.4),
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.green[900],
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.green,
                          ),
                          suffixIcon: pesquisa != null
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _pesquisa.clear();
                                      animated = true;
                                      pesquisa = null;
                                    });
                                  })
                              : null,
                        ),
                      ),
                      decoration: BoxDecoration(color: Colors.white),
                    ),
                  ),
                ),
                AnimatedCrossFade(
                    firstChild: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.wb_sunny,
                            color: Colors.yellow,
                            size: 88.0,
                          ),
                          Padding(
                            child: Column(children: [
                              Row(
                                children: [
                                  Text(
                                    "Max:" +
                                        tempo["results"]["forecast"][0]["max"]
                                            .toString() +
                                        "ºC",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  Text(
                                    " Min:" +
                                        tempo["results"]["forecast"][0]["min"]
                                            .toString() +
                                        "ºC",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ],
                              ),
                              Text(
                                tempo['results']['city'],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Text(
                                "R\$${dolar.toStringAsPrecision(3)} um dólar",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              )
                            ]),
                            padding: EdgeInsets.only(left: 24),
                          )
                        ],
                      ),
                    ),
                    secondChild: Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            pesquisa == null
                                ? Text("Pesquisando...",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18))
                                : Text("")
                          ]),
                      pesquisa != null
                          ? Text("Achado!",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18))
                          : Text("")
                    ]),
                    crossFadeState: animated
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: Duration(milliseconds: 700)),
                Divider(
                  height: 2.5,
                ),
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60)),
                    child: RefreshIndicator(
                      child: pesquisa != null
                          ? Container(
                              height: size.height <= 700
                                  ? size.height * 0.62 + (animated ? 0 : 51)
                                  : size.height * 0.7 + (animated ? 0 : 70),
                              color: Colors.white,
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Stack(
                                              alignment: AlignmentDirectional
                                                  .bottomEnd,
                                              textDirection: TextDirection.rtl,
                                              children: [
                                                Image.file(
                                                  File(planta["image"]),
                                                  filterQuality:
                                                      FilterQuality.high,
                                                  fit: BoxFit.fill,
                                                ),
                                                IconButton(
                                                    icon: Icon(
                                                      Icons.favorite,
                                                      color: planta["favorite"]
                                                          ? Colors.green
                                                          : Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        planta["favorite"] =
                                                            !planta["favorite"];
                                                      });
                                                    }),
                                              ],
                                            ),
                                            ListTile(
                                              title: Text("${planta["title"]}"),
                                              subtitle:
                                                  Text("${planta["subtitle"]}"),
                                            ),
                                          ],
                                        ),
                                      ))))
                          : Container(
                              height: 10,
                              width: 10,
                              child: construtor(size, produtos, "Que?", context,
                                  Scaffold.of(context).setState)),
                      onRefresh: json,
                    )),
              ],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          return SingleChildScrollView(
              child: Column(
            children: [
              Divider(
                color: Colors.green,
                height: 30,
              ),
              Text(
                "Categorias",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              Divider(color: Colors.green),
              Container(
                width: 1000,
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              PageTransition(
                                  child: Category(
                                    category: category[index],
                                  ),
                                  type: PageTransitionType.bottomToTop)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                                width: 120,
                                color: Colors.white,
                                child: Stack(
                                  alignment: Alignment.bottomLeft,
                                  children: [
                                    Image.asset(
                                      category[index]["image"],
                                      fit: BoxFit.fill,
                                      filterQuality: FilterQuality.high,
                                      height: size.height,
                                      width: size.width,
                                    ),
                                    ListTile(
                                        title: Text(
                                      category[index]["name"],
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ))
                                  ],
                                )),
                          ),
                        ));
                  },
                  itemCount: category.length,
                ),
              ),
              Divider(
                color: Colors.green,
              ),
              construtor(size, produtos, "Os principais do mês de outubro",
                  context, Scaffold.of(context).setState),
            ],
          ));
        }
      },
      future: datas(),
    );
  }
}
