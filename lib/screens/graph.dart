
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
//import 'package:syncfusion_flutter_charts/sparkcharts.dart'

class _SalesData {
  _SalesData(this.date, this.sales);

  String date;
  double sales;
}

class GraphPage extends StatefulWidget {
  final List data;

  GraphPage({Key key, this.data}) : super(key: key);

  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  List<String> labelx = [];
  List<_SalesData> data = [];

  @override
  void initState() {
    this.getData();
    super.initState();
  }

  getData() {
    widget.data.forEach((element) {
      var date = element['date'];
      DateTime parseDate = new DateFormat("yyyy-MM-dd").parse(date);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat('dd/MM/yyyy');
      var outputDate = outputFormat.format(inputDate);

      if (!labelx.contains(outputDate)) {
        labelx.add(outputDate);
        _SalesData newData =
            _SalesData(outputDate, element['weight'].toDouble());
        data.add(newData);
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
      ),
      body: Center(
        child: Container(
          child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              title: ChartTitle(text: 'Weight history'),
              legend: Legend(isVisible: true),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<_SalesData, String>>[
                LineSeries<_SalesData, String>(
                    dataSource: data,
                    xValueMapper: (_SalesData sales, _) => sales.date,
                    yValueMapper: (_SalesData sales, _) => sales.sales,
                    name: 'Weight',
                    color: Color.fromRGBO(82, 183, 136, 1),
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true))
              ]),
        ),
      ),
    );
  }
}
