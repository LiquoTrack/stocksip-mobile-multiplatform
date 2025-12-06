import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_addition/blocs/inventory_addition_bloc.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_addition/blocs/inventory_addition_event.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_addition/blocs/inventory_addition_state.dart';
import 'package:stocksip/features/inventory_management/inventory/presentation/inventory_addition/widgets/product_double_selector_field.dart';
import 'package:stocksip/shared/presentation/widgets/text_field.dart';
import 'package:stocksip/shared/presentation/widgets/writable_date_field.dart';
import 'package:intl/intl.dart';

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
  bool selectedFromInventory = false;

  bool _isButtonEnabled = false;
  bool _waitingForSubmitResult = false;

  @override
  void initState() {
    super.initState();

    // Sólo campos obligatorios
    _controllers = [_stockToAddController];

    context.read<InventoryAdditionBloc>().add(
      LoadProductListEvent(widget.warehouseId),
    );

    for (var controller in _controllers) {
      controller.addListener(_updateButtonState);
    }

    _updateButtonState();
  }

  void _updateButtonState() {
    final stockFilled = _stockToAddController.text.isNotEmpty;
    final currentState = context.read<InventoryAdditionBloc>().state;

    final shouldEnable = stockFilled && currentState.status != Status.failure;

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
                const Text(
                  'Add Products',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 24),

                BlocBuilder<InventoryAdditionBloc, InventoryAdditionState>(
                  builder: (context, state) {
                    return ProductDoubleSelectorField(
                      products: state.products,
                      inventories: state.inventories,
                      selectedProductId: selectedProductId,
                      selectedFromInventory: selectedFromInventory,

                      // 🔥 Callback actualizado
                      onItemSelected:
                          ({
                            required String productId,
                            required bool fromInventory,
                            DateTime? expirationDate,
                            int? quantity,
                          }) {
                            setState(() {
                              selectedProductId = productId;
                              selectedFromInventory = fromInventory;
                            });

                            final bloc = context.read<InventoryAdditionBloc>();

                            // 1. Actualiza producto seleccionado
                            bloc.add(UpdateSelectedProductEvent(productId));

                            // 2. Actualiza si viene de inventario
                            bloc.add(
                              UpdateSelectedFromInventoryEvent(fromInventory),
                            );

                            // 3. Si selecciona INVENTARIO → precargar datos
                            if (fromInventory) {
                              if (expirationDate != null) {
                                _expirationDateController.text = DateFormat(
                                  'yyyy-MM-dd',
                                ).format(expirationDate);
                              } else {
                                _expirationDateController.clear();
                              }

                              bloc.add(
                                UpdateExpirationDateEvent(expirationDate),
                              );

                              if (quantity != null) {
                                bloc.add(UpdateQuantityEvent(quantity));
                              }
                            } else {
                              // Selección desde productos → limpiar fecha
                              _expirationDateController.clear();
                              bloc.add(UpdateExpirationDateEvent(null));
                            }

                            _updateButtonState();
                          },
                    );
                  },
                ),

                const SizedBox(height: 32),

                CustomTextField(
                  controller: _stockToAddController,
                  label: 'Stock to add',
                  hint: 'Enter the quantity to add',
                ),

                const SizedBox(height: 16),

                WritableDateField(controller: _expirationDateController),

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
                    child: const Text(
                      'Add to Warehouse',
                      style: TextStyle(
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

    bloc.add(
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
    for (var c in _controllers) {
      c.dispose();
    }
    _expirationDateController.dispose();
    super.dispose();
  }
}