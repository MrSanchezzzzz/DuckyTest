import 'dart:typed_data';

import 'package:ducky_test/features/home/presentation/widgets/chat_avatar.dart';
import 'package:ducky_test/features/home/presentation/widgets/comment_content.dart';
import 'package:flutter/material.dart';

class CommentListItem extends StatelessWidget {
  const CommentListItem({
    super.key,
    required this.projectName,
    required this.text,
    this.avatarUrl,
    this.attachments,
    required this.issueName,
    required this.description,
    required this.authorName,
    required this.jiraUrl,
    required this.issueKey,
    this.isMyComment = false,
  });
  final String? avatarUrl;
  final String projectName;
  final String issueName;
  final String issueKey;
  final String description;
  final String authorName;
  final String text;
  final List<Uint8List>? attachments;
  final String jiraUrl;
  final bool isMyComment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 8.0, horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMyComment) ...{
            ChatAvatar(
              projectName: projectName,
            ),
            const SizedBox(width: 8)
          },
          Expanded(
            child: CommentContent(
              isMyComment: isMyComment,
              authorName: authorName,
              projectName: projectName,
              issueName: issueName,
              issueKey: issueKey,
              description: description,
              text: text,
              attachments: attachments,
              jiraUrl: jiraUrl,
            ),
          ),
          if (isMyComment) ...{
            const SizedBox(width: 8),
            ChatAvatar(
              projectName: projectName,
            ),
          },
        ],
      ),
    );
  }
}
