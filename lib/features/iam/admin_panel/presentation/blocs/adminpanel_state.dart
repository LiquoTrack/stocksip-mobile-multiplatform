import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/iam/admin_panel/domain/models/sub_user.dart';

class AdminPanelState {
  final Status status;
  final String selectedRole;
  final List<AdminSubUsersGroup> groups;
  final String? message;
  final bool selectionMode;
  final Set<String> selectedIds;

  const AdminPanelState({
    this.status = Status.initial,
    this.selectedRole = 'All',
    this.groups = const [],
    this.message,
    this.selectionMode = false,
    this.selectedIds = const {},
  });

  AdminPanelState copyWith({
    Status? status,
    String? selectedRole,
    List<AdminSubUsersGroup>? groups,
    String? message,
    bool? selectionMode,
    Set<String>? selectedIds,
  }) {
    return AdminPanelState(
      status: status ?? this.status,
      selectedRole: selectedRole ?? this.selectedRole,
      groups: groups ?? this.groups,
      message: message,
      selectionMode: selectionMode ?? this.selectionMode,
      selectedIds: selectedIds ?? this.selectedIds,
    );
  }
}
