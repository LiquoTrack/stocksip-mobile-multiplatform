import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/inventory/domain/models/inventory_response.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/product_response.dart';

/// State class for managing inventory addition
/// Includes status, messages, inventories, products,
class InventoryAdditionState {
  final Status status;
  final String message;

  final List<InventoryResponse> inventories;
  final List<ProductResponse> products;

  final String selectedProductId;
  final int quantityToAdd;
  final DateTime? expirationDate;

  /// Constructor for [InventoryAdditionState]
  const InventoryAdditionState({
    this.status = Status.initial,
    this.message = '',
    this.inventories = const [],
    this.products = const [],
    this.selectedProductId = '',
    this.quantityToAdd = 0,
    this.expirationDate,
  });

  /// Creates a copy of the current state with optional new values
  InventoryAdditionState copyWith({
    Status? status,
    String? message,
    List<InventoryResponse>? inventories,
    List<ProductResponse>? products,
    String? selectedProductId,
    int? quantityToAdd,
    DateTime? expirationDate,
  }) {
    return InventoryAdditionState(
      status: status ?? this.status,
      message: message ?? this.message,
      inventories: inventories ?? this.inventories,
      products: products ?? this.products,
      selectedProductId: selectedProductId ?? this.selectedProductId,
      quantityToAdd: quantityToAdd ?? this.quantityToAdd,
      expirationDate: expirationDate ?? this.expirationDate,
    );
  }
}