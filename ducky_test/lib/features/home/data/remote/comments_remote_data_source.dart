import 'package:atlassian_apis/jira_platform.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/data/platform_api_provider.dart';

class CommentsRemoteDataSource{
  late final JiraPlatformApi api;
  CommentsRemoteDataSource(Ref ref){
    api=ref.read(platformApiProvider);
  }

  Future<List<Comment>> getComments(IssueBean issue) async {
    if(issue.key==null&&issue.id==null){
      throw ArgumentError('Issue id or key is null');
    }
    final comments=(await api.issueComments.getComments(issueIdOrKey: issue.key??issue.id!)).comments;
    return comments;
  }

  void postComment(String commentText,{required String issueIdOrKey}) async{
    Comment comment=Comment(body: {
      'content':[
        {
          'content':[
            {
              'text':commentText,
              'type':'text'
            }
          ],
          'type':'paragraph'
        }
      ],
      'type':'doc',
      'version':1
    });
    api.issueComments.addComment(issueIdOrKey: issueIdOrKey, body:comment);
  }
}