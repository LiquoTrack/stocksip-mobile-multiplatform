import 'package:stocksip/core/common/utils/resource.dart';
import 'package:stocksip/features/iam/login/domain/models/user.dart';

/// Repository for authentication-related operations.
/// This abstract class defines the contract for authentication methods
abstract class AuthRepository {

  /// Signs in a user with the provided username and password.
  Future<User> signIn(String username, String password);

  /// Signs up a new user with the provided details.
  Future<Resource<String>> signUp(String username, String email, String password, String accountRole, String businessName);  
}