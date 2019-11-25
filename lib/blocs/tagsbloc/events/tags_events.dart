import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shopstack/auth/actions.dart';
import 'package:shopstack/blocs/tagsbloc/bloc/tags_bloc.dart';
import 'package:shopstack/blocs/tagsbloc/models/tags_models.dart';
import 'package:shopstack/const/urls.dart';

abstract class ShopTagEvent {}

class FetchTags extends ShopTagEvent {
  FetchTags(TagsBloc bloc) {
    fetch(bloc);
  }

  Future fetch(TagsBloc bloc) async {
    try {
      String authToken = await getUserToken();

      Map<String, String> headers = {
        "Content-type": "application/json",
        HttpHeaders.authorizationHeader: 'Token $authToken'
      };

      String _tagsDataUrl = '$urlHost/api/catergory_list/';
      bloc.dispatch(FetchTagsLoading());
      final response = await http.get(_tagsDataUrl, headers: headers);
      if (response.statusCode == 200) {
        Map<String, dynamic> decodedItems = json.decode(response.body);
        final tags = List.from(decodedItems['shop_categories'])
            .map((json) => ShopTags.fromJson(json))
            .toList();
        bloc.dispatch(FetchTagsSuccess(tags));
      } else {
        bloc.dispatch(FetchTagsFailed());
      }
    } catch (e) {
      bloc.dispatch(FetchTagsFailed());
    }
  }
}

class FetchTagsLoading extends ShopTagEvent {}

class FetchTagsFailed extends ShopTagEvent {}

class FetchTagsSuccess extends ShopTagEvent {
  List<ShopTags> tags;
  FetchTagsSuccess(this.tags);
}
