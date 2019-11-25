import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopstack/const/urls.dart';

Future authLoginUser(email, password) async {
  /// Log in the user by geting there atro_id and password
  /// and set the token in memory if the authentication is successful
  try {
    Map<String, String> headers = {"Content-type": "application/json"};
    Map data = {"email": email, "password": password};
    String payload = json.encode(data);
    String url = '$urlHost/api/login/';
    Response response = await post(url, headers: headers, body: payload);
    Map jsonData = jsonDecode(response.body);
    bool loginError = jsonData.containsKey('non_field_errors');
    bool tokenSucces = jsonData.containsKey('token');
    String token = jsonData['token'];

    if (tokenSucces) {
      createToken(token, email, jsonData['shop_slug']);

    }

    Map<String, dynamic> successMsg = {
      'msg': 'Succesful login',
      'status': true
    };

    Map<String, dynamic> failedMsg = {
      'msg': 'Unsuccessful login, kindly check your credentials.',
      'status': false
    };
    return loginError ? failedMsg : tokenSucces ? successMsg : false;
  } on SocketException {
    Map<String, dynamic> failedMsg = {
      'msg':
          'Oops can not connect to server, kindly check your internet connection.',
      'status': false
    };
    return failedMsg;
  } catch (e) {
    Map<String, dynamic> failedMsg = {
      'msg': 'Unsuccessful login, unknown error.',
      'status': false
    };
    return failedMsg;
  }
}

authSignUpUser(email, name, password) async {
  /// Sign up new user with the credentials and save the token
  /// in to the local storage, and get the item needed to do authentication
  try {
    Map data = {
      "email": email.trim(),
      "name": name.trim(),
      "password": password,
      "is_commerce": true
    };
    String payload = json.encode(data);
    String url = '$urlHost/api/register/';
    Map<String, String> headers = {"Content-type": "application/json"};
    Response response = await post(url, headers: headers, body: payload);
    Map jsonData = jsonDecode(response.body);
    var msg = jsonData.containsKey('token')
        ? 'success'
        : jsonData.containsKey('email') ? jsonData['email'] : "";
    Map<String, dynamic> respData = {
      'msg': msg.toString().replaceAll('[', '').replaceAll(']', ''),
      'success': msg.toString() == 'success'
    };
    if (jsonData.containsKey('token')) {
      createToken(jsonData['token'], email, jsonData['shop_slug']);
    }
    return respData;
  } on SocketException {
    Map<String, dynamic> respData = {
      'msg':
          'Oops can not connect to server, kindly check your internet connection.',
      'success': false
    };
    return respData;
  } catch (e) {
    Map<String, dynamic> respData = {
      'msg': 'Unknown Error, Kindly check your internet connection.',
      'success': false
    };
    return respData;
  }
}

createShop(shopName, phoneNumber, shopCategory) async {
  /// Log in the user by geting there atro_id and password
  /// and set the token in memory if the authentication is successful
  try {
    String authToken = await getUserToken();

    Map<String, String> headers = {
      "Content-type": "application/json",
      HttpHeaders.authorizationHeader: 'Token $authToken'
    };
    Map data = {
      "shopName": shopName,
      "phoneNumber": phoneNumber,
      "shopCategory": shopCategory
    };
    String payload = json.encode(data);
    String url = '$urlHost/api/create_shop/';
    Response response = await post(url, headers: headers, body: payload);
    Map jsonData = jsonDecode(response.body);
    if (!jsonData['is_exist']) {
      createShopSlug(jsonData['slug']);
    }
    return jsonData;
  } catch (e) {}
}

createShopSlug(slug) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('shopSlug', slug);
}

getShopSlug() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('shopSlug');
}

clearAuthInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

createToken(token, username, shopSlug) async {
  /// Set token of the auth user in phone memory
  /// In other authenticate them, when making request.

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('token', token);
  prefs.setString('user_name', username);
  prefs.setString('shopSlug', shopSlug);
  prefs.setBool('is_auth', true);
}

editProfile(phoneNumber, address, description, storeLogo) async {
  try {
    String authToken = await getUserToken();
    String url = "$urlHost/api/save_info/";
    var uri = Uri.parse(url);
    var request = new MultipartRequest("PUT", uri);
    request.headers['authorization'] = 'Token $authToken';
    request.fields['phoneNumber'] = phoneNumber;
    request.fields['description'] = description;
    request.fields['address'] = address;
    if (storeLogo != null) {
      var stream = new ByteStream(DelegatingStream.typed(storeLogo.openRead()));
      var length = await storeLogo.length();
      var multipartFile = new MultipartFile('logo', stream, length,
          filename: basename(storeLogo.path));
      request.files.add(multipartFile);
    } else {
      request.fields['logo'] = '';
    }
    var response = await request.send();
    return response;
  } catch (e) {
    print('hello');
  }
}

getInitialProfileData() async {
  try {
    String authToken = await getUserToken();
    String url = '$urlHost/api/get_info/';
    Map<String, String> headers = {
      "Content-type": "application/json",
      HttpHeaders.authorizationHeader: 'Token $authToken'
    };
    var response = await get(url, headers: headers);
    return jsonDecode(response.body);
  } catch (e) {
    return {'msg':'Error'};
  }
}

authChangePassword(oldPassword, newPassword) async {
  try {
    String authToken = await getUserToken();
    String url = '$urlHost/api/change_password/';
    var uri = Uri.parse(url);
    var request = new MultipartRequest("PUT", uri);
    request.headers['authorization'] = 'Token $authToken';
    request.fields['old_password'] = oldPassword;
    request.fields['new_password'] = newPassword;
    var response = await request.send();
    return response.statusCode;
  } catch (e) {
    return 401;
  }
}

getUserToken() async {
  /// Get user name from pref
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}
