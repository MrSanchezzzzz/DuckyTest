import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atlassian_apis/jira_platform.dart';


final apiClientConfigProvider = StateProvider<ApiClientConfig>((ref) {
  return ApiClientConfig(host: '', user: '', apiToken: '');
});

final platformApiProvider = Provider<JiraPlatformApi>((ref) {
  final config = ref.watch(apiClientConfigProvider);
  final client = ApiClient.basicAuthentication(
    Uri.https(config.host, ''),
    user: config.user,
    apiToken: config.apiToken,
  );
  return JiraPlatformApi(client);
});

class ApiClientConfig {
  final String host;
  final String user;
  final String apiToken;

  ApiClientConfig({
    required this.host,
    required this.user,
    required this.apiToken,
  });
}
