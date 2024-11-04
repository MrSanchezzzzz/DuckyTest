
import 'dart:convert';
import 'dart:typed_data';

import 'package:atlassian_apis/jira_platform.dart';
import 'package:ducky_test/features/authorization/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../../shared/data/platform_api_provider.dart';

class IssuesRemoteDataSource {
  late final JiraPlatformApi api;
  IssuesRemoteDataSource(Ref ref){
    api=ref.read(platformApiProvider);
  }

  Future<List<IssueBean>> getProjectIssues(Project project) async {
    final issues=(await api.issueSearch.searchForIssuesUsingJql(
      jql: 'project=${project.key}',
      fields: ['summary', 'description','comment','attachment'],
    )).issues;
    return issues;
  }

  Future<List<Uint8List>> getIssueAttachment(IssueBean issue) async{
    List<Uint8List> attachments=[];
    final attachmentsData=issue.fields?['attachment'] as List<dynamic>?;
    if(attachmentsData!=null){
      for(var attachment in attachmentsData){
        final a=await api.issueAttachments.getAttachment(attachment['id']!);
        String uri='https://richbirdskek.atlassian.net/rest/api/3/attachment/thumbnail/${a.id}';
        final response=await http.get(
            Uri.parse(uri),
          headers: {
              'Authorization':'Basic ${base64Encode(utf8.encode('${AuthRepository.email}:${AuthRepository.token}'))}'
          }
        );
        attachments.add(response.bodyBytes);
      }
    }
    return attachments;
  }

}