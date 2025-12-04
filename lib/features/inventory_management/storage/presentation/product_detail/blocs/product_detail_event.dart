/// Events for ProductDetailBloc
abstract class ProductDetailEvent {
  const ProductDetailEvent();
}

/// Event to load product details
class LoadProductDetailEvent extends ProductDetailEvent {
  final String productId;

  const LoadProductDetailEvent(this.productId);
}