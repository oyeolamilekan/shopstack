import 'package:bloc/bloc.dart';
import 'package:shopstack/blocs/productClicked/events/product_event.dart';
import 'package:shopstack/blocs/productClicked/states/product_state.dart';

class ProductsBloc extends Bloc<ProductsClickedEvent, ProductClickedState> {
  @override
  get initialState => ProductClickedState.initial();

  @override
  Stream<ProductClickedState> mapEventToState(event) async*{
    final newState = ProductClickedState(currentState);
    if (event is FetchProductLoading) {
      newState.state = ProductClickedLoadingState.loading;
      yield newState;
    }
    if (event is FetchProductFailed){
      newState.state = ProductClickedLoadingState.error;
      yield newState;
    }
    if (event is FetchProductSuccess) {
      newState.state = ProductClickedLoadingState.none;
      newState.products = event.products;
      yield newState;
    }
  }
}
