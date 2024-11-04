
import 'package:ducky_test/features/home/data/models/project.dart';
import 'package:ducky_test/features/home/data/remote/comments_remote_data_source.dart';
import 'package:ducky_test/features/home/data/remote/issues_remote_data_source.dart';
import 'package:ducky_test/features/home/data/remote/projects_remote_data_source.dart';
import 'package:atlassian_apis/jira_platform.dart' as jira;
import 'models/comment.dart';
import 'models/issue.dart';
import 'projects_repository.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  final ProjectsRemoteDataSource projectsDataSource;
  final IssuesRemoteDataSource issuesDataSource;
  final CommentsRemoteDataSource commentsDataSource;
  final String? userId;

  const ProjectsRepositoryImpl(
      this.projectsDataSource,
      this.issuesDataSource,
      this.commentsDataSource, {
        this.userId,
      });

  @override
  Future<List<Project>> getProjects() async {
    final projectDataModels = await projectsDataSource.getProjects();
    return Future.wait(projectDataModels.map(_mapProject).toList(growable: false));
  }

  Future<Project> _mapProject(jira.Project proj) async {
    return Project(
      id: proj.id ?? '',
      name: proj.name ?? '',
      issues: await _getIssues(proj),
      avatarUrl: proj.avatarUrls?.$48X48,
    );
  }

  @override
  Future<List<Issue>> _getIssues(jira.Project project) async {
    final projectIssues = await issuesDataSource.getProjectIssues(project);
    return Future.wait(projectIssues.map(_mapIssue).toList(growable: false));
  }

  Future<Issue> _mapIssue(jira.IssueBean issue) async {
    final description = _extractDescription(issue);
    final comments = await _getComments(issue);
    final attachments = await issuesDataSource.getIssueAttachment(issue);

    return Issue(
      id: issue.id ?? '',
      name: issue.fields?['summary'] ?? '',
      key: issue.key ?? '',
      description: description,
      jiraUrl: 'https://richbirdsdkek.atlassian.net/browse/${issue.key}',
      comments: comments,
      attachments: attachments,
    );
  }

  String _extractDescription(jira.IssueBean issue) {
    final descriptionContent = issue.fields?['description']?['content'] as List<dynamic>? ?? [];
    final buffer = StringBuffer();

    for (var content in descriptionContent) {
      for (var contentContent in content['content'] ?? []) {
        if (contentContent?['type'] == 'text' && contentContent['text'].isNotEmpty) {
          buffer.write(contentContent['text']);
          if (content['type'] == 'paragraph') buffer.write('\n');
        }
      }
    }

    return buffer.toString().trimRight();
  }

  @override
  Future<List<Comment>> _getComments(jira.IssueBean issue) async {
    final commentsData = await commentsDataSource.getComments(issue);
    return commentsData.map(_mapComment).toList(growable: false);
  }

  Comment _mapComment(jira.Comment comment) {
    final text = _extractCommentText(comment);
    final author = comment.author?.displayName ?? comment.author?.emailAddress ?? comment.author?.accountId ?? '';

    return Comment(
      text: text,
      author: author,
      isMy: userId == comment.author?.accountId,
      attachments: '',
    );
  }

  String _extractCommentText(jira.Comment comment) {
    final commentContents = (comment.body as Map<String, dynamic>)['content'] as List<dynamic>;
    final buffer = StringBuffer();

    for (var commentContent in commentContents) {
      for (var content in commentContent['content'] ?? []) {
        if (content['type'] == 'text') {
          buffer.write(content['text']);
          if (commentContent['type'] == 'paragraph') buffer.write('\n');
        }
      }
    }

    return buffer.toString().trimRight();
  }

  @override
  void postComment(String text, String issueKey) async {
    commentsDataSource.postComment(text, issueIdOrKey: issueKey);
  }
}
