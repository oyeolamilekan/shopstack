import 'package:flutter/material.dart' as prefix0;
import 'package:shopstack/auth/actions.dart';
import 'package:shopstack/auth/signup.dart';
import 'package:shopstack/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shopstack/widgets/modal.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _astroId = TextEditingController();
  final _password = TextEditingController();

  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    Color color = hexToColor('#000000');
    Color whiteColor = hexToColor('#ffffff');

    Modal modal = Modal();

    Widget appLogo = SizedBox(
      height: 100.0,
      child: new Image.asset('img/logo.png'),
    );

    Widget userNameField = TextFormField(
      // This handles the email field of the for the application
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "Username",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0), borderSide: BorderSide()),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Colors.black)),
      ),
      enabled: _sending ? false : true,
      keyboardType: TextInputType.emailAddress,
      controller: _astroId,
      validator: (value) {
        if (value.isEmpty) {
          return 'Kindly type your astro id.';
        }
        return null;
      },
    );

    Widget passwordField = TextFormField(
      // This field handles the password field
      obscureText: true,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          hintText: "Password",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.0),
              borderSide: BorderSide()),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.black))),
      keyboardType: TextInputType.text,
      controller: _password,
      enabled: _sending ? false : true,
      validator: (value) {
        if (value.isEmpty) {
          return 'Kindly Type Your password.';
        }
        return null;
      },
    );

    Widget loadingObject = SizedBox(
        child: CircularProgressIndicator(
            backgroundColor: whiteColor, strokeWidth: 2.0),
        width: 20.0,
        height: 20.0);

    Widget buttonSumbit = ClipRRect(
        borderRadius: BorderRadius.circular(3.0),
        child: Container(
            height: 40.0,
            width: MediaQuery.of(context).size.width,
            child: RaisedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate() && !_sending) {
                    setState(() {
                      _sending = true;
                    });

                    var data =
                        await authLoginUser(_astroId.text, _password.text);

                    if (!data['status']) {
                      setState(() {
                        _sending = false;
                      });
                      // Find the Scaffold in the widget tree and use
                      // it to show a SnackBar.
                      modal.mainBottomSheet(
                          context, data['msg'], Icons.error_outline);
                    } else if (data['status']) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/index', (Route<dynamic> route) => false);
                    }
                  }
                },
                color: color,
                child: _sending == true
                    ? loadingObject
                    : Text(
                        'Sign in',
                        style: TextStyle(color: whiteColor),
                      ))));

    Widget forgotPassword = FlatButton(
      child: Text(
        'Forgot Password?',
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
      onPressed: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => ForgotPassWord()));
      },
    );

    Widget newUser = FlatButton(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text('New User?',
              style: TextStyle(
                  fontWeight: FontWeight.w100, color: Colors.grey[600])),
          Text(' Create account')
        ]),
        onPressed: () {
          Navigator.pushNamed(context, "/signup");
        });

    Widget marginTop = SizedBox(
      height: 20.0,
    );

    Widget formGroup = Form(
      key: _formKey,
      child: Column(
        children: <Widget>[userNameField, marginTop, passwordField, marginTop],
      ),
    );

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  appLogo,
                  marginTop,
                  formGroup,
                  buttonSumbit,
                  forgotPassword,
                  newUser
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
