import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String message;

  const ErrorMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
