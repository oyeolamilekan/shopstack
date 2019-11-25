import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shopstack/auth/actions.dart';
import 'package:shopstack/const/urls.dart';
import 'package:async/async.dart';

Future convertTagToMap(value) async {
  try {
    var shopTag = await getShopTags();
    return shopTag.firstWhere((tag) => tag["name"] == value);
  } catch (e) {
    return [];
  }
}

createProduct(productName, productPrice, productCat, productDescription,
    productImage, fileNamePlaceHolder) async {
  try {
    var tags = await convertTagToMap(productCat);
    String authToken = await getUserToken();

    String url = "$urlHost/api/create_product/";
    var uri = Uri.parse(url);

    var request = new http.MultipartRequest("POST", uri);
    request.headers['authorization'] = 'Token $authToken';
    request.fields['productName'] = productName;
    request.fields['productPrice'] = productPrice;
    request.fields['tags'] = jsonEncode(tags);
    request.fields['description'] = productDescription;
    if (productImage != null) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(productImage.openRead()));
      var length = await productImage.length();
      var multipartFile = new http.MultipartFile('file', stream, length,
          filename: basename(productImage.path));
      request.files.add(multipartFile);
    } else {
      request.fields['file'] = '';
    }
    var response = await request.send();
    return response;
  } catch (e) {
    print(e);
  }
}

createFeedBack(scoreValue, reason, body) async {
  try {

    String authToken = await getUserToken();
    String url = "$urlHost/api/create_feedback/";
    var uri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", uri);
    request.headers['authorization'] = 'Token $authToken';
    request.fields['score'] = scoreValue;
    request.fields['title'] = reason;
    request.fields['body'] = body;
    var response = await request.send();
    print(response.stream.toString());
    return response.statusCode;

  } catch (e) {
    return 500;
  }
}

editProduct(id, productName, productPrice, productCat, productDescription,
    productImage, fileNamePlaceHolder) async {
  try {
    var tags = await convertTagToMap(productCat);
    String authToken = await getUserToken();
    String url = "$urlHost/api/edit_products/";
    var uri = Uri.parse(url);
    var request = new http.MultipartRequest("PUT", uri);
    request.headers['authorization'] = 'Token $authToken';
    request.fields['id'] = id;
    request.fields['productName'] = productName;
    request.fields['productPrice'] = productPrice;
    request.fields['tags'] = jsonEncode(tags);
    request.fields['description'] = productDescription;
    if (productImage != null) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(productImage.openRead()));
      var length = await productImage.length();
      var multipartFile = new http.MultipartFile('file', stream, length,
          filename: basename(productImage.path));
      request.files.add(multipartFile);
    } else {
      request.fields['file'] = '';
    }
    var response = await request.send();
    return response;
  } catch (e) {
    // The request was made and the server responded with a status code

    // Something happened in setting up or sending the request that triggered an Error

    print('$e edit action');
  }
}

Future createTag(tags) async {
  try {
    String authToken = await getUserToken();
    Map<String, String> headers = {
      "Content-type": "application/json",
      HttpHeaders.authorizationHeader: 'Token $authToken'
    };
    String _createTagsUrl = '$urlHost/api/create_tags/';
    Map data = {
      "categoryName": tags
    };
    String payload = json.encode(data);
    http.Response response =
        await http.post(_createTagsUrl, headers: headers, body: payload);
    Map jsonData = jsonDecode(response.body);
    return jsonData.containsKey('name');
  } catch (e) {
    return false;
  }
}

Future getShopTags() async {
  try {
    String authToken = await getUserToken();
    Map<String, String> headers = {
      "Content-type": "application/json",
      HttpHeaders.authorizationHeader: 'Token $authToken'
    };
    String _getTagsUrl = '$urlHost/api/catergory_list/';
    http.Response response = await http.get(_getTagsUrl, headers: headers);
    Map jsonData = jsonDecode(response.body);
    return jsonData['shop_categories'];
  } catch (e) {
    return [];
  }
}

Future getTags() async {
  try {
    var shopTag = await getShopTags();
    return shopTag.map((tag) => tag['name']).toList();
  } catch (e) {
    return [];
  }
}
