import 'package:flutter/material.dart';

class Modal {
  mainBottomSheet(BuildContext context, String errorMsg, IconData icon,
      {String bgColor = 'danger'}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: bgColor == 'danger' ? Colors.red : Colors.black,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _createTile(context, errorMsg, icon),
              ],
            ),
          );
        });
  }

  ListTile _createTile(BuildContext context, String name, IconData icon) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
        size: 45.0,
      ),
      title: Text(
        name,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
