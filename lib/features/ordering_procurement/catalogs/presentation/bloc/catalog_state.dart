import 'package:stocksip/core/enums/status.dart';
import '../../domain/models/catalog.dart';

/// Represents the state of the catalog feature
class CatalogState {
  final Status status;
  final List<Catalog> catalogs;
  final Catalog? selectedCatalog;
  final String? message;
  final bool isEditMode;

  const CatalogState({
    this.status = Status.initial,
    this.catalogs = const [],
    this.selectedCatalog,
    this.message,
    this.isEditMode = false,
  });

  /// Creates a copy of the current CatalogState with optional new values
  CatalogState copyWith({
    Status? status,
    List<Catalog>? catalogs,
    Catalog? selectedCatalog,
    String? message,
    bool? isEditMode,
  }) {
    return CatalogState(
      status: status ?? this.status,
      catalogs: catalogs ?? this.catalogs,
      selectedCatalog: selectedCatalog ?? this.selectedCatalog,
      message: message ?? this.message,
      isEditMode: isEditMode ?? this.isEditMode,
    );
  }
}
