import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopstack/auth/actions.dart';
import 'package:shopstack/utils/utils.dart';
import 'package:shopstack/widgets/modal.dart';

class Edit extends StatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  String phoneNumber;
  String address;
  String description;

  // image file name
  String fileNamePlaceHolder = '';

  // The image fileholder
  var imageFile;

  bool _sending = false;
  bool _error = false;

  final _formKey = GlobalKey<FormState>();

  String productName;

  Modal modal = Modal();

  Color color = hexToColor('#000000');

  Color whiteColor = hexToColor('#ffffff');

  Map data;

  @override
  void initState() {
    initialData();
    super.initState();
  }

  void initialData() async {
    data = await getInitialProfileData();
    if (data['msg'] == 'Error') {
      _error = true;
    }
    setState(() {});
  }

  void _choose() async {
    try {
      var file = await ImagePicker.pickImage(source: ImageSource.gallery);
      var fileName = file.path.split("/").last;
      imageFile = file;
      fileNamePlaceHolder = fileName;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data != null) {
      phoneNumber = data['phone_number'];
      address = data['address'];
      description = data['description'];
    }

    Widget userPhoneNumberField = TextFormField(
      // This handles the email field of the for the application
      obscureText: false,
      initialValue: phoneNumber,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "Phone Number",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0), borderSide: BorderSide()),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Colors.black)),
      ),
      // enabled: _sending ? false : true,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.isEmpty) {
          return 'Kindly fill in the form.';
        } else if (value == ' ') {
          return 'Form can\'t be empty';
        } else if (value.length < 6) {
          return 'Tags too short';
        }
        return null;
      },
      onSaved: (String value) {
        phoneNumber = value;
      },
    );

    Widget userAddressField = TextFormField(
      // This handles the email field of the for the application
      obscureText: false,
      maxLines: 6,
      initialValue: address,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "Address",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0), borderSide: BorderSide()),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Colors.black)),
      ),
      // enabled: _sending ? false : true,
      keyboardType: TextInputType.text,

      onSaved: (String value) {
        address = value;
      },
    );

    Widget userDescriptionField = TextFormField(
      // This handles the email field of the for the application
      obscureText: false,
      initialValue: description,
      maxLines: 6,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "Description",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0), borderSide: BorderSide()),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Colors.black)),
      ),
      keyboardType: TextInputType.text,
      onSaved: (String value) {
        description = value;
      },
    );

    Widget storeLogo = ClipRRect(
      borderRadius: BorderRadius.circular(3.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Store Logo'),
          SizedBox(
            height: 3,
          ),
          Container(
            decoration:
                BoxDecoration(border: new Border.all(color: Colors.grey)),
            width: double.infinity,
            height: 40,
            child: RaisedButton(
              onPressed: () {
                _choose();
              },
              child: Text(fileNamePlaceHolder.length == 0
                  ? 'Choose a file.'
                  : fileNamePlaceHolder),
            ),
          ),
        ],
      ),
    );

    Widget loadingObject = SizedBox(
        child: CircularProgressIndicator(
            backgroundColor: whiteColor, strokeWidth: 2.0),
        width: 20.0,
        height: 20.0);

    Widget buttonSubmit = ClipRRect(
        borderRadius: BorderRadius.circular(3.0),
        child: Container(
            height: 40.0,
            width: MediaQuery.of(context).size.width,
            child: RaisedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate() && !_sending) {
                    _formKey.currentState.save();
                    _sending = true;
                    setState(() {});

                    var data = await editProfile(
                        phoneNumber, address, description, imageFile);
                    _sending = false;
                    setState(() {});
                    if (data != null) {
                      if (data.statusCode == 200) {
                        modal.mainBottomSheet(context,
                            'Profile successfully updated.', Icons.check_circle,
                            bgColor: 'success');
                      }
                    } else {
                      modal.mainBottomSheet(
                        context,
                        'Profile update failed.',
                        Icons.cancel,
                      );
                    }
                  }
                },
                color: color,
                child: _sending == true
                    ? loadingObject
                    : Text(
                        'Submit',
                        style: TextStyle(color: whiteColor),
                      ))));

    Widget sizedBox = SizedBox(
      height: 10,
    );

    Widget formGroup = Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          userPhoneNumberField,
          sizedBox,
          userAddressField,
          sizedBox,
          userDescriptionField,
          sizedBox,
          storeLogo,
          sizedBox,
          buttonSubmit
        ],
      ),
    );

    Widget errorWidget = Center(child: Text('Error'));

    Widget progressWidget = Center(child: CircularProgressIndicator());

    Widget formScrollView = SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: formGroup,
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body:
          _error ? errorWidget : data != null ? formScrollView : progressWidget,
    );
  }
}
