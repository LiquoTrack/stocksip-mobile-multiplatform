import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/profile_management/profiles/domain/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

/// BLoC to manage profile-related events and states
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository;

  ProfileBloc({required ProfileRepository repository})
      : _repository = repository,
        super(const ProfileState()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<OnFirstNameChanged>(_onFirstNameChanged);
    on<OnLastNameChanged>(_onLastNameChanged);
    on<OnPhoneNumberChanged>(_onPhoneNumberChanged);
    on<OnAssignedRoleChanged>(_onAssignedRoleChanged);
    on<ToggleEditModeEvent>(_onToggleEditMode);
    on<OnImageSelected>(_onImageSelected);
    on<SaveProfileEvent>(_onSaveProfile);
    on<ClearMessageEvent>(_onClearMessage);
    on<LogoutEvent>(_onLogout);
  }

  FutureOr<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final profile = await _repository.getProfile();
      emit(
        state.copyWith(
          status: Status.success,
          firstName: profile.firstName,
          lastName: profile.lastName,
          fullName: profile.fullName,
          phoneNumber: profile.phoneNumber,
          contactNumber: profile.contactNumber,
          profilePictureUrl: profile.profilePictureUrl ?? '',
          assignedRole: profile.assignedRole,
          userId: profile.userId,
          profileId: profile.id,
        ),
      );
    } catch (e) {
      final errorMessage = e.toString();
      String message = 'Failed to load profile: $errorMessage';
      
      if (errorMessage.contains('404') || errorMessage.contains('Profile not found')) {
        message = 'No profile found. Please complete your profile first.';
      } else if (errorMessage.contains('401') || errorMessage.contains('Unauthorized')) {
        message = 'Session expired. Please login again.';
      } else if (errorMessage.contains('network') || errorMessage.contains('Failed to establish')) {
        message = 'Network connection error. Please check your internet.';
      }
      
      emit(
        state.copyWith(
          status: Status.failure,
          message: message,
        ),
      );
    }
  }

  FutureOr<void> _onFirstNameChanged(
    OnFirstNameChanged event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(firstName: event.firstName));
  }

  FutureOr<void> _onLastNameChanged(
    OnLastNameChanged event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(lastName: event.lastName));
  }

  FutureOr<void> _onPhoneNumberChanged(
    OnPhoneNumberChanged event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(phoneNumber: event.phoneNumber));
  }

  FutureOr<void> _onAssignedRoleChanged(
    OnAssignedRoleChanged event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(assignedRole: event.assignedRole));
  }

  FutureOr<void> _onToggleEditMode(
    ToggleEditModeEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(isEditMode: !state.isEditMode));
  }

  FutureOr<void> _onImageSelected(
    OnImageSelected event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(selectedImageUri: event.imagePath));
  }

  FutureOr<void> _onSaveProfile(
    SaveProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    // Validate required fields
    if (state.firstName.isEmpty) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: 'First Name is required',
        ),
      );
      return;
    }

    if (state.lastName.isEmpty) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: 'Last Name is required',
        ),
      );
      return;
    }

    if (state.phoneNumber.isEmpty) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: 'Phone Number is required',
        ),
      );
      return;
    }

    if (state.assignedRole.isEmpty) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: 'Assigned Role is required',
        ),
      );
      return;
    }

    // Backend ALWAYS requires ProfilePicture as an actual file
    // User must always select an image (new or existing)
    if (state.selectedImageUri == null || state.selectedImageUri!.isEmpty) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: 'Please select an image to update your profile',
        ),
      );
      return;
    }

    emit(state.copyWith(status: Status.loading));
    try {
      // Use the combined method that handles both data and image in one request
      await _repository.updateProfileWithImage(
        profileId: state.profileId,
        firstName: state.firstName,
        lastName: state.lastName,
        phoneNumber: state.phoneNumber,
        assignedRole: state.assignedRole,
        imagePath: state.selectedImageUri,
      );

      // Reload profile to get the latest data from server
      final refreshedProfile = await _repository.getProfile();

      emit(
        state.copyWith(
          status: Status.success,
          isEditMode: false,
          selectedImageUri: null,
          firstName: refreshedProfile.firstName,
          lastName: refreshedProfile.lastName,
          phoneNumber: refreshedProfile.phoneNumber,
          assignedRole: refreshedProfile.assignedRole,
          profilePictureUrl: refreshedProfile.profilePictureUrl ?? state.profilePictureUrl,
          message: 'Profile updated successfully',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: 'Failed to save profile: ${e.toString()}',
        ),
      );
    }
  }

  FutureOr<void> _onClearMessage(
    ClearMessageEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(message: null));
  }

  FutureOr<void> _onLogout(
    LogoutEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(const ProfileState());
  }
}
