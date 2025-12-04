import 'adminpanel_dto.dart';

class SubUserWrapperDto {
  final int maxUsersAllowed;
  final int totalUsers;
  final List<UserDto> users;

  SubUserWrapperDto({
    required this.maxUsersAllowed,
    required this.totalUsers,
    required this.users,
  });

  factory SubUserWrapperDto.fromJson(Map<String, dynamic> json) {
    final list = (json['users'] as List<dynamic>? ?? [])
        .map((e) => UserDto.fromJson(e as Map<String, dynamic>))
        .toList();

    return SubUserWrapperDto(
      maxUsersAllowed: (json['maxUsersAllowed'] ?? 0) as int,
      totalUsers: (json['totalUsers'] ?? 0) as int,
      users: list,
    );
  }

  static List<SubUserWrapperDto> listFromJson(List<dynamic> json) {
    return json
        .map((e) => SubUserWrapperDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}