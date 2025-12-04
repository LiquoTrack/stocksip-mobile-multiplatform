class UserDto {
  final String email;
  final String fullName;
  final String phoneNumber;
  final String profileId;
  final String profilePictureUrl;
  final String profileRole;
  final String role;
  final String userId;

  const UserDto({
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.profileId,
    required this.profilePictureUrl,
    required this.profileRole,
    required this.role,
    required this.userId,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      profileId: json['profileId'] as String? ?? '',
      profilePictureUrl: json['profilePictureUrl'] as String? ?? '',
      profileRole: json['profileRole'] as String? ?? '',
      role: json['role'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
    );
  }
}