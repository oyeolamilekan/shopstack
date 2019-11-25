// enum DeleteEvent { success, failed, loading, initialized }
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shopstack/auth/actions.dart';
import 'package:shopstack/blocs/deleteBloc/bloc/delete_bloc.dart';
import 'package:shopstack/const/urls.dart';

abstract class DeleteEvent {}

class DeleteProduct extends DeleteEvent {
  DeleteProduct(DeleteBloc bloc, String id) {
    delete(bloc, id);
  }

  void delete(DeleteBloc bloc, String id) async {
    try {
      String authToken = await getUserToken();
      String _deleteUrl = '$urlHost/api/delete_products/$id/';
      Map<String, String> headers = {
        "Content-type": "application/json",
        HttpHeaders.authorizationHeader: 'Token $authToken'
      };
      bloc.dispatch(DeleteProductLoading());
      final response = await http.delete(_deleteUrl, headers: headers);
      if (response.statusCode == 200) {
        bloc.dispatch(DeleteProductSuccess());
      } else {
        bloc.dispatch(DeleteProductFailed());
      }
    } catch (e) {
      bloc.dispatch(DeleteProductFailed());
    }
  }
}

class DeleteProductFailed extends DeleteEvent {}

class DeleteProductLoading extends DeleteEvent {}

class DeleteProductSuccess extends DeleteEvent {}
