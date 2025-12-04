import 'package:stocksip/features/iam/admin_panel/domain/models/sub_user.dart';

abstract class AdminPanelRepository {
  Future<void> registerSubUser(String accountId, SubUserCreate subUser);

  Future<List<AdminSubUsersGroup>> fetchSubUsers({String? role, String? accountId});

  Future<void> deleteUser(String userId, String profileId);
}
