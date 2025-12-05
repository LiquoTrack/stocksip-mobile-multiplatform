import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_addition/blocs/inventory_addition_bloc.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_addition/blocs/inventory_addition_event.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_addition/blocs/inventory_addition_state.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_addition/widgets/product_double_selector_field.dart';
import 'package:stocksip/shared/presentation/widgets/text_field.dart';
import 'package:stocksip/shared/presentation/widgets/writable_date_field.dart';

class InventoryAdditionPage extends StatefulWidget {
  final String warehouseId;

  const InventoryAdditionPage({super.key, required this.warehouseId});

  @override
  State<InventoryAdditionPage> createState() => _InventoryAdditionPageState();
}

class _InventoryAdditionPageState extends State<InventoryAdditionPage> {
  final _formKey = GlobalKey<FormState>();

  late final List<TextEditingController> _controllers;
  final TextEditingController _stockToAddController = TextEditingController();
  final TextEditingController _expirationDateController =
      TextEditingController();

  String selectedProductId = '';
  bool _isButtonEnabled = false;
  bool _waitingForSubmitResult = false;

  @override
  void initState() {
    super.initState();

    _controllers = [_stockToAddController, _expirationDateController];

    context.read<InventoryAdditionBloc>().add(
      LoadProductListEvent(widget.warehouseId),
    );

    for (var controller in _controllers) {
      controller.addListener(_updateButtonState);
    }

    _updateButtonState();
  }

  void _updateButtonState() {
    final allFilled = _controllers.every((c) => c.text.isNotEmpty);

    final currentState = context.read<InventoryAdditionBloc>().state;
    final shouldEnable = allFilled && currentState.status != Status.failure;
    if (shouldEnable != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = shouldEnable;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InventoryAdditionBloc, InventoryAdditionState>(
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
                  'Add Products',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                BlocBuilder<InventoryAdditionBloc, InventoryAdditionState>(
                  builder: (context, state) {
                    return ProductDoubleSelectorField(
                      products: state.products,
                      inventories: state.inventories,
                      selectedProductId: state.selectedProductId,
                      onProductSelected: (id) {
                        context.read<InventoryAdditionBloc>().add(
                          UpdateSelectedProductEvent(id),
                        );
                        _updateButtonState();
                      },
                    );
                  },
                ),

                const SizedBox(height: 32),

                CustomTextField(
                  controller: _stockToAddController,
                  label: 'Stock To add',
                  hint: 'Enter the quantity to add',
                ),

                const SizedBox(height: 16),

                WritableDateField(
                  controller: _expirationDateController,
                  onChanged: (_) => _updateButtonState(),
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
                      'Add to Warehouse',
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

    final bloc = context.read<InventoryAdditionBloc>();

    bloc.add(OnValidateStockToAddEvent(_stockToAddController.text));

    final currentState = bloc.state;
    if (currentState.status == Status.failure) return;

    _waitingForSubmitResult = true;

    context.read<InventoryAdditionBloc>().add(
      SubmitInventoryAdditionEvent(
        warehouseId: widget.warehouseId,
        productId: currentState.selectedProductId,
        quantity: currentState.quantityToAdd,
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
