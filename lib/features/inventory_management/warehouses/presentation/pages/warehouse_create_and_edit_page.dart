import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/enums/status.dart';
import 'package:stocksip/features/inventory_management/warehouses/domain/models/warehouse.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/bloc/warehouse_bloc.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/bloc/warehouse_event.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/bloc/warehouse_state.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/components/image_picker.dart';
import 'package:stocksip/features/inventory_management/warehouses/presentation/components/text_field.dart';

class CreateAndEditWarehousePage extends StatefulWidget {
  final Warehouse? warehouse;
  const CreateAndEditWarehousePage({super.key, this.warehouse});

  @override
  State<CreateAndEditWarehousePage> createState() =>
      _CreateAndEditWarehousePageState();
}

class _CreateAndEditWarehousePageState
    extends State<CreateAndEditWarehousePage> {
  final _formKey = GlobalKey<FormState>();

  late final List<TextEditingController> _controllers;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _minTempController = TextEditingController();
  final TextEditingController _maxTempController = TextEditingController();

  File? _selectedImage;

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    _controllers = [
      _nameController,
      _streetController,
      _cityController,
      _districtController,
      _postalCodeController,
      _countryController,
      _capacityController,
      _minTempController,
      _maxTempController,
    ];

    if (widget.warehouse != null) {
      _nameController.text = widget.warehouse!.name;
      _streetController.text = widget.warehouse!.addressStreet;
      _cityController.text = widget.warehouse!.addressCity;
      _districtController.text = widget.warehouse!.addressDistrict;
      _postalCodeController.text = widget.warehouse!.addressPostalCode;
      _countryController.text = widget.warehouse!.addressCountry;
      _capacityController.text = widget.warehouse!.capacity.toString();
      _minTempController.text = widget.warehouse!.temperatureMin.toString();
      _maxTempController.text = widget.warehouse!.temperatureMax.toString();
    }

    for (var controller in _controllers) {
      controller.addListener(_updateButtonState);
    }

    _updateButtonState();
  }

  void _updateButtonState() {
    final allFilled = _controllers.every((c) => c.text.isNotEmpty);

    final currentState = context.read<WarehouseBloc>().state;
    final shouldEnable = allFilled && currentState.status != Status.failure;
    if (shouldEnable != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = shouldEnable;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WarehouseBloc, WarehouseState>(
      listener: (context, state) {
        if (state.messsage.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.messsage)));
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
                  widget.warehouse == null ? 'New Warehouse' : 'Edit Warehouse',
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
                  label: 'Warehouse Name',
                  hint: 'Main Warehouse',
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _streetController,
                  label: 'Street',
                  hint: 'Calle 123',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _cityController,
                        label: 'City',
                        hint: 'Lima',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        controller: _districtController,
                        label: 'District',
                        hint: 'Chorrillos',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _postalCodeController,
                        label: 'Postal Code',
                        hint: '12063',
                        keyboard: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        controller: _countryController,
                        label: 'Country',
                        hint: 'Peru',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _capacityController,
                  label: 'Capacity',
                  hint: '1000',
                  keyboard: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _minTempController,
                        label: 'Min Temp',
                        hint: '5.0',
                        keyboard: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        controller: _maxTempController,
                        label: 'Max Temp',
                        hint: '25.0',
                        keyboard: TextInputType.number,
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
                      widget.warehouse == null
                          ? 'Add Warehouse'
                          : 'Update Warehouse',
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

    final minTemp = double.tryParse(_minTempController.text) ?? 0.0;
    final maxTemp = double.tryParse(_maxTempController.text) ?? 0.0;

    context.read<WarehouseBloc>().add(
      OnValidateTemperatureRange(
        minTemperature: minTemp,
        maxTemperature: maxTemp,
      ),
    );

    final currentState = context.read<WarehouseBloc>().state;
    if (currentState.status == Status.failure) return;

    final warehouse = Warehouse(
      warehouseId: widget.warehouse?.warehouseId ?? '',
      name: _nameController.text,
      addressStreet: _streetController.text,
      addressCity: _cityController.text,
      addressDistrict: _districtController.text,
      addressPostalCode: _postalCodeController.text,
      addressCountry: _countryController.text,
      capacity: double.tryParse(_capacityController.text) ?? 0.0,
      temperatureMin: minTemp,
      temperatureMax: maxTemp,
      imageUrl: widget.warehouse?.imageUrl ?? '',
    );

    if (widget.warehouse == null) {
      context.read<WarehouseBloc>().add(
        OnWarehouseCreated(warehouse: warehouse, image: _selectedImage),
      );
    } else {
      context.read<WarehouseBloc>().add(
        OnWarehouseUpdated(warehouse: warehouse),
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
