import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopstack/auth/actions.dart';
import 'package:shopstack/blocs/chartsbloc/blocs/charts_bloc.dart';
import 'package:shopstack/blocs/chartsbloc/models/charts_data.dart';
import 'dart:io';

import 'package:shopstack/const/urls.dart';

abstract class ChartsEvent {}

class FetchAnalytics extends ChartsEvent {

  FetchAnalytics(ChartsBloc bloc) {
    fetch(bloc);
  }
  void fetch(ChartsBloc bloc) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String shopSlug = prefs.getString('shopSlug');
    try {
      String authToken = await getUserToken();

      Map<String, String> headers = {
        "Content-type": "application/json",
        HttpHeaders.authorizationHeader: 'Token $authToken'
      };
      String _chartsDataUrl = '$urlHost/api/get_shop_view/';
      bloc.dispatch(FetchAnalyticsLoading());
      final response = await http.get(_chartsDataUrl, headers: headers);
      if (response.statusCode == 200) {
        Map decodedItems = json.decode(response.body);
        final analytics = Analytics.fromJson(decodedItems);
        bloc.dispatch(FetchAnalyticsSuccess(analytics));
      } else {
        bloc.dispatch(FetchAnalyticsFailed());
      }
    } catch (e) {
      bloc.dispatch(FetchAnalyticsFailed());
    }
  }
}

class FetchAnalyticsLoading extends ChartsEvent {}

class FetchAnalyticsFailed extends ChartsEvent {}

class FetchAnalyticsSuccess extends ChartsEvent {
  Analytics analytics;
  FetchAnalyticsSuccess(this.analytics);

  @override
  String toString() {
    return 'FetchAnalyticsSuccess';
  }
}
