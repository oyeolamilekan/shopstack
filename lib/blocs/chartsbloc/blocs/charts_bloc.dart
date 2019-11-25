import 'package:bloc/bloc.dart';
import 'package:shopstack/blocs/chartsbloc/events/charts_events.dart';
import 'package:shopstack/blocs/chartsbloc/states/chart_state.dart';

class ChartsBloc extends Bloc<ChartsEvent, AnalyticState>{
  @override
  AnalyticState get initialState => AnalyticState.initial();

  @override
  Stream<AnalyticState> mapEventToState(ChartsEvent event) async*{
    final newState = AnalyticState(currentState);
    if (event is FetchAnalyticsLoading) {
      newState.state = LoadingState.loading;
      yield newState;
    }
    if (event is FetchAnalyticsFailed){
      newState.state = LoadingState.error;
      yield newState;
    }
    if (event is FetchAnalyticsSuccess) {
      newState.state = LoadingState.none;
      newState.analytics = event.analytics;
      yield newState;
    }
  }

  @override
  void onTransition(Transition transition){
    print(transition);
  }

  @override
  void onError(Object error, StackTrace stackTrace){
    print('$error, $stackTrace b');
  }
}