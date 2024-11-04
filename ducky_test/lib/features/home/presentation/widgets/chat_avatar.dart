import 'package:flutter/material.dart';

class ChatAvatar extends StatelessWidget {
  const ChatAvatar({super.key,this.projectName=' '});
  final String projectName;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      child: Text(
        projectName[0].toUpperCase(),
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
