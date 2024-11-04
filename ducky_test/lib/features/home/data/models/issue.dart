
import 'dart:typed_data';

import 'comment.dart';

class Issue{
  String id;
  String name;
  String key;
  String description;
  String jiraUrl;
  List<Comment> comments;
  List<Uint8List> attachments;
  Issue({required this.id,required this.name,required this.key,required this.description,required this.jiraUrl,required this.comments,required this.attachments});
}
