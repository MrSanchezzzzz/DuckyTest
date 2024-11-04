import 'issue.dart';

class Project{
  final String name;
  final String id;
  final List<Issue> issues;
  final String? avatarUrl;

  Project({required this.name,required this.id,required this.issues,this.avatarUrl});
}