//---- Packages
import 'package:flutter/material.dart';

//---- Datas
import 'package:agricultura/src/data/home.dart';

class Store extends StatefulWidget {
  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  //---- Variables

  var key = GlobalKey<ScaffoldState>();
  TextEditingController _searchController = TextEditingController();
  Map planta;
  bool animated = true;
  double height = 76.0;

  //---- Functions

  Future search(search) async {
    for (var x = 0; x <= plantas.length; x++) {
      if (search == plantas[x]["name"]) {
        print("'Chat.dart': Esse mesmo: $search");
        setState(() {
          planta["name"] = plantas[x]["name"];
          planta["mensagen"] = plantas[x]["mensagen"];
          planta["image"] = plantas[x]["image"];
        });
        return planta;
      } else if (x == plantas.length) {
        print("Não tem : (");
        return search;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.green,
        key: key,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 40, left: 20, right: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Colors.green,
                              ),
                              tooltip: "Search",
                              onPressed: () {
                                setState(() {
                                  animated = !animated;
                                });
                                if (animated == true) {
                                  setState(() {
                                    height = 70;
                                  });
                                } else {
                                  setState(() {
                                    height = 0;
                                  });
                                }
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: Colors.green,
                              ),
                              tooltip: "Favorite",
                              onPressed: () {
                                plantas.forEach((element) {
                                  if (element["checbox"] == true) {
                                    setState(() {
                                      element["favorite"] =
                                          !element["favorite"];
                                    });
                                  }
                                });
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Colors.green,
                              ),
                              tooltip: "Clear",
                              onPressed: () {
                                plantas.removeWhere(
                                    (element) => element["checbox"] == true);
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.select_all,
                                color: Colors.green,
                              ),
                              tooltip: "Select all",
                              onPressed: () {
                                plantas.forEach((element) {
                                  if (element["checbox"] == false) {
                                    setState(() {
                                      element["checbox"] = true;
                                    });
                                  } else {
                                    setState(() {
                                      element["checbox"] = false;
                                    });
                                  }
                                });
                              }),
                        ],
                      ),
                    ),
                  )),
              AnimatedCrossFade(
                  firstChild: Text(""),
                  secondChild: Padding(
                    padding: EdgeInsets.only(
                        top: 20, bottom: 20, left: 30, right: 30),
                    child: ClipRRect(
                      child: Container(
                        color: Colors.white,
                        child: TextField(
                          cursorColor: Colors.green[900],
                          controller: _searchController,
                          onChanged: (value) {
                            search(_searchController.text);
                          },
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Pesquise aqui...",
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.green,
                              ),
                              suffixIcon: Icon(
                                Icons.clear,
                                color: Colors.green,
                              )),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  crossFadeState: animated
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: Duration(milliseconds: 500)),
              ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60)),
                  child: Container(
                    color: Colors.white,
                    width: 1000,
                    height: size.height <= 700
                        ? size.height * 0.65 + height
                        : size.height * 0.714 + height,
                    child: Column(children: [
                      Container(
                        width: 1000,
                        height: size.height <= 700
                            ? size.height * 0.55 + height
                            : size.height * 0.64 + height,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 40),
                          child: ListView.builder(
                              itemCount: plantas.length,
                              itemBuilder: (context, index) {
                                return Dismissible(
                                    onDismissed: (direction) {
                                      plantas.remove(plantas[index]);
                                      key.currentState.showSnackBar(SnackBar(
                                        content: Text(
                                          "Excluido o produto: ${plantas[index]["title"]}",
                                          style: TextStyle(color: Colors.green),
                                        ),
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Colors.white,
                                      ));
                                    },
                                    background: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                          color: Colors.red,
                                          child: Align(
                                            alignment: Alignment(-0.5, 0),
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                          )),
                                    ),
                                    direction: DismissDirection.startToEnd,
                                    key: Key(DateTime.now().toString()),
                                    child: CheckboxListTile(
                                        subtitle: IconButton(
                                            icon: Icon(Icons.favorite,
                                                color: plantas[index]
                                                        ["favorite"]
                                                    ? Colors.green
                                                    : Colors.black),
                                            onPressed: () {
                                              setState(() {
                                                plantas[index]["favorite"] =
                                                    !plantas[index]["favorite"];
                                              });
                                            }),
                                        contentPadding: EdgeInsets.all(10),
                                        title: Text(plantas[index]["title"]),
                                        secondary: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child:
                                                Image.asset("assets/eu.jpg")),
                                        key: Key(DateTime.now().toString()),
                                        value: plantas[index]["checbox"],
                                        checkColor: Colors.white,
                                        activeColor: Colors.green,
                                        onChanged: (v) {
                                          setState(() {
                                            plantas[index]["checbox"] = v;
                                          });
                                        }));
                              }),
                        ),
                      ),
                      SizedBox(
                          width: 400,
                          height: 50,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: RaisedButton(
                                splashColor: Colors.white,
                                onLongPress: () {
                                  Tooltip(message: "ó");
                                },
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (c) {
                                        return Container(
                                            child: Text("Terminar aki"));
                                      });
                                },
                                color: Colors.green,
                                child: Text(
                                  "Finalizar Compra",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ))),
                    ]),
                  )),
            ],
          ),
        ));
  }
}
