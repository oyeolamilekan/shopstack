import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopstack/auth/changePassword.dart';
import 'package:shopstack/auth/createStore.dart';
import 'package:shopstack/auth/logout.dart';
import 'package:shopstack/auth/signup.dart';
import 'package:shopstack/pages/base.dart';
import 'package:shopstack/pages/edit.dart';
import 'package:shopstack/pages/feedback/feedback.dart';
import 'package:shopstack/pages/notification.dart';
import 'package:shopstack/pages/products/createProduct.dart';
import 'package:shopstack/pages/products/editProduct.dart';
import 'package:shopstack/pages/products/productDetail.dart';
import 'package:shopstack/pages/spashPage.dart';
import 'package:shopstack/pages/tags/createTags.dart';
import 'package:shopstack/pages/tags/tags.dart';

import 'auth/signin.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static int _blackPrimaryValue = 0xFF000000;
  MaterialColor primaryBlack = MaterialColor(
    _blackPrimaryValue,
    <int, Color>{
      50: Color(0xFF000000),
      100: Color(0xFF000000),
      200: Color(0xFF000000),
      300: Color(0xFF000000),
      400: Color(0xFF000000),
      500: Color(_blackPrimaryValue),
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    },
  );

  bool isAuth = false;

  bool showSpashPage = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopstack',
      debugShowCheckedModeBanner: false,
      routes: {
        "/logout": (_) => Logout(),
        "/login": (_) => LoginPage(),
        "/signup": (_) => SignUpPage(),
        "/changePassword": (_) => ChangePassword(),
        "/edit": (_) => Edit(),
        "/index": (_) => Base(),
        "/feedback":(_) => FeedBack(),
        "/createTags": (_) => CreateTags(),
        "/tags": (_) => Tags(),
        "/editProduct": (_) => EditProduct(),
        "/createStore": (_) => CreateStore(),
        "/createProduct": (_) => CreateProduct(),
        "/productDetail": (_) => ProductDetail(),
        "/notification": (_) => Notifications(),
      },
      theme: ThemeData(
        fontFamily: 'Nunito Sans',
        primarySwatch: primaryBlack,
      ),
      home: showSpashPage ? SpashPage() : isAuth ? Base() : LoginPage(),
    );
  }

  @override
  void initState() {
    _checkIfUserIsAuthenticated();
    super.initState();
  }

  _checkIfUserIsAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isAuthPref = prefs.getBool('is_auth');
    if (isAuthPref != null) {
      setState(() {
        isAuth = true;
        showSpashPage = false;
      });
    } else {
      setState(() {
        isAuth = false;
        showSpashPage = false;
      });
    }
  }
}
