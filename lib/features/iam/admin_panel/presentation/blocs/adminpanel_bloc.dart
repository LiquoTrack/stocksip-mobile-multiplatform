import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/iam/admin_panel/domain/repositories/adminpanel_repository.dart';
import 'package:stocksip/features/iam/admin_panel/presentation/blocs/adminpanel_event.dart';
import 'package:stocksip/features/iam/admin_panel/presentation/blocs/adminpanel_state.dart';

class AdminPanelBloc extends Bloc<AdminPanelEvent, AdminPanelState> {
  final AdminPanelRepository repository;

  AdminPanelBloc({required this.repository}) : super(const AdminPanelState()) {
    on<LoadSubUsers>(_onLoadSubUsers);
    on<ToggleSelectionMode>(_onToggleSelectionMode);
    on<ToggleSelectUser>(_onToggleSelectUser);
    on<ClearSelection>(_onClearSelection);
    on<DeleteSelected>(_onDeleteSelected);
  }

  FutureOr<void> _onLoadSubUsers(
    LoadSubUsers event,
    Emitter<AdminPanelState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, selectedRole: event.role));
    try {
      final groups = await repository.fetchSubUsers(role: event.role, accountId: event.accountId);
      emit(state.copyWith(status: Status.success, groups: groups));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  void _onToggleSelectionMode(
    ToggleSelectionMode event,
    Emitter<AdminPanelState> emit,
  ) {
    emit(state.copyWith(
      selectionMode: event.enable,
      selectedIds: event.enable ? state.selectedIds : <String>{},
    ));
  }

  void _onToggleSelectUser(
    ToggleSelectUser event,
    Emitter<AdminPanelState> emit,
  ) {
    final next = Set<String>.from(state.selectedIds);
    if (next.contains(event.userId)) {
      next.remove(event.userId);
    } else {
      next.add(event.userId);
    }
    emit(state.copyWith(selectedIds: next));
  }

  void _onClearSelection(
    ClearSelection event,
    Emitter<AdminPanelState> emit,
  ) {
    emit(state.copyWith(selectionMode: false, selectedIds: <String>{}));
  }

  FutureOr<void> _onDeleteSelected(
    DeleteSelected event,
    Emitter<AdminPanelState> emit,
  ) async {
    try {
      final ids = state.selectedIds;
      if (ids.isEmpty) {
        emit(state.copyWith(selectionMode: false));
        return;
      }

      final Map<String, String> idToProfile = {};
      for (final group in state.groups) {
        for (final u in group.users) {
          idToProfile[u.userId] = u.profileId;
        }
      }

      for (final userId in ids) {
        final profileId = idToProfile[userId];
        if (profileId != null && profileId.isNotEmpty) {
          await repository.deleteUser(userId, profileId);
        }
      }

      emit(state.copyWith(selectionMode: false, selectedIds: <String>{}));
      add(LoadSubUsers(state.selectedRole));
    } catch (e) {
      emit(state.copyWith(message: e.toString()));
    }
  }
}
