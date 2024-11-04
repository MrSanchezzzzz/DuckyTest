import 'package:ducky_test/features/authorization/presentation/screens/authorization_screen.dart';
import 'package:ducky_test/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: defaultTheme,
      debugShowCheckedModeBanner: false,
      home: AuthorizationScreen(),
    );
  }
}