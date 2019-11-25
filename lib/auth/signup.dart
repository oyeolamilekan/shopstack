import 'package:flutter/material.dart';
import 'package:shopstack/auth/actions.dart';
import 'package:shopstack/utils/utils.dart';
import 'package:shopstack/widgets/modal.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Modal modal = Modal();

  var file;
  String fileName;
  String base64Image;
  bool uploading = false;
  bool sent = false;
  bool error = false;
  bool errorUploading = false;
  bool loading = false;
  String msg = '';

  @override
  Widget build(BuildContext context) {
    Color color = hexToColor('#000000');
    Color colorWhite = hexToColor('#ffffff');
    Widget appLogo = SizedBox(
      height: 100.0,
      child: new Image.asset('img/logo.png'),
    );

    Widget nameField = TextFormField(
      // This field handles the password field
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          hintText: "Full Name",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.0),
              borderSide: BorderSide()),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: color))),
      keyboardType: TextInputType.text,
      controller: _nameController,
      validator: (value) {
        if (value.isEmpty) {
          return 'This field can\'t be empty';
        } else if (value.length <= 2) {
          return 'Name too short';
        }
        return null;
      },
    );


    Widget emailField = TextFormField(
      // This handles the email field of the for the application
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "Email",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0), borderSide: BorderSide()),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: color)),
      ),
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      validator: (value) {
        if (value.isEmpty) {
          return 'This field can\'t be empty';
        } else if (value.indexOf('@') < 0) {
          return 'Kindly type a valid email';
        }
        return null;
      },
    );

    Widget passwordField = TextFormField(
      // This field handles the password field
      obscureText: true,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          hintText: "Password",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.0),
              borderSide: BorderSide()),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: color))),
      controller: _passwordController,
      validator: (value) {
        if (value.isEmpty) {
          return 'This is field can\'t be empty';
        } else if (value.length <= 6) {
          return 'Password too short';
        }
        return null;
      },
    );

    Widget loadingObject = SizedBox(
        child: CircularProgressIndicator(
            backgroundColor: Colors.black,
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation(colorWhite)),
        width: 20.0,
        height: 20.0);

    Widget buttonSumbit = ClipRRect(
        borderRadius: BorderRadius.circular(3.0),
        child: Container(
            height: 40.0,
            width: MediaQuery.of(context).size.width,
            child: RaisedButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  /// Chec
                  setState(() {
                    loading = true;
                  });
                  var isSuccess = await authSignUpUser(_emailController.text,
                      _nameController.text, _passwordController.text);
                  if (isSuccess['success']) {
                    /// If the lgin is succesful route them to the loginpage
                    Navigator.pushNamedAndRemoveUntil(context, '/createStore',
                        (Route<dynamic> route) => false);
                  } else {
                    setState(() {
                      msg = isSuccess['msg'];
                      loading = false;
                    });
                    modal.mainBottomSheet(context, isSuccess['msg'], Icons.error_outline);
                  }
                }
              },
              color: color,
              child: loading
                  ? loadingObject
                  : Text("Create Account",
                      style: TextStyle(color: Colors.white)),
            )));

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

    Widget marginTop = SizedBox(
      height: 20.0,
    );

    Widget formGroup = Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          emailField,
          marginTop,
          nameField,
          marginTop,
          passwordField,
          marginTop,
          buttonSumbit,
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text('Sign up'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(36.0, 10.0, 36.0, 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                appLogo,
                formGroup,
                forgotPassword,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
