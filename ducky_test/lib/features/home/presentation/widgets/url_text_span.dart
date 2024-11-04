import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

TextSpan urlTextSpan({required String url}){
  return TextSpan(
    text: url,
    style: const TextStyle(color: Colors.blue,
        decoration: TextDecoration.underline,
    decorationColor: Colors.blue),
    recognizer: TapGestureRecognizer()
      ..onTap = () async {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        }
      },
    spellOut: false
  );
}