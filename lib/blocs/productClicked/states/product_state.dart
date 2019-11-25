
import 'package:shopstack/blocs/productClicked/models/product_model.dart';

enum ProductClickedLoadingState { none, loading, error }

class ProductClickedState {
  List<ProductClicked> products = [];


  ProductClickedLoadingState state = ProductClickedLoadingState.loading;
  
  ProductClickedState.initial();

  ProductClickedState(ProductClickedState currentState){
    this.products = currentState.products;
    this.state = currentState.state;
  }
}
