import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopstack/blocs/chartsbloc/blocs/charts_bloc.dart';
import 'package:shopstack/blocs/chartsbloc/events/charts_events.dart';
import 'package:shopstack/blocs/chartsbloc/models/charts_data.dart';
import 'package:shopstack/blocs/chartsbloc/states/chart_state.dart';
import 'package:shopstack/blocs/productClicked/blocs/product_bloc.dart';
import 'package:shopstack/blocs/productClicked/events/product_event.dart';
import 'package:shopstack/blocs/productClicked/states/product_state.dart';
import 'package:shopstack/pages/charts.dart';
import 'package:shopstack/utils/utils.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final chartBloc = ChartsBloc();
  final productBloc = ProductsBloc();
  final fontStyleBold = TextStyle(fontWeight: FontWeight.bold);
  final bigFontSize = TextStyle(fontSize: 20.0);

  @override
  void initState() {
    super.initState();
    FetchAnalytics(chartBloc);
    FetchProductClicked(productBloc);
  }

  Future _call() async {
    FetchAnalytics(chartBloc);
    FetchProductClicked(productBloc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: _call,
      child: Center(
        child: ListView(
          children: <Widget>[
            pageViewsContainer(),
            buildProductClicked(),
          ],
        ),
      ),
    ));
  }

  Widget pageViewsContainer() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Page Views',
              style: fontStyleBold,
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 3.1,
              child: BlocBuilder<ChartsBloc, AnalyticState>(
                bloc: chartBloc,
                builder: (BuildContext context, AnalyticState state) {
                  if (state.state == LoadingState.loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state.state == LoadingState.none) {
                    if (state.analytics.daySet.length > 0) {
                      /// Create an empty data set
                      List<LinearClicks> _dataCell = [];

                      /// Append the data into `@[_dataCell]` variable
                      state.analytics.dataSet.asMap().forEach((index, value) {
                        _dataCell.add(new LinearClicks(
                            state.analytics.daySet[index], value));
                      });

                      /// Render the Chart
                      return Charts(
                        data: _dataCell,
                      );
                    } else {
                      return Center(
                        child: Text('No data', style: bigFontSize),
                      );
                    }
                  }
                  return Center(child: Text('Error loading'),);
                },
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: Colors.blueAccent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 1.0,
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }

  Container buildProductClicked() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Products Clicked',
              style: fontStyleBold,
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 3.1,
              child: BlocBuilder<ProductsBloc, ProductClickedState>(
                bloc: productBloc,
                builder: (BuildContext context, ProductClickedState state) {
                  if (state.state == ProductClickedLoadingState.loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state.state == ProductClickedLoadingState.none) {
                    if (state.products.length == 0) {
                      return Center(child: Text('No data', style: bigFontSize));
                    }
                    return ListView.builder(
                      itemCount: state.products.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(state.products[index].name),
                        );
                      },
                    );
                  }
                  return Center(child: Text('Error loading'),);
                },
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: hexToColor('#e5e7f1'),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 1.0,
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
