import 'package:atlassian_apis/jira_platform.dart';
import 'package:ducky_test/shared/data/platform_api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectsRemoteDataSource {
  late final JiraPlatformApi api;

  ProjectsRemoteDataSource(Ref ref){
    api=ref.read(platformApiProvider);
  }

  Future<List<Project>> getProjects() async {
    List<Project> projects =
        (await api.projects.searchProjects()).values;

    return projects;
  }

}
