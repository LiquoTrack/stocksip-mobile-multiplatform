import 'package:flutter/material.dart';
import 'package:stocksip/features/inventory_management/storage/domain/models/product_response.dart';

class CreateOrEditProductPage extends StatefulWidget {
  final ProductResponse? product;

  const CreateOrEditProductPage({super.key, this.product});

  @override
  State<CreateOrEditProductPage> createState() => _CreateOrEditProductPageState();
}

class _CreateOrEditProductPageState extends State<CreateOrEditProductPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}