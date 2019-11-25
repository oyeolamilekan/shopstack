import 'package:flutter/material.dart';
import 'package:shopstack/auth/actions.dart';
import 'package:shopstack/utils/utils.dart';
import 'package:shopstack/const/const.dart';
import 'package:shopstack/widgets/modal.dart';

class CreateStore extends StatefulWidget {
  @override
  _CreateStoreState createState() => _CreateStoreState();
}

class _CreateStoreState extends State<CreateStore> {
  final _formKey = GlobalKey<FormState>();

  final _phoneNumberController = TextEditingController();
  final _shopNameController = TextEditingController();

  bool error = false;
  Modal modal = Modal();
  String _interestValue = "";
  Color colorWhite = hexToColor('#ffffff');
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Color color = hexToColor('#000000');
    Color loadingColor = hexToColor('#3c3939');

    Widget shopNameField = TextFormField(
      // This field handles the password field
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          hintText: "Enter Shop Name",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.0),
              borderSide: BorderSide()),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: color))),
      keyboardType: TextInputType.text,
      controller: _shopNameController,
      validator: (value) {
        if (value.isEmpty) {
          return 'This field can\'t be empty';
        } else if (value.length <= 2) {
          return 'Name too short';
        }
        return null;
      },
    );

    Widget phoneNumber = TextFormField(
      // This field handles the password field
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          hintText: "Enter Phone Number",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.0),
              borderSide: BorderSide()),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: color))),
      keyboardType: TextInputType.number,
      controller: _phoneNumberController,
      validator: (value) {
        if (value.isEmpty) {
          return 'This field can\'t be empty';
        } else if (value.length <= 10) {
          return 'Phone Number too short';
        }
        return null;

      },
    );

    Widget business = DropdownButtonFormField<String>(
      items: businessType.map((String dropDownStringItem) {
        return DropdownMenuItem<String>(
          value: dropDownStringItem,
          child: Text(dropDownStringItem),
        );
      }).toList(),
      onChanged: (String newValueSelected) {
        setState(() {
          this._interestValue = newValueSelected;
        });
      },
      value: _interestValue == null
          ? _interestValue
          : _interestValue.length > 0 ? _interestValue : null,
      hint: Text('What are you into?'),
      validator: (value) {
        if (value == null) {
          return 'This field can not be empty';
        }
        return null;

      },
    );

    Widget marginTop = SizedBox(
      height: 20.0,
    );

    Widget infoContainer = Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Kindly fill in the form, so we can build your store for you. From your friends at shopstack.',
            style: TextStyle(color: Colors.white),
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Colors.blueAccent));

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
                  setState(() {
                    loading = true;
                  });
                  var isSuccess = await createShop(_shopNameController.text,
                      _phoneNumberController.text, _interestValue);
                  if (!isSuccess['is_exist']) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/index', (Route<dynamic> route) => false);
                  } else {
                    setState(() {
                      loading = false;
                    });
                    modal.mainBottomSheet(
                        context, isSuccess['msg'], Icons.error);
                  }
                }
              },
              color: loading ? loadingColor : color,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(loading ? "Creating Shop.. " : "Create Shop",
                        style: TextStyle(color: Colors.white)),
                    SizedBox(
                      width: 10.0,
                    ),
                    loading ? loadingObject : SizedBox()
                  ],
                ),
              ),
            )));
    Widget formGroup = Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          shopNameField,
          marginTop,
          phoneNumber,
          marginTop,
          business,
          marginTop,
          buttonSumbit
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text('Create Shop'),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
                infoContainer,
                marginTop,
                formGroup,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
