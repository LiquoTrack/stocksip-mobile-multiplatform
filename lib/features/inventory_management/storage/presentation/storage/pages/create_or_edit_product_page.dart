import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/product_response.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/blocs/storage_bloc.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/blocs/storage_event.dart';
import 'package:stocksip/features/inventory_management/storage/presentation/storage/blocs/storage_state.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/components/text_field.dart';
import 'package:stocksip/shared/presentation/widgets/image_picker.dart';
import 'package:stocksip/shared/presentation/widgets/spinner_field.dart';

/// A page for creating or editing a product.
class CreateOrEditProductPage extends StatefulWidget {
  final ProductResponse? product;

  const CreateOrEditProductPage({super.key, this.product});

  @override
  State<CreateOrEditProductPage> createState() =>
      _CreateOrEditProductPageState();
}

class _CreateOrEditProductPageState extends State<CreateOrEditProductPage> {
  final _formKey = GlobalKey<FormState>();

  late final List<TextEditingController> _controllers;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _currencyCodeController = TextEditingController();
  final TextEditingController _minimumStockController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  File? _selectedImage;

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    _controllers = [
      _nameController,
      _typeController,
      _brandController,
      _unitPriceController,
      _currencyCodeController,
      _minimumStockController,
      _contentController,
    ];

    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _typeController.text = widget.product!.type;
      _brandController.text = widget.product!.brand;
      _unitPriceController.text = widget.product!.unitPrice.toString();
      _currencyCodeController.text = widget.product!.code;
      _minimumStockController.text = widget.product!.minimumStock.toString();
      _contentController.text = widget.product!.content.toString();
    }

    for (var controller in _controllers) {
      controller.addListener(_updateButtonState);
    }

    _updateButtonState();
  }

  void _updateButtonState() {
    final allFilled = _controllers.every((c) => c.text.isNotEmpty);

    final currentState = context.read<StorageBloc>().state;
    final shouldEnable = allFilled && currentState.status != Status.failure;
    if (shouldEnable != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = shouldEnable;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StorageBloc>().state;

    return BlocListener<StorageBloc, StorageState>(
      listener: (context, state) {
        if (state.message.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state.status == Status.success) {
          Navigator.pop(context);
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
                  widget.product == null ? 'New Product' : 'Edit Product',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ImagePickerField(
                  onImageSelected: (file) => _selectedImage = file,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _nameController,
                  label: 'Product Name',
                  hint: 'Blue Label',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomSpinnerField(
                        controller: _brandController,
                        label: 'Brand',
                        hint: 'Select a brand',
                        options: state.brandNames,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomSpinnerField(
                        controller: _typeController,
                        label: 'Type',
                        hint: 'Select a type',
                        options: state.productTypeNames,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _unitPriceController,
                        label: 'Unit Price',
                        hint: '100.00',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomSpinnerField(
                        controller: _currencyCodeController,
                        label: 'Currency',
                        hint: 'Select a currency',
                        options: state.currencyCodes,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _minimumStockController,
                        label: 'Minimum Stock',
                        hint: '10',
                        keyboard: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        controller: _contentController,
                        label: 'Content',
                        hint: '750',
                      ),
                    ),
                  ],
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
                      widget.product == null ? 'Add Product' : 'Update Product',
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

    final minimumStock = int.tryParse(_minimumStockController.text) ?? 0;

    context.read<StorageBloc>().add(
      OnValidateMinimumStock(minimumStock: minimumStock),
    );

    final currentState = context.read<StorageBloc>().state;
    if (currentState.status == Status.failure) return;

    final product = ProductResponse(
      id: widget.product?.id ?? '',
      name: _nameController.text,
      type: _typeController.text,
      brand: _brandController.text,
      unitPrice: double.tryParse(_unitPriceController.text) ?? 0.0,
      code: _currencyCodeController.text,
      minimumStock: minimumStock,
      content: double.tryParse(_contentController.text) ?? 0,
      totalStockInStore: 0,
      isInWarehouse: false,
      imageUrl: widget.product?.imageUrl ?? '',
    );

    if (widget.product == null) {
      context.read<StorageBloc>().add(
        OnProductCreatedEvent(product: product, imageFile: _selectedImage),
      );
    } else {
      context.read<StorageBloc>().add(
        OnProductUpdatedEvent(product: product, imageFile: _selectedImage),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
