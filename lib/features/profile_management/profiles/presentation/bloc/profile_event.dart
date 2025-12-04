/// Represents the various events that can occur in the profile feature
abstract class ProfileEvent {
  const ProfileEvent();
}

/// Event to load the user profile
class LoadProfileEvent extends ProfileEvent {
  const LoadProfileEvent();
}

/// Event triggered when the first name field changes
class OnFirstNameChanged extends ProfileEvent {
  final String firstName;
  const OnFirstNameChanged({required this.firstName});
}

/// Event triggered when the last name field changes
class OnLastNameChanged extends ProfileEvent {
  final String lastName;
  const OnLastNameChanged({required this.lastName});
}

/// Event triggered when the phone number field changes
class OnPhoneNumberChanged extends ProfileEvent {
  final String phoneNumber;
  const OnPhoneNumberChanged({required this.phoneNumber});
}

/// Event triggered when the assigned role field changes
class OnAssignedRoleChanged extends ProfileEvent {
  final String assignedRole;
  const OnAssignedRoleChanged({required this.assignedRole});
}

/// Event to toggle between edit and view mode
class ToggleEditModeEvent extends ProfileEvent {
  const ToggleEditModeEvent();
}

/// Event triggered when an image is selected
class OnImageSelected extends ProfileEvent {
  final String imagePath;
  const OnImageSelected({required this.imagePath});
}

/// Event to save the profile changes
class SaveProfileEvent extends ProfileEvent {
  const SaveProfileEvent();
}

/// Event to clear the message
class ClearMessageEvent extends ProfileEvent {
  const ClearMessageEvent();
}

/// Event triggered on logout
class LogoutEvent extends ProfileEvent {
  const LogoutEvent();
}
