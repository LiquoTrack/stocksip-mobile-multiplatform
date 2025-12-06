import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stocksip/features/inventory_management/warehouses/domain/models/warehouse.dart';

/// A card widget to select a warehouse
class WarehouseSelectorCard extends StatelessWidget {
  final Warehouse warehouse;
  final bool isSelected;
  final VoidCallback onTap;

  const WarehouseSelectorCard({
    super.key,
    required this.warehouse,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: isSelected ? 2 : 1,
            color: isSelected ? const Color(0xFF7C090F) : Colors.grey,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                warehouse.imageUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 40,
                  height: 40,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 20),
                ),
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Text(
                warehouse.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
