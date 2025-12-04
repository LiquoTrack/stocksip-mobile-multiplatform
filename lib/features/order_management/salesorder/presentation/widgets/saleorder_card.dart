 import 'package:flutter/material.dart';
import 'package:stocksip/features/order_management/salesorder/domain/models/saleorder.dart';

class SaleorderCard extends StatelessWidget {
  final Saleorder order;
  const SaleorderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF4C1F24);
    final softBg = const Color(0xFFFFF6EE);
    final chipBg = const Color(0xFFFFE79A);
    final chipText = const Color(0xFF2B000D);

    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final totalQty = order.items.fold<double>(0, (p, e) => p + e.quantityToSell);

    return Card(
      color: softBg,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('#${order.orderCode.isNotEmpty ? order.orderCode : order.id}',
                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(
              firstItem?.productName ?? '—',
              style: TextStyle(color: primary, fontWeight: FontWeight.w700, fontSize: 18),
            ),
            const SizedBox(height: 8),
            if (firstItem != null) ...[
              Text('Price: ${firstItem.currency} ${firstItem.unitPrice.toStringAsFixed(2)}',
                  style: TextStyle(color: primary.withOpacity(0.8))),
              const SizedBox(height: 4),
            ],
            Text('Quantity: ${totalQty.toStringAsFixed(0)}',
                style: const TextStyle(color: Color(0xFFD36A76), fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: chipBg, borderRadius: BorderRadius.circular(8)),
              child: Text(order.status.isEmpty ? 'Draft' : order.status,
                  style: TextStyle(color: chipText, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 12),
            Text(
              'Generated at: ${order.receiptDate?.toLocal().toString().split(' ').first ?? '-'}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}