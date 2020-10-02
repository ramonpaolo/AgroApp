//---- Packages
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

//---- Datas
import 'package:agricultura/src/data/home.dart';

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

  Future search(search) async {
    for (var x = 0; x <= plantas.length; x++) {
      if (search == plantas[x]["title"]) {
        print("Esse mesmo: $search");
        setState(() {
          pesquisa = search;
          planta = plantas[x];
        });
        return pesquisa;
      } else if (x == plantas.length) {
        print("Não tem :(");
        return search;
      }
    }
  }

  Future money() async {
    try {
      response = await http.get("https://api.hgbrasil.com/finance");
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
      response = await http
          .get("https://api.hgbrasil.com/weather?woeid=$woeid&key=6b6695e0");
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
      response = await http.get(
          "https://api.hgbrasil.com/geoip?key=6b6695e0&address=remote&precision=false");
      localization = await jsonDecode(response.body);
      print("API localização:");
      print(await localization);
    } catch (e) {
      print(e);
    }

    return await localization["resuls"]["woeid"] != null ? localization : null;

    //return await localization["results"]["woeid"];
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        child: FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
                    child: Container(
                        height: size.height <= 700
                            ? size.height * 0.62 + (animated ? 0 : 51)
                            : size.height * 0.7 + (animated ? 0 : 70),
                        color: Colors.white,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: pesquisa != null
                            ? Padding(
                                padding: EdgeInsets.all(20),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Card(
                                      child: Column(
                                        children: [
                                          Stack(
                                            textDirection: TextDirection.rtl,
                                            children: [
                                              Image.network(
                                                "https://correiodoscampos.com.br/wp-content/uploads/2017/10/006-geral-eucalipto.jpg",
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
                                    )))
                            : ListView.builder(
                                itemCount: plantas.length,
                                itemBuilder: (context, index) {
                                  return ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: SizedBox(
                                        width: size.width,
                                        height: size.height <= 700
                                            ? size.height * 0.37
                                            : size.height * 0.30,
                                        child: Card(
                                          child: Column(
                                            children: [
                                              Stack(
                                                textDirection:
                                                    TextDirection.rtl,
                                                children: [
                                                  Image.network(
                                                    "https://correiodoscampos.com.br/wp-content/uploads/2017/10/006-geral-eucalipto.jpg",
                                                    width: 500,
                                                    filterQuality:
                                                        FilterQuality.high,
                                                    fit: BoxFit.fill,
                                                    height: 160,
                                                  ),
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.favorite,
                                                        color: plantas[index]
                                                                ["favorite"]
                                                            ? Colors.green
                                                            : Colors.white,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          plantas[index]
                                                                  ["favorite"] =
                                                              !plantas[index]
                                                                  ["favorite"];
                                                        });
                                                      }),
                                                ],
                                              ),
                                              ListTile(
                                                title: Text(
                                                    plantas[index]["title"]),
                                                subtitle: Text(
                                                    plantas[index]["subtitle"]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                                },
                              ))),
              ],
            ),
          );
        } else {
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
                                    "Max: 30 ºC",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  Text(
                                    "  Min: 16 ºC",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ],
                              ),
                              Text(
                                "Itapeva - SP",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Text(
                                "R\$5.65 um dólar",
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
                Text("Esse está sem conecção"),
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60)),
                    child: Container(
                        height: size.height <= 700
                            ? size.height * 0.62 + (animated ? 0 : 51)
                            : size.height * 0.7 + (animated ? 0 : 70),
                        color: Colors.white,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: pesquisa != null
                            ? Padding(
                                padding: EdgeInsets.all(20),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Card(
                                      child: Column(
                                        children: [
                                          Stack(
                                            textDirection: TextDirection.rtl,
                                            children: [
                                              Image.network(
                                                "https://correiodoscampos.com.br/wp-content/uploads/2017/10/006-geral-eucalipto.jpg",
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
                                    )))
                            : ListView.builder(
                                itemCount: plantas.length,
                                itemBuilder: (context, index) {
                                  return ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: SizedBox(
                                        width: size.width,
                                        height: size.height <= 700
                                            ? size.height * 0.37
                                            : size.height * 0.30,
                                        child: Card(
                                          child: Column(
                                            children: [
                                              Stack(
                                                textDirection:
                                                    TextDirection.rtl,
                                                children: [
                                                  Image.network(
                                                    "https://correiodoscampos.com.br/wp-content/uploads/2017/10/006-geral-eucalipto.jpg",
                                                    width: 500,
                                                    filterQuality:
                                                        FilterQuality.high,
                                                    fit: BoxFit.fill,
                                                    height: 160,
                                                  ),
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.favorite,
                                                        color: plantas[index]
                                                                ["favorite"]
                                                            ? Colors.green
                                                            : Colors.white,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          plantas[index]
                                                                  ["favorite"] =
                                                              !plantas[index]
                                                                  ["favorite"];
                                                        });
                                                      }),
                                                ],
                                              ),
                                              ListTile(
                                                title: Text(
                                                    plantas[index]["title"]),
                                                subtitle: Text(
                                                    plantas[index]["subtitle"]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                                },
                              ))),
              ],
            ),
          );
        }
      },
      future: datas(),
    ));
  }
}

/*FutureBuilder(
        future: Future(datas),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
                child: Column(children: [
              
              
              
            ]));
          } else if (snapshot.hasError) {
            return Center(child: CircularProgressIndicator());
          }
        });*/
