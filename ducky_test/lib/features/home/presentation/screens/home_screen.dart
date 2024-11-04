import 'package:ducky_test/features/home/presentation/widgets/comments_list_view.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  final String email;

  const HomeScreen({super.key, required this.username, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome, $username!'),
            Text(email,style: Theme.of(context).textTheme.bodySmall,)
          ],
        ),
      ),
      body: const CommentsListView(),
    );
  }
}
