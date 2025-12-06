import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory/widgets/inventory_selector_field.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_subtrack/blocs/inventory_subtrack_bloc.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_subtrack/blocs/inventory_subtrack_event.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_subtrack/blocs/inventory_subtrack_state.dart';
import 'package:stocksip/shared/presentation/widgets/text_field.dart';

class InventorySubtrackPage extends StatefulWidget {
  final String warehouseId;

  const InventorySubtrackPage({super.key, required this.warehouseId});

  @override
  State<InventorySubtrackPage> createState() => _InventorySubtrackPageState();
}

class _InventorySubtrackPageState extends State<InventorySubtrackPage> {
  final _formKey = GlobalKey<FormState>();

  late final List<TextEditingController> _controllers;
  final TextEditingController _stockToSubtrackController =
      TextEditingController();
  final TextEditingController _exitReasonController = TextEditingController();

  String selectedProductId = '';
  bool _isButtonEnabled = false;
  bool _waitingForSubmitResult = false;

  @override
  void initState() {
    super.initState();

    _controllers = [_stockToSubtrackController, _exitReasonController];

    context.read<InventorySubtrackBloc>().add(
      LoadProductListToSubtrackEvent(widget.warehouseId),
    );

    for (var controller in _controllers) {
      controller.addListener(_updateButtonState);
    }

    _updateButtonState();
  }

  void _updateButtonState() {
    final allFilled = _controllers.every((c) => c.text.isNotEmpty);

    final currentState = context.read<InventorySubtrackBloc>().state;
    final shouldEnable = allFilled && currentState.status != Status.failure;
    if (shouldEnable != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = shouldEnable;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InventorySubtrackBloc, InventorySubtrackState>(
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
                  'Subtrack Stock',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                BlocBuilder<InventorySubtrackBloc, InventorySubtrackState>(
                  builder: (context, state) {
                    return InventorySelectorField(
                      inventories: state.inventories,
                      selectedProductId: state.selectedProductId,
                      selectedInventoryId: state.selectedInventoryId,
                      onProductSelected: (inventoryId, productId) {
                        context.read<InventorySubtrackBloc>().add(
                          UpdateSelectedProductToSubtrackEvent(inventoryId, productId),
                        );
                        _updateButtonState();
                      },
                    );
                  },
                ),

                const SizedBox(height: 32),

                CustomTextField(
                  controller: _stockToSubtrackController,
                  label: 'Stock To Subtrack',
                  hint: 'Enter the quantity to subtrack',
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller: _exitReasonController,
                  label: 'Exit Reason',
                  hint: 'Enter the reason for exit',
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
                      'Subtrack from Warehouse',
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

    final bloc = context.read<InventorySubtrackBloc>();

    bloc.add(ValidateStockToSubtrackEvent(_stockToSubtrackController.text));

    final currentState = bloc.state;
    if (currentState.status == Status.failure) return;

    _waitingForSubmitResult = true;

    context.read<InventorySubtrackBloc>().add(
      SubmitInventorySubtrackEvent(
        warehouseId: widget.warehouseId,
        productId: currentState.selectedProductId,
        quantityToSubtrack: currentState.quantityToSubtract,
        expirationDate: currentState.expirationDate,
        exitReason: _exitReasonController.text,
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
