import 'package:stocksip/features/iam/admin_panel/data/remote/models/adminpanel_dto.dart';
import 'package:stocksip/features/iam/admin_panel/data/remote/models/adminpanel_request_dto.dart';
import 'package:stocksip/features/iam/admin_panel/data/remote/models/adminpanel_subuser_wrapper_dto.dart';
import 'package:stocksip/features/iam/admin_panel/domain/models/sub_user.dart';

class AdminPanelMapper {
  static SubUser toDomain(UserDto dto) => SubUser(
        userId: dto.userId,
        email: dto.email,
        role: dto.role,
        profileId: dto.profileId,
        fullName: dto.fullName,
        phoneNumber: dto.phoneNumber,
        profilePictureUrl: dto.profilePictureUrl,
        profileRole: dto.profileRole,
      );

  static AdminSubUsersGroup toGroup(SubUserWrapperDto wrapper) => AdminSubUsersGroup(
        maxUsersAllowed: wrapper.maxUsersAllowed,
        totalUsers: wrapper.totalUsers,
        users: wrapper.users.map(toDomain).toList(),
      );

  static SubUserRequestDto toRequestDto(SubUserCreate create) => SubUserRequestDto(
        name: create.name,
        email: create.email,
        password: create.password,
        role: create.role,
        phoneNumber: create.phoneNumber,
        profileRole: create.profileRole,
      );
}
