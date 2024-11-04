
import 'package:ducky_test/features/authorization/data/remote/auth_remote_data_source.dart';

import 'models/user.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> authenticateUser(String email, String token) async {
    final user = await remoteDataSource.authenticate(email, token);
    AuthRepository.email = email;
    AuthRepository.token = token;
    return User(
      id: user.accountId??'',
      displayName: user.displayName??'',
      email: user.emailAddress??'no email',
    );
  }
}
