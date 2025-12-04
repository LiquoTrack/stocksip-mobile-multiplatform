class SubUserRequestDto {
  final String name;
  final String email;
  final String password;
  final String role;
  final String phoneNumber;
  final String profileRole;

  SubUserRequestDto({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.phoneNumber,
    required this.profileRole,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
        'phoneNumber': phoneNumber,
        'profileRole': profileRole,
      };
}
