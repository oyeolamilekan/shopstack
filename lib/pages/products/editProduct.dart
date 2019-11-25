import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopstack/blocs/productBloc/models/product_models.dart';
import 'package:shopstack/pages/actions.dart';
import 'package:shopstack/utils/utils.dart';
import 'package:shopstack/widgets/modal.dart';

class EditProduct extends StatefulWidget {
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _formKey = GlobalKey<FormState>();

  // This variable holds the data
  EditProductData args;

  // Color variable
  Color color = hexToColor('#000000');

  // Color when the product is creating
  Color _loadingColor = hexToColor('#A9A9A9');

  // Holds the data down for the drop down menu
  String tagValue2;

  // Save the data gotten from the network
  // Into a variable
  var shopTags = [];

  // image file name
  String fileNamePlaceHolder = '';

  // The image fileholder
  var imageFile;

  var previewFile;

  // Hold the value
  String productName;
  String productPrice;
  String productDescription;
  String tagValue;

  // Modal bottom sheet
  Modal modal = Modal();

  // Loading icon for form submission
  bool submitting = false;

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
  void initState() {
    // just like `ComponentDidMount -> react` or `mounted -> vue`
    // This is the first method called by the flutter

    // Call this function
    _getInitalShopTags();

    super.initState();
  }

  _getInitalShopTags() async {
    shopTags = await getTags();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    tagValue = args.product.genre.name;

    productName = args.product.name;
    tagValue = args.product.genre.name;
    productPrice = args.product.price;
    productDescription = args.product.description;
    
    Widget sizedBox = SizedBox(
      height: 25.0,
    );

    // Holds the data down for the drop down menu

    Widget productNameField = TextFormField(
      // This handles the email field of the for the application
      obscureText: false,
      initialValue: productName,
      onChanged: (String value) {
        productName = value;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "Product name",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0), borderSide: BorderSide()),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Colors.black)),
      ),
      // enabled: _sending ? false : true,
      keyboardType: TextInputType.emailAddress,
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
        productName = value;
      },
    );

    Widget productPriceField = TextFormField(
      // This handles the email field of the for the application
      obscureText: false,
      onChanged: (String value) {
        productPrice = value;
      },
      initialValue: productPrice,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "Product price",
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
        productPrice = value;
      },
    );

    Widget tagsWidget = DropdownButtonFormField<String>(
      value: tagValue2,
      items: shopTags.map((dropDownStringItem) {
        return DropdownMenuItem<String>(
          value: dropDownStringItem,
          child: Text(dropDownStringItem),
        );
      }).toList(),
      onChanged: (String newValueSelected) {
        setState(() {
          this.tagValue2 = newValueSelected;
        });
      },
      hint: Text('$tagValue'),
    );

    Widget productDescriptionField = TextFormField(
      // This handles the email field of the for the application
      obscureText: false,
      maxLines: 6,
      initialValue: productDescription,
      onChanged: (String value) {
        productDescription = value;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "Product Description",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0), borderSide: BorderSide()),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Colors.black)),
      ),
      // enabled: _sending ? false : true,
      keyboardType: TextInputType.emailAddress,
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
        productDescription = value;
      },
    );

    Widget productImage = ClipRRect(
      borderRadius: BorderRadius.circular(3.0),
      child: Container(
        decoration: BoxDecoration(border: new Border.all(color: Colors.grey)),
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
    );

    Widget imagePreview = SizedBox(
      child: Container(
        child: Image.network(args.product.image),
        width: 40,
        height: 40,
      ),
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
    Modal modal = Modal();
    Widget buttonSubmit = ClipRRect(
      borderRadius: BorderRadius.circular(3.0),
      child: Container(
        width: double.infinity,
        height: 40,
        child: RaisedButton(
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();

              submitting = true;
              setState(() {});
              String tags = tagValue2 == null ? tagValue : tagValue2;
              try {
                var response = await editProduct(
                    args.product.id,
                    productName,
                    productPrice,
                    tags,
                    productDescription,
                    imageFile,
                    fileNamePlaceHolder);
                if (response == 'Error') {
                  modal.mainBottomSheet(
                      context,
                      'An error occured, kindly check your connection.',
                      Icons.error);
                }
                // listen for response
                var data = response.stream.transform(utf8.decoder).join();
                if (response.statusCode == 201) {
                  Navigator.pop(context, data);
                }
              } catch (e) {
                Navigator.pop(context, false);
                print('product $e');

              }
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
          productNameField,
          sizedBox,
          productPriceField,
          sizedBox,
          tagsWidget,
          sizedBox,
          productDescriptionField,
          sizedBox,
          imagePreview,
          sizedBox,
          productImage,
          sizedBox,
          buttonSubmit
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: shopTags.length > 0
              ? formGroup
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}

class EditProductData {
  final Results product;
  EditProductData({this.product});
}
