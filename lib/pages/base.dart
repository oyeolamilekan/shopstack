import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopstack/auth/actions.dart';
import 'package:shopstack/pages/index.dart';
import 'package:shopstack/globals.dart';
import 'package:shopstack/pages/products/products.dart';
import 'package:shopstack/pages/tags/tags.dart';
import 'package:shopstack/utils/utils.dart';

class Base extends StatefulWidget {
  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<Base> with SingleTickerProviderStateMixin {
  TabController navBarController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // ! Fix this bro
      userName = prefs.getString('user_name');
    });
  }

  @override
  void initState() {
    navBarController = new TabController(length: 3, vsync: this);
    getUserName();
    super.initState();
  }

  @override
  void dispose() {
    navBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.supervised_user_circle),
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notification');
            },
          ),
          SizedBox(
            width: 10.0,
          )
        ],
      ),
      body: TabBarView(
        children: <Widget>[IndexPage(), Tags(), Product()],
        controller: navBarController,
      ),
      bottomNavigationBar: Material(
        textStyle: TextStyle(color: Colors.black),
        child: new TabBar(
            indicatorColor: Colors.black,
            controller: navBarController,
            tabs: <Tab>[
              new Tab(
                  icon: new Icon(
                Icons.home,
                color: Colors.black,
              )),
              new Tab(icon: Icon(Icons.track_changes, color: Colors.black)),
              new Tab(icon: Icon(Icons.shop, color: Colors.black)),
            ]),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
                accountName: Text(''),
                accountEmail: Text('$userName'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                )),
            ListTile(
              title: Text('Edit Profile'),
              leading: Icon(FontAwesomeIcons.edit),
              onTap: () {
                Navigator.pushNamed(context, "/edit");
              },
            ),
            Divider(),
            ListTile(
              title: Text('GO TO STORE'),
              leading: Icon(FontAwesomeIcons.shopware),
              onTap: () async {
                var shopSlug = await getShopSlug();
                launchURL('https://$shopSlug.shopstack.co');
              },
            ),
            Divider(),
            ListTile(
              title: Text('SEND FEEDBACK'),
              leading: Icon(FontAwesomeIcons.comment),
              onTap: () {
                Navigator.pushNamed(context, "/feedback");
              },
            ),
            Divider(),
            ListTile(
              title: Text('Log out'),
              leading: Icon(Icons.keyboard_return),
              onTap: () {
                Navigator.pushNamed(context, '/logout');
              },
            ),
            Divider(),
            ListTile(
              title: Text('Change Password'),
              leading: Icon(Icons.vpn_key),
              onTap: () {
                Navigator.pushNamed(context, "/changePassword");
              },
            ),
          ],
        ),
      ),
    );
  }
}
