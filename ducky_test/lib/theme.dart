
import 'package:flutter/material.dart';

final defaultTheme=ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
    filled: true,
    fillColor: Colors.grey.shade100,
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
    ),
  )
);