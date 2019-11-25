import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopstack/auth/actions.dart';
import 'package:shopstack/globals.dart';

class Logout extends StatefulWidget {
  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // ! Fix this bro
      userName = prefs.getString('user_name');
    });
  }

  @override
  void initState() {
    getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget sizedBox = SizedBox(
      height: 10.0,
    );

    Widget userNameWidget = Container(
      child: Text('Hello $userName'),
    );

    Widget logoutButton = RaisedButton(
      child: Text(
        'Logout',
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.black,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Logout?"),
              content: new Text("Are you sure you want to log out?"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Logout"),
                  onPressed: () async {
                    clearAuthInfo();
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ],
            );
          },
        );
      },
    );

    Widget logoutWidget = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[userNameWidget, sizedBox, logoutButton],
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('Logout'),
          centerTitle: true,
        ),
        body: logoutWidget);
  }
}
