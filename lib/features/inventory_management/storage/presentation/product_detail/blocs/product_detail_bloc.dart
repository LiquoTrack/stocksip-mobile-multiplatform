import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/storage/domain/repositories/product_repository.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/product_detail/blocs/product_detail_event.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/product_detail/blocs/product_detail_state.dart';

/// Bloc to manage the state of product details in the inventory management feature.
class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductRepository productRepository;

  /// Creates a [ProductDetailBloc] with the given [productRepository].
  ProductDetailBloc({required this.productRepository})
    : super(ProductDetailState()) {
    on<LoadProductDetailEvent>(_onLoadProductDetail);
  }

  /// Handles the [LoadProductDetailEvent] to load product details.
  FutureOr<void> _onLoadProductDetail(
    LoadProductDetailEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    try {

      final productDetail = await productRepository.getProductById(productId: event.productId);
      emit(state.copyWith(status: Status.success, selectedProduct: productDetail));

    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }
}
