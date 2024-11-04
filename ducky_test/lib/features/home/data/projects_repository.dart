
import 'models/comment.dart';
import 'models/issue.dart';
import 'models/project.dart';
import 'package:atlassian_apis/jira_platform.dart' as jira;

abstract class ProjectsRepository {
  Future<List<Project>> getProjects();
  Future<List<Issue>> _getIssues(jira.Project project);
  Future<List<Comment>> _getComments(jira.IssueBean issue);

  void postComment(String text, String issueKey);
}