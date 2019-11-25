import 'package:shopstack/blocs/productBloc/models/product_models.dart';

enum ProductLoadingState { none, loading, error }

class ProductState {
  Product products = Product();


  ProductLoadingState state = ProductLoadingState.loading;
  
  ProductState.initial();

  ProductState(ProductState currentState){
    this.products = currentState.products;
    this.state = currentState.state;
  }
}
