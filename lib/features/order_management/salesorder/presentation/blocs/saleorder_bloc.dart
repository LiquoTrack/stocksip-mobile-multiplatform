import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/order_management/salesorder/domain/models/saleorder.dart';
import 'package:stocksip/features/order_management/salesorder/domain/repositories/salesorder_repository.dart';
import 'package:stocksip/features/order_management/salesorder/presentation/blocs/saleorder_event.dart';
import 'package:stocksip/features/order_management/salesorder/presentation/blocs/saleorder_state.dart';

class SaleorderBloc extends Bloc<SaleorderEvent, SaleorderState> {
  final SalesorderRepository repository;

  SaleorderBloc({required this.repository}) : super(const SaleorderState()) {
    on<CreateFromProcurementEvent>(_onCreateFromProcurement);
    on<ClearSaleorderMessage>((event, emit) => emit(state.copyWith(clearMessage: true)));
  }

  Future<void> _onCreateFromProcurement(
    CreateFromProcurementEvent event,
    Emitter<SaleorderState> emit,
  ) async {
    try {
      emit(state.copyWith(status: Status.loading, purchaseOrderId: event.purchaseOrderId));
      if (event.purchaseOrderId.isEmpty) {
        throw Exception('Invalid Purchase Order ID');
      }

      final Saleorder created = await repository.createFromProcurement(event.purchaseOrderId);
      final updated = List<Saleorder>.of(state.orders)..insert(0, created);

      emit(state.copyWith(
        status: Status.success,
        orders: updated,
        lastCreated: created,
        message: 'Sales order ${created.orderCode.isNotEmpty ? created.orderCode : created.id} created',
      ));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }
}