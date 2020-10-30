//---- Packages
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';

class Analytics extends StatefulWidget {
  Analytics({Key key, this.data}) : super(key: key);
  final List data;
  @override
  _AnalyticsState createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  //---- Variables

  List<double> data = [];

  //---- Functions

//If all views should equal, the Spatkline happen in blank
  Future getData() async {
    try {
      for (var x = 0; x < widget.data.length; x++) {
        data.add(await widget.data[x]["views"].ceilToDouble());
      }
    } catch (e) {
      print(e);
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        width: 1000,
        height: 120,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Sparkline(
                data: data,
                fillMode: FillMode.below,
                fillColor: Colors.green[100],
                lineWidth: 3.0,
                pointsMode: PointsMode.all,
                pointSize: 8,
                pointColor: Colors.green[900],
                sharpCorners: true,
                lineColor: Colors.green,
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: LinearProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(
                "Vazio",
                style: TextStyle(color: Colors.white),
              ));
            }
          },
        ));
  }
}
