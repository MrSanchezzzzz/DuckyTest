
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_repository.dart';
import '../../data/auth_repository_impl.dart';
import '../../data/models/user.dart';
import '../../data/remote/auth_remote_data_source.dart';

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository authRepository;

  AuthNotifier(this.authRepository) : super(const AsyncValue.data(null));

  Future<void> login(String email, String token) async {
    state = const AsyncValue.loading();
    try {
      final user = await authRepository.authenticateUser(email, token);
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e,StackTrace.current);
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = AuthRemoteDataSource(ref,'richbirdskek.atlassian.net'); // replace with actual domain
  return AuthRepositoryImpl(remoteDataSource);
});

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});
