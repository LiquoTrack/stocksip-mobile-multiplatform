class Profile {
  final String id;
  final String firstName;
  final String lastName;
  final String fullName;
  final String phoneNumber;
  final String contactNumber;
  final String? profilePictureUrl;
  final String userId;
  final String assignedRole;

  Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.phoneNumber,
    required this.contactNumber,
    this.profilePictureUrl,
    required this.userId,
    required this.assignedRole,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      contactNumber: json['contactNumber'] as String,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      userId: json['userId'] as String,
      assignedRole: json['assignedRole'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'contactNumber': contactNumber,
      'profilePictureUrl': profilePictureUrl,
      'userId': userId,
      'assignedRole': assignedRole,
    };
  }

  Profile copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? fullName,
    String? phoneNumber,
    String? contactNumber,
    String? profilePictureUrl,
    String? userId,
    String? assignedRole,
  }) {
    return Profile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      contactNumber: contactNumber ?? this.contactNumber,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      userId: userId ?? this.userId,
      assignedRole: assignedRole ?? this.assignedRole,
    );
  }

  @override
  String toString() =>
      'Profile(id: $id, firstName: $firstName, lastName: $lastName, fullName: $fullName, phoneNumber: $phoneNumber, contactNumber: $contactNumber, profilePictureUrl: $profilePictureUrl, userId: $userId, assignedRole: $assignedRole)';
}
