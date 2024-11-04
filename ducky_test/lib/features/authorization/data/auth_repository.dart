
import 'models/user.dart';

abstract class AuthRepository {
  Future<User> authenticateUser(String email, String token);
  static late String email;
  static late String token;
}