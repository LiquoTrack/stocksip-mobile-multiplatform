import 'package:stocksip/features/profile_management/profiles/data/services/remote/profile_service.dart';
import 'package:stocksip/features/profile_management/profiles/domain/profile.dart';
import 'package:stocksip/features/profile_management/profiles/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileService _service;

  ProfileRepositoryImpl({required ProfileService service}) : _service = service;

  @override
  Future<Profile> getProfile() async {
    return await _service.getProfile();
  }

  @override
  Future<Profile> updateProfile({
    required String profileId,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String assignedRole,
  }) async {
    return await _service.updateProfile(
      profileId: profileId,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      assignedRole: assignedRole,
    );
  }

  @override
  Future<String> uploadProfilePicture({
    required String profileId,
    required String imagePath,
  }) async {
    return await _service.uploadProfilePicture(
      profileId: profileId,
      imagePath: imagePath,
    );
  }

  @override
  Future<Profile> updateProfileWithImage({
    required String profileId,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String assignedRole,
    String? imagePath,
  }) async {
    return await _service.updateProfileWithImage(
      profileId: profileId,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      assignedRole: assignedRole,
      imagePath: imagePath,
    );
  }
}
