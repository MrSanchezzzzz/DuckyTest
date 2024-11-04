import 'dart:typed_data';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:ducky_test/features/home/presentation/providers/projects_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'comment_rich_text.dart';
import 'url_text_span.dart';

class CommentContent extends ConsumerWidget {
  const CommentContent(
      {super.key,
      this.isMyComment = false,
      required this.authorName,
      required this.projectName,
      required this.issueKey,
      required this.issueName,
      required this.description,
      required this.text,
      this.attachments,
      required this.jiraUrl});

  final bool isMyComment;
  final String authorName;
  final String projectName;
  final String issueKey;
  final String issueName;
  final String description;
  final String text;
  final List<Uint8List>? attachments;
  final String jiraUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      decoration: BoxDecoration(
        color: isMyComment
            ? Colors.blue[100]
            : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                authorName,
                textAlign: isMyComment
                    ? TextAlign.right
                    : TextAlign.left,
              ),
              const Spacer(),
              Text(
                projectName,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              )
            ],
          ),
          const Divider(),
          Text(
            '$issueName [$issueKey]',
          ),
          const SizedBox(
            height: 4,
          ),
          RichText(
            text: TextSpan(
                text: 'Description: ',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                children: [
                  commentTextSpan(context,
                      text: description)
                ]),
          ),
          RichText(
              text: commentTextSpan(context, text: text)),
          if (attachments != null &&
              attachments!.isNotEmpty) ...{
            Text(
              'Attachments:',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            ...attachments!.map<Widget>((a) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Image.memory(
                  a,
                  fit: BoxFit.contain,
                ),
              );
            }),
          },
          const Divider(),
          Text.rich(
            urlTextSpan(url: jiraUrl),
            softWrap: true,
          ),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              showTextInputDialog(
                  context: context,
                  title: 'Enter your reply here',
                  textFields: [
                    const DialogTextField(
                      hintText: 'Your text here',
                    )
                  ],
                  onPopInvokedWithResult:
                      (result, strings) {
                    if (strings != null &&
                        strings.isNotEmpty) {
                      ref.read(projectsProvider.notifier).projectsRepository.postComment(strings[0],issueKey);
                    }
                  });
            },
            child: const Row(
              children: [Text('Reply'), Icon(Icons.reply)],
            ),
          )
        ],
      ),
    );
  }
}
