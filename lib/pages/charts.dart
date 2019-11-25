import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:shopstack/blocs/chartsbloc/models/charts_data.dart';
import 'package:shopstack/utils/utils.dart';

class Charts extends StatefulWidget {
  final Widget child;
  final data;

  Charts({Key key, this.child, this.data}) : super(key: key);

  _ChartsState createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {

  List<charts.Series<LinearClicks, String>> _seriesLineData;
  _generateData() {
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(hexToColor("#000000")),
        id: 'Page Views',
        data: widget.data,
        domainFn: (LinearClicks data, _) => data.day,
        measureFn: (LinearClicks data, _) => data.clicks,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _seriesLineData = List<charts.Series<LinearClicks, String>>();
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 5,),
            Text(
              'Activites for the last 4 days.',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Expanded(
              child: charts.BarChart(_seriesLineData,
                  
                  animate: true,
                  animationDuration: Duration(seconds: 3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}