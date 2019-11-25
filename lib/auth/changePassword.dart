import 'package:flutter/material.dart';
import 'package:shopstack/auth/actions.dart';
import 'package:shopstack/utils/utils.dart';
import 'package:shopstack/widgets/modal.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var _oldPassword = TextEditingController();
  var _newPassword = TextEditingController();
  var _newPassword2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool submitting = false;
  Color color = hexToColor('#000000');
  Color _loadingColor = hexToColor('#A9A9A9');
  Modal modal = Modal();

  @override
  Widget build(BuildContext context) {
    Widget _oldPasswordField = TextFormField(
      // This handles the email field of the for the application
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "Old Password",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0), borderSide: BorderSide()),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Colors.black)),
      ),
      // enabled: _sending ? false : true,
      keyboardType: TextInputType.emailAddress,
      controller: _oldPassword,
      validator: (value) {
        if (value.isEmpty) {
          return 'Kindly type your password.';
        } else if (value == ' ') {
          return 'Form can\'t be empty';
        } else if (value.length < 6) {
          return 'password too short';
        }
        return null;
      },
    );

    Widget _newPasswordField = TextFormField(
      // This handles the email field of the for the application
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "New Password",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0), borderSide: BorderSide()),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Colors.black)),
      ),
      // enabled: _sending ? false : true,
      keyboardType: TextInputType.emailAddress,
      controller: _newPassword,
      validator: (value) {
        if (value.isEmpty) {
          return 'Kindly fill in the form.';
        } else if (value == ' ') {
          return 'Form can\'t be empty';
        } else if (value.length < 6) {
          return 'password too short';
        }
        return null;
      },
    );

    Widget _newPasswordField2 = TextFormField(
      // This handles the email field of the for the application
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "Retype New Password",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0), borderSide: BorderSide()),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Colors.black)),
      ),
      // enabled: _sending ? false : true,
      keyboardType: TextInputType.emailAddress,
      controller: _newPassword2,
      validator: (value) {
        if (value.isEmpty) {
          return 'Kindly tyoe your password.';
        } else if (value == ' ') {
          return 'Form can\'t be empty';
        } else if (value.length < 6) {
          return 'password too short';
        }
        return null;
      },
    );

    Widget sizedBox = SizedBox(
      height: 25.0,
    );

    Widget widgetLoading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
            strokeWidth: 2.0,
          ),
          height: 15.0,
          width: 15.0,
        ),
        SizedBox(
          width: 6.0,
        ),
        Text(
          'Saving .....',
          style: TextStyle(color: Colors.white),
        )
      ],
    );

    Widget textSave = Text(
      'Save',
      style: TextStyle(color: Colors.white),
    );

    Widget buttonSubmit = ClipRRect(
      borderRadius: BorderRadius.circular(3.0),
      child: Container(
        width: double.infinity,
        height: 40,
        child: RaisedButton(
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              submitting = true;
              setState(() {});

              if (_newPassword2.text == _newPassword.text) {
                var response = await authChangePassword(
                    _oldPassword.text, _newPassword.text);

                if (response == 200) {
                  modal.mainBottomSheet(
                      context, 'Password successfully changed.', Icons.check,
                      bgColor: 'success');
                  setState(() {
                    _oldPassword.text = '';
                    _newPassword.text = '';
                    _newPassword2.text = '';
                    // gggggggggg
                  });
                } else if (response == 400){
                  modal.mainBottomSheet(
                      context,
                      'Your old password was entered incorrectly. Please enter it again..',
                      Icons.cancel);
                }
              } else {
                 modal.mainBottomSheet(
                      context,
                      'The two password fields didn\'t match.',
                      Icons.cancel);
              }

              submitting = false;
              setState(() {});
            }
          },
          color: submitting ? _loadingColor : color,
          child: submitting ? widgetLoading : textSave,
        ),
      ),
    );
    Widget formGroup = Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _oldPasswordField,
          sizedBox,
          _newPasswordField,
          sizedBox,
          _newPasswordField2,
          sizedBox,
          buttonSubmit
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: formGroup,
        ),
      ),
    );
  }
}
