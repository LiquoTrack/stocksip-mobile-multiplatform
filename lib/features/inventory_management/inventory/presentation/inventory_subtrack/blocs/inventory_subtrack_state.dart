import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/models/inventory_response.dart';

/// State class for managing inventory subtraction
/// Includes status, messages, inventories,
class InventorySubtrackState {
  final Status status;
  final String? message;

  final List<InventoryResponse> inventories;

  final String currentQuantity;

  final String selectedProductId;
  final int quantityToSubtract;
  final DateTime? expirationDate;
  final String exitReason;

  /// Constructor for [InventorySubtrackState]
  const InventorySubtrackState({
    this.status = Status.initial,
    this.message,
    this.inventories = const [],
    this.currentQuantity = '',
    this.selectedProductId = '',
    this.quantityToSubtract = 0,
    this.expirationDate,
    this.exitReason = '',
  });

  /// Creates a copy of the current state with optional new values
  InventorySubtrackState copyWith({
    Status? status,
    String? message,
    List<InventoryResponse>? inventories,
    String? currentQuantity,
    String? selectedProductId,
    int? quantityToSubtract,
    DateTime? expirationDate,
    String? exitReason,
  }) {
    return InventorySubtrackState(
      status: status ?? this.status,
      message: message ?? this.message,
      inventories: inventories ?? this.inventories,
      currentQuantity: currentQuantity ?? this.currentQuantity,
      selectedProductId: selectedProductId ?? this.selectedProductId,
      quantityToSubtract: quantityToSubtract ?? this.quantityToSubtract,
      expirationDate: expirationDate ?? this.expirationDate,
      exitReason: exitReason ?? this.exitReason,
    );
  }
}