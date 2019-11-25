import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shopstack/auth/actions.dart';
import 'package:shopstack/blocs/productClicked/blocs/product_bloc.dart';
import 'package:shopstack/blocs/productClicked/models/product_model.dart';
import 'package:shopstack/const/urls.dart';

abstract class ProductsClickedEvent {}

class FetchProductClicked extends ProductsClickedEvent {

  FetchProductClicked(ProductsBloc bloc) {
    fetch(bloc);
  }

  Future fetch(ProductsBloc bloc) async {
    try {
      String authToken = await getUserToken();

      Map<String, String> headers = {
        "Content-type": "application/json",
        HttpHeaders.authorizationHeader: 'Token $authToken'
      };
      String _productDataUrl = '$urlHost/api/get_products_clicked/';
      bloc.dispatch(FetchProductLoading());
      final response = await http.get(_productDataUrl, headers: headers);
      if (response.statusCode == 200) {
        List decodedItems = json.decode(response.body);
        final products = List.from(decodedItems)
            .map((json) => ProductClicked.fromJson(json))
            .toList();
        bloc.dispatch(FetchProductSuccess(products));
      } else {
        bloc.dispatch(FetchProductFailed());
      }
    } catch (e) {
      bloc.dispatch(FetchProductFailed());
    }
  }
}

class FetchProductLoading extends ProductsClickedEvent {}

class FetchProductFailed extends ProductsClickedEvent {}

class FetchProductSuccess extends ProductsClickedEvent {
  List<ProductClicked> products;
  FetchProductSuccess(this.products);
}
