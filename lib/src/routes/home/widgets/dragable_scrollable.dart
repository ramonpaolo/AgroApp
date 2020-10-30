import 'package:flutter/material.dart';

class DraggableScrollable extends StatefulWidget {
  DraggableScrollable({Key key, this.order}) : super(key: key);
  final Object order;
  @override
  _DraggableScrollableState createState() => _DraggableScrollableState();
}

class _DraggableScrollableState extends State<DraggableScrollable> {
  Object order;

  @override
  void initState() {
    print("---------- Dragable_scrollable.dart----------");
    order = widget.order;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height <= 700 ? size.height * 0.55 : size.height * 0.6,
      child: DraggableScrollableSheet(
        expand: false,
        minChildSize: 0.15,
        maxChildSize: 0.45,
        initialChildSize: 0.15,
        builder: (context, scrollController) {
          return AnimatedBuilder(
              animation: scrollController,
              builder: (context, child) {
                return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              width: 24,
                              height: 8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.green),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                child: Column(
                                  children: [
                                    Text("Selecionar Ordem"),
                                    ListTile(
                                        title: Text("Ordenar por nome"),
                                        trailing: Radio(
                                            value: "nome",
                                            groupValue: order,
                                            activeColor: Colors.green,
                                            onChanged: (value) {
                                              print(value);
                                              setState(() {
                                                order = value;
                                              });
                                            })),
                                    ListTile(
                                        title: Text("Ordenar por preço"),
                                        trailing: Radio(
                                            value: "preco",
                                            groupValue: order,
                                            activeColor: Colors.green,
                                            onChanged: (value) {
                                              print(value);
                                              setState(() {
                                                order = value;
                                              });
                                            })),
                                    ListTile(
                                        title: Text("Nenhum"),
                                        trailing: Radio(
                                            value: "none",
                                            groupValue: order,
                                            activeColor: Colors.green,
                                            onChanged: (value) {
                                              print(value);
                                              setState(() {
                                                order = value;
                                              });
                                            })),
                                  ],
                                ))
                          ],
                        )));
              });
        },
      ),
    );
  }
}
