import 'package:flutter/material.dart';
import 'package:shopstack/pages/actions.dart';
import 'package:shopstack/utils/utils.dart';
import 'package:shopstack/widgets/modal.dart';

class FeedBack extends StatefulWidget {
  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  var _reason = TextEditingController();
  var _description = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool submitting = false;

  Modal modal = Modal();

  // Button color
  Color color = hexToColor('#000000');
  Color _loadingColor = hexToColor('#A9A9A9');

  List<String> _feedbackList = ['Great', 'Okay', 'Medium', 'Nice'];

  String _scoreValue;

  @override
  Widget build(BuildContext context) {
    Widget tagsWidget = DropdownButtonFormField<String>(
      items: _feedbackList.map((dropDownStringItem) {
        return DropdownMenuItem<String>(
          value: dropDownStringItem.toLowerCase(),
          child: Text(dropDownStringItem),
        );
      }).toList(),
      onChanged: (String newValueSelected) {
        setState(() {
          this._scoreValue = newValueSelected;
          // this._lga = _stateLgaHolder[newValueSelected];
          // this._statesLgaValue = null;
        });
      },
      value: _scoreValue,
      hint: Text('Choose Category.'),
      validator: (value) {
        if (value == null) {
          return 'This field can not be empty';
        }
        return null;
      },
    );

    Widget reasonField = TextFormField(
      // This handles the email field of the for the application
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "Reason",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0), borderSide: BorderSide()),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Colors.black)),
      ),
      // enabled: _sending ? false : true,
      keyboardType: TextInputType.text,
      controller: _reason,
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

    Widget descriptionField = TextFormField(
      // This handles the email field of the for the application
      obscureText: false,
      maxLines: 6,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "Explain further",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0), borderSide: BorderSide()),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Colors.black)),
      ),
      // enabled: _sending ? false : true,
      keyboardType: TextInputType.text,
      controller: _description,
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

              var response = await createFeedBack(
                  _scoreValue, _reason.text, _description.text);
              if (response == 201) {
                modal.mainBottomSheet(
                    context, 'Feedback successfully sent.', Icons.check,
                    bgColor: 'success');

                
                setState(() {
                  _scoreValue = null;
                  _reason.text = '';
                  _description.text = '';
                });
              } else {
                modal.mainBottomSheet(
                    context,
                    'Feedback failed kindly check your connection.',
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
          tagsWidget,
          sizedBox,
          reasonField,
          sizedBox,
          descriptionField,
          sizedBox,
          buttonSubmit
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Send Feedback'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: formGroup,
        ),
      ),
    );
  }
}
