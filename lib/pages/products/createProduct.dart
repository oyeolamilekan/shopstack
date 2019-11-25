import 'package:flutter/material.dart';
import 'package:shopstack/pages/actions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopstack/utils/utils.dart';
import 'package:shopstack/widgets/modal.dart';

class CreateProduct extends StatefulWidget {
  @override
  _CreateProductState createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  final _formKey = GlobalKey<FormState>();

  // Color variable
  Color color = hexToColor('#000000');

  // Color when the product is creating
  Color _loadingColor = hexToColor('#A9A9A9');


  // Holds the data down for the drop down menu
  var _tagsValue;

  // Save the data gotten from the network
  // Into a variable
  var shopTags = [];

  // image file name
  String fileNamePlaceHolder = '';

  // The image fileholder
  var imageFile;

  // Create the form controntroller
  final _productName = TextEditingController();
  final _productPrice = TextEditingController();
  final _productDescription = TextEditingController();

  // Modal bottom sheet
  Modal modal = Modal();

  // Loading icon for form submission
  bool submitting = false;

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
    Widget sizedBox = SizedBox(
      height: 25.0,
    );

    Widget productNameField = TextFormField(
      // This handles the email field of the for the application
      obscureText: false,
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
      controller: _productName,
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
    );

    Widget productPriceField = TextFormField(
      // This handles the email field of the for the application
      obscureText: false,
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
      controller: _productPrice,
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
    );

    Widget tagsWidget = DropdownButtonFormField<String>(
      items: shopTags.map((dropDownStringItem) {
        return DropdownMenuItem<String>(
          value: dropDownStringItem,
          child: Text(dropDownStringItem),
        );
      }).toList(),
      onChanged: (String newValueSelected) {
        setState(() {
          this._tagsValue = newValueSelected;
          // this._lga = _stateLgaHolder[newValueSelected];
          // this._statesLgaValue = null;
        });
      },
      value: _tagsValue,
      hint: Text('Choose Category.'),
      validator: (value) {
        if (value == null) {
          return 'This field can not be empty';
        }
        return null;
      },
    );

    Widget productDescriptionField = TextFormField(
      // This handles the email field of the for the application
      obscureText: false,
      maxLines: 6,
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
      controller: _productDescription,
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
            if (_formKey.currentState.validate() &&
                fileNamePlaceHolder.length > 0) {
              submitting = true;
              setState(() {});

              var response = await createProduct(
                  _productName.text,
                  _productPrice.text,
                  _tagsValue,
                  _productDescription.text,
                  imageFile,
                  fileNamePlaceHolder);
              if (response.statusCode == 201) {
                Navigator.pop(context);
              }
            } else if (fileNamePlaceHolder.length == 0) {
              modal.mainBottomSheet(
                  context, 'Kindly add a product image.', Icons.error_outline);
            }
          },
          color:submitting ? _loadingColor : color,
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
          productImage,
          sizedBox,
          buttonSubmit
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Product'),
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
