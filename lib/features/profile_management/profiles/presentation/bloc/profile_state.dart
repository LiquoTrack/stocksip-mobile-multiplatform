import 'package:stocksip/core/enums/status.dart';

/// Represents the state of the profile feature
class ProfileState {
  final Status status;
  final String firstName;
  final String lastName;
  final String fullName;
  final String phoneNumber;
  final String contactNumber;
  final String profilePictureUrl;
  final String assignedRole;
  final String userId;
  final String profileId;
  final bool isEditMode;
  final String? selectedImageUri;
  final String? message;

  const ProfileState({
    this.status = Status.initial,
    this.firstName = '',
    this.lastName = '',
    this.fullName = '',
    this.phoneNumber = '',
    this.contactNumber = '',
    this.profilePictureUrl = '',
    this.assignedRole = '',
    this.userId = '',
    this.profileId = '',
    this.isEditMode = false,
    this.selectedImageUri,
    this.message,
  });

  /// Creates a copy of the current ProfileState with optional new values
  ProfileState copyWith({
    Status? status,
    String? firstName,
    String? lastName,
    String? fullName,
    String? phoneNumber,
    String? contactNumber,
    String? profilePictureUrl,
    String? assignedRole,
    String? userId,
    String? profileId,
    bool? isEditMode,
    String? selectedImageUri,
    String? message,
  }) {
    return ProfileState(
      status: status ?? this.status,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      contactNumber: contactNumber ?? this.contactNumber,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      assignedRole: assignedRole ?? this.assignedRole,
      userId: userId ?? this.userId,
      profileId: profileId ?? this.profileId,
      isEditMode: isEditMode ?? this.isEditMode,
      selectedImageUri: selectedImageUri ?? this.selectedImageUri,
      message: message ?? this.message,
    );
  }
}
