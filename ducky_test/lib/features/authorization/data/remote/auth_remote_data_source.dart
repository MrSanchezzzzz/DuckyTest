import 'package:atlassian_apis/jira_platform.dart';
import 'package:ducky_test/shared/data/platform_api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRemoteDataSource {
  final String host;
  final Ref ref;

  AuthRemoteDataSource(this.ref, this.host);

  Future<User> authenticate(
      String email, String token) async {
    final config = ApiClientConfig(
        host: host, user: email, apiToken: token);
    ref.read(apiClientConfigProvider.notifier).state=config;
    var jira = ref.read(platformApiProvider);
    final user = await jira.myself.getCurrentUser();
    return user;
  }
}
