import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  

  getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userName = prefs.getString('user_name');
    return userName;
  }
}