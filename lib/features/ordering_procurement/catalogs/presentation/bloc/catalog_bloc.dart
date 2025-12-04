import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import '../../domain/repositories/catalog_repository.dart';
import 'catalog_event.dart';
import 'catalog_state.dart';

/// BLoC to manage catalog-related events and states
class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final CatalogRepository _repository;

  CatalogBloc({required CatalogRepository repository})
      : _repository = repository,
        super(const CatalogState()) {
    on<LoadCatalogsByAccountId>(_onLoadCatalogsByAccountId);
    on<LoadAccountWithCatalogs>(_onLoadAccountWithCatalogs);
    on<LoadPublishedCatalogs>(_onLoadPublishedCatalogs);
    on<LoadAllCatalogs>(_onLoadAllCatalogs);
    on<LoadCatalogById>(_onLoadCatalogById);
    on<CreateCatalog>(_onCreateCatalog);
    on<UpdateCatalog>(_onUpdateCatalog);
    on<AddCatalogItem>(_onAddCatalogItem);
    on<RemoveCatalogItem>(_onRemoveCatalogItem);
    on<PublishCatalog>(_onPublishCatalog);
    on<UnpublishCatalog>(_onUnpublishCatalog);
    on<ToggleEditMode>(_onToggleEditMode);
    on<ClearMessage>(_onClearMessage);
  }

  FutureOr<void> _onLoadCatalogsByAccountId(
    LoadCatalogsByAccountId event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final catalogs = await _repository.getCatalogsByAccountId(event.accountId);
      emit(
        state.copyWith(
          status: Status.success,
          catalogs: catalogs,
        ),
      );
    } catch (e) {
      final errorMessage = e.toString();
      String message = 'Failed to load catalogs: $errorMessage';
      
      if (errorMessage.contains('404')) {
        message = 'No catalogs found.';
      } else if (errorMessage.contains('401') || errorMessage.contains('Unauthorized')) {
        message = 'Session expired. Please login again.';
      } else if (errorMessage.contains('network') || errorMessage.contains('Failed to establish')) {
        message = 'Network connection error. Please check your internet.';
      }
      
      emit(
        state.copyWith(
          status: Status.failure,
          message: message,
        ),
      );
    }
  }

  FutureOr<void> _onLoadAccountWithCatalogs(
    LoadAccountWithCatalogs event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final supplierInfo = await _repository.getAccountWithCatalogs(event.accountId);
      emit(
        state.copyWith(
          status: Status.success,
          catalogs: supplierInfo.catalogs,
        ),
      );
    } catch (e) {
      final errorMessage = e.toString();
      String message = 'Failed to load account catalogs: $errorMessage';
      
      if (errorMessage.contains('401') || errorMessage.contains('Unauthorized')) {
        message = 'Session expired. Please login again.';
      } else if (errorMessage.contains('network') || errorMessage.contains('Failed to establish')) {
        message = 'Network connection error. Please check your internet.';
      }
      
      emit(
        state.copyWith(
          status: Status.failure,
          message: message,
        ),
      );
    }
  }

  FutureOr<void> _onLoadPublishedCatalogs(
    LoadPublishedCatalogs event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final catalogs = await _repository.getPublishedCatalogs();
      emit(
        state.copyWith(
          status: Status.success,
          catalogs: catalogs,
        ),
      );
    } catch (e) {
      final errorMessage = e.toString();
      String message = 'Failed to load published catalogs: $errorMessage';
      
      if (errorMessage.contains('401') || errorMessage.contains('Unauthorized')) {
        message = 'Session expired. Please login again.';
      } else if (errorMessage.contains('network') || errorMessage.contains('Failed to establish')) {
        message = 'Network connection error. Please check your internet.';
      }
      
      emit(
        state.copyWith(
          status: Status.failure,
          message: message,
        ),
      );
    }
  }

  FutureOr<void> _onLoadAllCatalogs(
    LoadAllCatalogs event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final catalogs = await _repository.getAllCatalogs();
      emit(
        state.copyWith(
          status: Status.success,
          catalogs: catalogs,
        ),
      );
    } catch (e) {
      final errorMessage = e.toString();
      String message = 'Failed to load catalogs: $errorMessage';
      
      if (errorMessage.contains('401') || errorMessage.contains('Unauthorized')) {
        message = 'Session expired. Please login again.';
      } else if (errorMessage.contains('network') || errorMessage.contains('Failed to establish')) {
        message = 'Network connection error. Please check your internet.';
      }
      
      emit(
        state.copyWith(
          status: Status.failure,
          message: message,
        ),
      );
    }
  }

  FutureOr<void> _onLoadCatalogById(
    LoadCatalogById event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final catalog = await _repository.getCatalogById(event.catalogId);
      emit(
        state.copyWith(
          status: Status.success,
          selectedCatalog: catalog,
        ),
      );
    } catch (e) {
      final errorMessage = e.toString();
      String message = 'Failed to load catalog: $errorMessage';
      
      if (errorMessage.contains('404')) {
        message = 'Catalog not found.';
      } else if (errorMessage.contains('401') || errorMessage.contains('Unauthorized')) {
        message = 'Session expired. Please login again.';
      } else if (errorMessage.contains('network') || errorMessage.contains('Failed to establish')) {
        message = 'Network connection error. Please check your internet.';
      }
      
      emit(
        state.copyWith(
          status: Status.failure,
          message: message,
        ),
      );
    }
  }

  FutureOr<void> _onCreateCatalog(
    CreateCatalog event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final catalog = await _repository.createCatalog(
        accountId: event.accountId,
        name: event.name,
        description: event.description,
        contactEmail: event.contactEmail,
      );
      
      final updatedCatalogs = [...state.catalogs, catalog];
      emit(
        state.copyWith(
          status: Status.success,
          catalogs: updatedCatalogs,
          message: 'Catalog created successfully',
        ),
      );
    } catch (e) {
      final errorMessage = e.toString();
      String message = 'Failed to create catalog: $errorMessage';
      
      if (errorMessage.contains('401') || errorMessage.contains('Unauthorized')) {
        message = 'Session expired. Please login again.';
      } else if (errorMessage.contains('network') || errorMessage.contains('Failed to establish')) {
        message = 'Network connection error. Please check your internet.';
      }
      
      emit(
        state.copyWith(
          status: Status.failure,
          message: message,
        ),
      );
    }
  }

  FutureOr<void> _onUpdateCatalog(
    UpdateCatalog event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final catalog = await _repository.updateCatalog(
        catalogId: event.catalogId,
        name: event.name,
        description: event.description,
        contactEmail: event.contactEmail,
      );
      
      final updatedCatalogs = state.catalogs.map((c) {
        return c.id == catalog.id ? catalog : c;
      }).toList();
      
      emit(
        state.copyWith(
          status: Status.success,
          catalogs: updatedCatalogs,
          selectedCatalog: catalog,
          message: 'Catalog updated successfully',
        ),
      );
    } catch (e) {
      final errorMessage = e.toString();
      String message = 'Failed to update catalog: $errorMessage';
      
      if (errorMessage.contains('401') || errorMessage.contains('Unauthorized')) {
        message = 'Session expired. Please login again.';
      } else if (errorMessage.contains('network') || errorMessage.contains('Failed to establish')) {
        message = 'Network connection error. Please check your internet.';
      }
      
      emit(
        state.copyWith(
          status: Status.failure,
          message: message,
        ),
      );
    }
  }

  FutureOr<void> _onAddCatalogItem(
    AddCatalogItem event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final catalog = await _repository.addCatalogItem(
        catalogId: event.catalogId,
        productId: event.productId,
        warehouseId: event.warehouseId,
        stock: event.stock,
      );
      
      final updatedCatalogs = state.catalogs.map((c) {
        return c.id == catalog.id ? catalog : c;
      }).toList();
      
      emit(
        state.copyWith(
          status: Status.success,
          catalogs: updatedCatalogs,
          selectedCatalog: catalog,
          message: 'Item added successfully',
        ),
      );
    } catch (e) {
      final errorMessage = e.toString();
      String message = 'Failed to add item: $errorMessage';
      
      if (errorMessage.contains('401') || errorMessage.contains('Unauthorized')) {
        message = 'Session expired. Please login again.';
      } else if (errorMessage.contains('network') || errorMessage.contains('Failed to establish')) {
        message = 'Network connection error. Please check your internet.';
      }
      
      emit(
        state.copyWith(
          status: Status.failure,
          message: message,
        ),
      );
    }
  }

  FutureOr<void> _onRemoveCatalogItem(
    RemoveCatalogItem event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final catalog = await _repository.removeCatalogItem(
        catalogId: event.catalogId,
        productId: event.productId,
      );
      
      final updatedCatalogs = state.catalogs.map((c) {
        return c.id == catalog.id ? catalog : c;
      }).toList();
      
      emit(
        state.copyWith(
          status: Status.success,
          catalogs: updatedCatalogs,
          selectedCatalog: catalog,
          message: 'Item removed successfully',
        ),
      );
    } catch (e) {
      final errorMessage = e.toString();
      String message = 'Failed to remove item: $errorMessage';
      
      if (errorMessage.contains('401') || errorMessage.contains('Unauthorized')) {
        message = 'Session expired. Please login again.';
      } else if (errorMessage.contains('network') || errorMessage.contains('Failed to establish')) {
        message = 'Network connection error. Please check your internet.';
      }
      
      emit(
        state.copyWith(
          status: Status.failure,
          message: message,
        ),
      );
    }
  }

  FutureOr<void> _onPublishCatalog(
    PublishCatalog event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      await _repository.publishCatalog(event.catalogId);
      
      // Reload the catalog to get the updated state
      final catalog = await _repository.getCatalogById(event.catalogId);
      final updatedCatalogs = state.catalogs.map((c) {
        return c.id == catalog.id ? catalog : c;
      }).toList();
      
      emit(
        state.copyWith(
          status: Status.success,
          catalogs: updatedCatalogs,
          selectedCatalog: catalog,
          message: 'Catalog published successfully',
        ),
      );
    } catch (e) {
      final errorMessage = e.toString();
      String message = 'Failed to publish catalog: $errorMessage';
      
      if (errorMessage.contains('401') || errorMessage.contains('Unauthorized')) {
        message = 'Session expired. Please login again.';
      } else if (errorMessage.contains('network') || errorMessage.contains('Failed to establish')) {
        message = 'Network connection error. Please check your internet.';
      }
      
      emit(
        state.copyWith(
          status: Status.failure,
          message: message,
        ),
      );
    }
  }

  FutureOr<void> _onUnpublishCatalog(
    UnpublishCatalog event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      await _repository.unpublishCatalog(event.catalogId);
      
      // Reload the catalog to get the updated state
      final catalog = await _repository.getCatalogById(event.catalogId);
      final updatedCatalogs = state.catalogs.map((c) {
        return c.id == catalog.id ? catalog : c;
      }).toList();
      
      emit(
        state.copyWith(
          status: Status.success,
          catalogs: updatedCatalogs,
          selectedCatalog: catalog,
          message: 'Catalog unpublished successfully',
        ),
      );
    } catch (e) {
      final errorMessage = e.toString();
      String message = 'Failed to unpublish catalog: $errorMessage';
      
      if (errorMessage.contains('401') || errorMessage.contains('Unauthorized')) {
        message = 'Session expired. Please login again.';
      } else if (errorMessage.contains('network') || errorMessage.contains('Failed to establish')) {
        message = 'Network connection error. Please check your internet.';
      }
      
      emit(
        state.copyWith(
          status: Status.failure,
          message: message,
        ),
      );
    }
  }

  FutureOr<void> _onToggleEditMode(
    ToggleEditMode event,
    Emitter<CatalogState> emit,
  ) {
    emit(state.copyWith(isEditMode: event.isEditMode));
  }

  FutureOr<void> _onClearMessage(
    ClearMessage event,
    Emitter<CatalogState> emit,
  ) {
    emit(state.copyWith(message: null));
  }
}
