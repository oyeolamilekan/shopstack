import 'package:shopstack/blocs/chartsbloc/models/charts_data.dart';

enum LoadingState { none, loading, error }

class AnalyticState {
  Analytics analytics = Analytics(dataSet: [], daySet: []);


  LoadingState state = LoadingState.loading;
  
  AnalyticState.initial();

  AnalyticState(AnalyticState currentState){
    this.analytics = currentState.analytics;
    this.state = currentState.state;
  }
}
