import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory/widgets/inventory_selector_field.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_transfer/blocs/inventory_transfer_bloc.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_transfer/blocs/inventory_transfer_event.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_transfer/blocs/inventory_transfer_state.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_transfer/widgets/warehouse_selector_field.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/components/text_field.dart';

class InventoryTransferPage extends StatefulWidget {
  final String warehouseId;

  const InventoryTransferPage({super.key, required this.warehouseId});

  @override
  State<InventoryTransferPage> createState() => _InventoryTransferPageState();
}

class _InventoryTransferPageState extends State<InventoryTransferPage> {
  final _formKey = GlobalKey<FormState>();

  late final List<TextEditingController> _controllers;
  final TextEditingController _stockToTransferController =
      TextEditingController();

  String selectedWarehouseId = '';
  String selectedProductId = '';

  bool _isButtonEnabled = false;
  bool _waitingForSubmitResult = false;

  @override
  void initState() {
    super.initState();

    _controllers = [_stockToTransferController];

    context.read<InventoryTransferBloc>().add(
      LoadProductAndWarehouseListToTransferEvent(widget.warehouseId),
    );

    for (var controller in _controllers) {
      controller.addListener(_updateButtonState);
    }

    _updateButtonState();
  }

  void _updateButtonState() {
    final allFilled = _controllers.every((c) => c.text.isNotEmpty);

    final currentState = context.read<InventoryTransferBloc>().state;
    final shouldEnable = allFilled && currentState.status != Status.failure;
    if (shouldEnable != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = shouldEnable;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InventoryTransferBloc, InventoryTransferState>(
      listener: (context, state) {
        if (!_waitingForSubmitResult) return;

        if (state.status == Status.success) {
          _waitingForSubmitResult = false;
          Navigator.pop(context, true);
        }

        if (state.status == Status.failure && state.message.isNotEmpty) {
          _waitingForSubmitResult = false;
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Error"),
              content: Text(state.message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          top: 16,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transfer Stock',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                BlocBuilder<InventoryTransferBloc, InventoryTransferState>(
                  builder: (context, state) {
                    return WarehouseSelectorField(
                      warehouses: state.warehouses,
                      selectedWarehouseId: state.selectedWarehouseId,
                      onItemSelected: (warehouseId) {
                        context.read<InventoryTransferBloc>().add(
                          UpdateSelectedWarehouseToTransferEvent(warehouseId),
                        );
                        _updateButtonState();
                      },
                    );
                  },
                ),

                const SizedBox(height: 24),

                BlocBuilder<InventoryTransferBloc, InventoryTransferState>(
                  builder: (context, state) {
                    return InventorySelectorField(
                      inventories: state.inventories,
                      selectedInventoryId: state.selectedInventoryId,
                      selectedProductId: state.selectedProductId,
                      onProductSelected: (inventoryId, productId) {
                        context.read<InventoryTransferBloc>().add(
                          UpdateSelectedProductToTransferEvent(inventoryId, productId),
                        );
                        _updateButtonState();
                      },
                    );
                  },
                ),

                const SizedBox(height: 24),

                CustomTextField(
                  controller: _stockToTransferController,
                  label: 'Stock To Transfer',
                  hint: 'Enter the quantity to transfer',
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isButtonEnabled ? _onSubmit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isButtonEnabled
                          ? const Color(0xFF2B000D)
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Transfer from Warehouse',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final bloc = context.read<InventoryTransferBloc>();

    bloc.add(ValidateStockToTransferEvent(_stockToTransferController.text));

    final currentState = bloc.state;
    if (currentState.status == Status.failure) return;

    _waitingForSubmitResult = true;

    context.read<InventoryTransferBloc>().add(
      ExecuteInventoryTransferEvent(
        sourceWarehouseId: widget.warehouseId,
        destinationWarehouseId: currentState.selectedWarehouseId,
        productId: currentState.selectedProductId,
        quantityToTransfer: currentState.quantityToTransfer,
        expirationDate: currentState.expirationDate,
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
