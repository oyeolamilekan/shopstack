import 'package:bloc/bloc.dart';
import 'package:shopstack/blocs/deleteBloc/events/delete_events.dart';
import 'package:shopstack/blocs/deleteBloc/states/delete_state.dart';

class DeleteBloc extends Bloc<DeleteEvent, DeleteProductState> {
  @override
  DeleteProductState get initialState => DeleteProductState.initial();

  @override
  Stream<DeleteProductState> mapEventToState(DeleteEvent event) async* {
    final newState = DeleteProductState(currentState);
    if (event is DeleteProductLoading) {
      newState.state = DeleteProductLoadingState.loading;
      yield newState;
    }
    if (event is DeleteProductFailed) {
      newState.state = DeleteProductLoadingState.error;
      yield newState;
    }
    if (event is DeleteProductSuccess){
      newState.state = DeleteProductLoadingState.success;
      yield newState;
    }
  }
}