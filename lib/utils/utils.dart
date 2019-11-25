import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

launchURL(urlString) async {
  if (await canLaunch(urlString)) {
    await launch(urlString);
  } else {
    throw 'Could not launch $urlString';
  }
}
