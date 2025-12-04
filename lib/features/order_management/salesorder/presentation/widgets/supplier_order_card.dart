import 'package:flutter/material.dart';
import 'package:stocksip/features/order_management/salesorder/domain/models/saleorder.dart';

class SupplierOrderCard extends StatelessWidget {
  final Saleorder order;
  const SupplierOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final softBg = const Color(0xFFFFF6EE);
    final titleColor = const Color(0xFF4C1F24);
    final accent = const Color(0xFFB2737C);

    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final totalQty = order.items.fold<double>(0, (p, e) => p + e.quantityToSell);

    Color statusBg(String s) {
      switch (s.toLowerCase()) {
        case 'received':
        case 'completed':
          return const Color(0xFFB7F0C1);
        case 'pending':
        case 'draft':
          return const Color(0xFFFFE79A);
        default:
          return const Color(0xFFE0E0E0);
      }
    }

    Color statusText(String s) {
      switch (s.toLowerCase()) {
        case 'received':
        case 'completed':
          return const Color(0xFF0D6B33);
        case 'pending':
        case 'draft':
          return const Color(0xFF2B000D);
        default:
          return const Color(0xFF444444);
      }
    }

    return Card(
      color: softBg,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '#${order.orderCode.isNotEmpty ? order.orderCode : order.id}',
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              firstItem?.productName ?? '—',
              style: TextStyle(color: titleColor, fontWeight: FontWeight.w700, fontSize: 18),
            ),
            const SizedBox(height: 8),
            if (firstItem != null) ...[
              Text(
                'Price: ${firstItem.currency} ${firstItem.unitPrice.toStringAsFixed(2)}',
                style: TextStyle(color: titleColor.withOpacity(0.8)),
              ),
              const SizedBox(height: 4),
            ],
            Text(
              'Quantity: ${totalQty.toStringAsFixed(0)}',
              style: TextStyle(color: accent, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF6B6B6B),
                    side: const BorderSide(color: Color(0xFFDDDDDD)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {},
                  child: const Text('Change Status'),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusBg(order.status.isEmpty ? 'Draft' : order.status),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    (order.status.isEmpty ? 'Draft' : order.status),
                    style: TextStyle(
                      color: statusText(order.status.isEmpty ? 'Draft' : order.status),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (order.buyer.isNotEmpty) ...[
              Text(
                'Owner email: ${order.buyer}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 4),
            ],
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
