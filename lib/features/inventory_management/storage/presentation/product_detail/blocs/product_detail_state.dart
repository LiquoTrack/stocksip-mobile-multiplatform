import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/product_response.dart';

/// State class for managing product details in inventory management.
class ProductDetailState {
  final String? message;
  final Status status;
  final ProductResponse? selectedProduct;

  /// Constructor for [ProductDetailState].
  const ProductDetailState({
    this.message,
    this.status = Status.initial,
    this.selectedProduct,
  });

  /// Creates a copy of the current state with optional new values.
  ProductDetailState copyWith({
    String? message,
    Status? status,
    ProductResponse? selectedProduct,
  }) {
    return ProductDetailState(
      message: message ?? this.message,
      status: status ?? this.status,
      selectedProduct: selectedProduct ?? this.selectedProduct,
    );
  }
}