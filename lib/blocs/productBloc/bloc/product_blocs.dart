import 'package:bloc/bloc.dart';
import 'package:shopstack/blocs/productBloc/events/product_events.dart';
import 'package:shopstack/blocs/productBloc/states/product_state.dart';

class ProductBloc extends Bloc<ProductsEvent, ProductState> {
  @override
  get initialState => ProductState.initial();

  @override
  Stream<ProductState> mapEventToState(event) async* {
    final newState = ProductState(currentState);
    if (event is FetchProductsLoading) {
      newState.state = ProductLoadingState.loading;
      yield newState;
    }
    if (event is FetchProductsFailed) {
      newState.state = ProductLoadingState.error;
      yield newState;
    }
    if (event is FetchProductsSuccess) {
      newState.state = ProductLoadingState.none;
      newState.products = event.products;
      yield newState;
    }

    if (event is FetchProductsNextSuccess) {
      newState.state = ProductLoadingState.none;
      newState.products = event.newProducts;
      yield newState;
    }
  }
}
