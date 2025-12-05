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
    on<GetAllOrdersEvent>(_onGetAllOrders);
    on<ClearSaleorderMessage>((event, emit) => emit(state.copyWith(clearMessage: true)));
    on<ConfirmOrderEvent>(_onConfirmOrder);
    on<ReceiveOrderEvent>(_onReceiveOrder);
    on<ShipOrderEvent>(_onShipOrder);
    on<CancelOrderEvent>(_onCancelOrder);
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

  Future<void> _onGetAllOrders(
    GetAllOrdersEvent event,
    Emitter<SaleorderState> emit,
  ) async {
    try {
      emit(state.copyWith(status: Status.loading));
      
      print('>>> [SaleorderBloc] GetAllOrdersEvent triggered with accountId: ${event.accountId}');
      final orders = await repository.getAllOrders(accountId: event.accountId);
      print('>>> [SaleorderBloc] Orders fetched: ${orders.length}');
      
      emit(state.copyWith(
        status: Status.success,
        orders: orders,
        message: 'Orders loaded successfully',
      ));
    } catch (e) {
      print('>>> [SaleorderBloc] Error: $e');
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  Future<void> _onConfirmOrder(
    ConfirmOrderEvent event,
    Emitter<SaleorderState> emit,
  ) async {
    try {
      emit(state.copyWith(status: Status.loading));
      print('>>> [SaleorderBloc] Confirming order: ${event.orderId}');
      await repository.confirmOrder(event.orderId);
      print('>>> [SaleorderBloc] Order confirmed successfully');
      emit(state.copyWith(
        status: Status.success,
        message: 'Order confirmed successfully',
      ));
    } catch (e) {
      print('>>> [SaleorderBloc] Error confirming order: $e');
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  Future<void> _onReceiveOrder(
    ReceiveOrderEvent event,
    Emitter<SaleorderState> emit,
  ) async {
    try {
      emit(state.copyWith(status: Status.loading));
      print('>>> [SaleorderBloc] Marking order as received: ${event.orderId}');
      await repository.receiveOrder(event.orderId);
      print('>>> [SaleorderBloc] Order marked as received');
      emit(state.copyWith(
        status: Status.success,
        message: 'Order marked as received',
      ));
    } catch (e) {
      print('>>> [SaleorderBloc] Error marking order as received: $e');
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  Future<void> _onShipOrder(
    ShipOrderEvent event,
    Emitter<SaleorderState> emit,
  ) async {
    try {
      emit(state.copyWith(status: Status.loading));
      print('>>> [SaleorderBloc] Marking order as shipped: ${event.orderId}');
      await repository.shipOrder(event.orderId);
      print('>>> [SaleorderBloc] Order marked as shipped');
      emit(state.copyWith(
        status: Status.success,
        message: 'Order marked as shipped',
      ));
    } catch (e) {
      print('>>> [SaleorderBloc] Error marking order as shipped: $e');
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  Future<void> _onCancelOrder(
    CancelOrderEvent event,
    Emitter<SaleorderState> emit,
  ) async {
    try {
      emit(state.copyWith(status: Status.loading));
      print('>>> [SaleorderBloc] Canceling order: ${event.orderId}');
      await repository.cancelOrder(event.orderId);
      print('>>> [SaleorderBloc] Order canceled successfully');
      emit(state.copyWith(
        status: Status.success,
        message: 'Order canceled successfully',
      ));
    } catch (e) {
      print('>>> [SaleorderBloc] Error canceling order: $e');
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }
}
