import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/entities/careguide_response.dart';

/// Represents the state of the careguide feature in the inventory management system.
/// Includes the current status, a list of careguides, and an optional message.
/// Used in state management to track and update the careguide state.
class CareguideState{
  final Status status;
  final List<CareguideResponse> guides;
  final String? message;

  /// Creates a new instance of [CareguideState].
  /// [status] indicates the current status of the careguide feature.
  /// [guides] is a list of careguides.
  /// [message] is an optional field for any relevant messages.
  CareguideState({
    this.status = Status.initial,
    this.guides = const [],
    this.message,
  });

  /// Creates a copy of the current [CareguideState] with optional new values.
  /// This allows for immutability while updating specific fields.
  CareguideState copyWith({
    Status? status,
    List<CareguideResponse>? guides,
    String? message,
  }) {
    return CareguideState(
      status: status ?? this.status,
      guides: guides ?? this.guides,
      message: message,
    );
  }
}