import 'package:stocksip/core/storage/token_storage.dart';
import 'package:stocksip/features/iam/admin_panel/data/remote/mappers/adminpanel_mapper.dart';
import 'package:stocksip/features/iam/admin_panel/data/remote/services/adminpanel_service.dart';
import 'package:stocksip/features/iam/admin_panel/domain/models/sub_user.dart';
import 'package:stocksip/features/iam/admin_panel/domain/repositories/adminpanel_repository.dart';

class AdminPanelRepositoryImpl extends AdminPanelRepository {
  final AdminPanelService service;
  final TokenStorage tokenStorage;

  AdminPanelRepositoryImpl({
    required this.service,
    required this.tokenStorage,
  });

  @override
  Future<void> registerSubUser(String accountId, SubUserCreate subUser) async {
    try {
      final dto = AdminPanelMapper.toRequestDto(subUser);
      final ok = await service.registerSubUser(accountId, dto);
      if (!ok) {
        throw Exception('Invalid request');
      }
    } catch (e) {
      throw Exception('Error registering sub user: $e');
    }
  }

  @override
  Future<List<AdminSubUsersGroup>> fetchSubUsers({String? role, String? accountId}) async {
    try {
      final acc = accountId ?? await tokenStorage.readAccountId();
      if (acc == null) throw Exception('No accountId found');

      final wrappers = await service.getSubUsers(acc, role: role);
      return wrappers.map(AdminPanelMapper.toGroup).toList();
    } catch (e) {
      throw Exception('Error fetching sub users: $e');
    }
  }

  @override
  Future<void> deleteUser(String userId, String profileId) async {
    try {
      final ok = await service.deleteUser(userId, profileId);
      if (!ok) {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }
}

