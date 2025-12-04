abstract class AdminPanelEvent {}

class LoadSubUsers extends AdminPanelEvent {
  final String role;
  final String? accountId;
  LoadSubUsers(this.role, {this.accountId});
}

class ToggleSelectionMode extends AdminPanelEvent {
  final bool enable;
  ToggleSelectionMode(this.enable);
}

class ToggleSelectUser extends AdminPanelEvent {
  final String userId;
  ToggleSelectUser(this.userId);
}

class ClearSelection extends AdminPanelEvent {}

class DeleteSelected extends AdminPanelEvent {}
