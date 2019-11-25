import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SpashPage extends StatelessWidget {
  final appLogo = SizedBox(
    height: 100.0,
    child: new Image.asset('img/logo.png'),
  );

  final textSubtitle = Text(
    'Tech. For Naija. By Naija',
    style: TextStyle(fontWeight: FontWeight.bold),
  );

  final marginTop = SizedBox(height: 20.0,);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              appLogo,
              marginTop,
              textSubtitle
            ],
          ),
        ),
      ),
    );
  }
}
