import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'profile_event.dart';
import 'profile_state.dart';

/// BLoC to manage profile-related events and states
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
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
      // TODO: Implement API call to load profile
      // This is where you would fetch profile data from your service
      
      emit(
        state.copyWith(
          status: Status.success,
          firstName: 'John',
          lastName: 'Doe',
          fullName: 'John Doe',
          phoneNumber: '+1234567890',
          contactNumber: '+0987654321',
          assignedRole: 'Manager',
          profilePictureUrl: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          message: 'Failed to load profile: ${e.toString()}',
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
    emit(state.copyWith(status: Status.loading));
    try {
      // TODO: Implement API call to save profile
      // This is where you would send the updated profile data to your service
      
      emit(
        state.copyWith(
          status: Status.success,
          isEditMode: false,
          selectedImageUri: null,
          message: 'Profile saved successfully',
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
    emit(state.copyWith(status: Status.failure, message: 'Logged out'));
  }
}
