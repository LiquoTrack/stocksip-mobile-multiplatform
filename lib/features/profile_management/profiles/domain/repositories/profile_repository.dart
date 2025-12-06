import 'package:stocksip/features/profile_management/profiles/domain/profile.dart';

/// Abstract repository for profile-related operations
abstract class ProfileRepository {
  /// Fetches the user's profile information
  Future<Profile> getProfile();

  /// Updates the user's profile information
  Future<Profile> updateProfile({
    required String profileId,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String assignedRole,
  });

  /// Updates profile with optional image upload in a single request
  Future<Profile> updateProfileWithImage({
    required String profileId,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String assignedRole,
    String? imagePath,
  });

  /// Uploads a profile picture for the user
  Future<String> uploadProfilePicture({
    required String profileId,
    required String imagePath,
  });
}
