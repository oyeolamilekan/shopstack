import 'package:flutter/material.dart';
import 'package:shopstack/pages/actions.dart';
import 'package:shopstack/utils/utils.dart';
import 'package:shopstack/widgets/modal.dart';

class CreateTags extends StatefulWidget {
  @override
  _CreateTagsState createState() => _CreateTagsState();
}

class _CreateTagsState extends State<CreateTags> {
  final _formKey = GlobalKey<FormState>();
  final _tagName = TextEditingController();
  bool _sending = false;
  
  Color color = hexToColor('#000000');
  Color _loadingColor = hexToColor('#A9A9A9');

  @override
  Widget build(BuildContext context) {
    Modal modal = Modal();

    Widget marginTop = SizedBox(
      height: 10.0,
    );

    Widget tagNameField = TextFormField(
      // This handles the email field of the for the application
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "Create Tags",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0), borderSide: BorderSide()),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Colors.black)),
      ),
      enabled: _sending ? false : true,
      keyboardType: TextInputType.emailAddress,
      controller: _tagName,
      onChanged: (String value){
        return value.trim();
      },
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
                    bool resp = await createTag(_tagName.text);

                    if (resp) {

                      setState(() {
                        _sending = false;
                      });

                      Navigator.pop(context, true);
                    } else {
                      
                      setState(() {
                        _sending = false;
                      });
                      // it to show a SnackBar.
                      // Find the Scaffold in the widget tree and use
                      modal.mainBottomSheet(
                          context, 'Some error happend.', Icons.error_outline);
                    }
                    setState(() {
                      _sending = false;
                    });
                  }
                },
                color: _sending ? _loadingColor : color,
                child: Text(
                  _sending ? "Creating Tags.. " : "Create Tags",
                  style: TextStyle(color: Colors.white),
                ))));

    Widget formGroup = Form(
      key: _formKey,
      child: Column(
        children: <Widget>[tagNameField],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Tags'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[formGroup, marginTop, buttonSumbit],
        ),
      ),
    );
  }
}
