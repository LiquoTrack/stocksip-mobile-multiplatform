class SubUser {
  final String userId;
  final String email;
  final String role;
  final String profileId;
  final String fullName;
  final String phoneNumber;
  final String profilePictureUrl;
  final String profileRole;

  const SubUser({
    required this.userId,
    required this.email,
    required this.role,
    required this.profileId,
    required this.fullName,
    required this.phoneNumber,
    required this.profilePictureUrl,
    required this.profileRole,
  });
}

class SubUserCreate {
  final String name;
  final String email;
  final String password;
  final String role;
  final String phoneNumber;
  final String profileRole;

  const SubUserCreate({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.phoneNumber,
    required this.profileRole,
  });
}

class AdminSubUsersGroup {
  final int maxUsersAllowed;
  final int totalUsers;
  final List<SubUser> users;

  const AdminSubUsersGroup({
    required this.maxUsersAllowed,
    required this.totalUsers,
    required this.users,
  });
}
