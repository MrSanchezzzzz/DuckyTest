import 'package:ducky_test/features/home/presentation/widgets/comment_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/project.dart';
import '../providers/projects_provider.dart';

class CommentsListView extends ConsumerWidget {
  const CommentsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsProvider);
    return projects.when(data: (List<Project> data) {
      List<Widget> widgets=[];
      for (var project in data) {
        for (var issue in project.issues) {
          for (var comment in issue.comments) {
            widgets.add(CommentListItem(
              projectName: project.name,
              text: comment.text,
              attachments: issue.attachments,
              avatarUrl: project.avatarUrl,
              issueName: issue.name,
              issueKey: issue.key,
              description: issue.description,
              authorName: comment.author,
              jiraUrl: issue.jiraUrl,
              isMyComment: comment.isMy,
            ));
          }
        }
      }
      widgets.add(const SizedBox(height: 24,));
      return ListView(
        children: widgets,
      );
    }, loading: () {
      return const Center(child: CircularProgressIndicator());
    }, error: (Object error, StackTrace stackTrace) {
      return Text(error.toString());
    });
  }
}
