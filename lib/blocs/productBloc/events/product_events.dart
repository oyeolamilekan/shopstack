import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shopstack/auth/actions.dart';
import 'package:shopstack/blocs/productBloc/bloc/product_blocs.dart';
import 'package:shopstack/blocs/productBloc/models/product_models.dart';
import 'package:shopstack/const/urls.dart';

String nextUrl;
Product products;

class FetchProducts extends ProductsEvent {
  FetchProducts(ProductBloc bloc) {
    fetch(bloc);
  }

  void fetch(ProductBloc bloc) async {
    try {
      String authToken = await getUserToken();

      Map<String, String> headers = {
        "Content-type": "application/json",
        HttpHeaders.authorizationHeader: 'Token $authToken'
      };
      String _productsDataUrl = '$urlHost/api/shop_products/';
      bloc.dispatch(FetchProductsLoading());
      final response = await http.get(_productsDataUrl, headers: headers);
      if (response.statusCode == 200) {
        Map decodedItems = json.decode(response.body);
        products = Product.fromJson(decodedItems);
        if (products.next != null) {
          nextUrl = products.next;
        }
        bloc.dispatch(FetchProductsSuccess(products));
      } else {
        bloc.dispatch(FetchProductsFailed());
      }
    } catch (e) {
      print(e);
    }
  }
}

class FetchProductsFailed extends ProductsEvent {}

class FetchProductsLoading extends ProductsEvent {}

class FetchProductsSuccess extends ProductsEvent {
  Product products;
  FetchProductsSuccess(this.products);

  @override
  String toString() {
    return 'FetchProductsSuccess';
  }
}

class FetchProductsNext extends ProductsEvent {
  FetchProductsNext(ProductBloc bloc) {
    fetch(bloc);
  }

  fetch(ProductBloc bloc) async{
    try {
      String authToken = await getUserToken();

      Map<String, String> headers = {
        "Content-type": "application/json",
        HttpHeaders.authorizationHeader: 'Token $authToken'
      };
      String _productsDataUrl = '$nextUrl';
      if (nextUrl != null) {
        final response = await http.get(_productsDataUrl, headers: headers);
        if (response.statusCode == 200) {
          Map decodedItems = json.decode(response.body);
          Product newProducts = Product.fromJson(decodedItems);
          nextUrl = newProducts.next;
          products.next = newProducts.next;
          products.results.addAll(newProducts.results);
          bloc.dispatch(FetchProductsNextSuccess(products));
        } else {
          bloc.dispatch(FetchProductsFailed());
        }
      }
    } catch (e) {
      print(e);
    }
  }
}

class FetchProductsNextSuccess extends ProductsEvent {
  Product newProducts;
  FetchProductsNextSuccess(this.newProducts);

  @override
  String toString() {
    return 'FetchProductsNextSuccess';
  }
}

abstract class ProductsEvent {}
