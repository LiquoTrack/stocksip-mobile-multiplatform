import 'package:flutter/material.dart';
import 'package:stocksip/features/inventory_management/care_guides/domain/models/careguide.dart';

class CareGuideCard extends StatelessWidget {
  final CareGuide data;
  final VoidCallback? onTap;
  final VoidCallback? onAssign;
  final VoidCallback? onEdit;
  final VoidCallback? onSeeGuide;
  final bool isSelected;
  final VoidCallback? onLongPress;
  final bool selectionMode;
  final VoidCallback? onTapSelect;

  const CareGuideCard({
    super.key,
    required this.data,
    this.onTap,
    this.onAssign,
    this.onEdit,
    this.onSeeGuide,
    this.isSelected = false,
    this.onLongPress,
    this.selectionMode = false,
    this.onTapSelect,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = selectionMode
        ? (isSelected ? const Color(0xFFE0CACA) : const Color(0xFFE9DCDC))
        : Colors.white;
    final Color border = selectionMode
        ? (isSelected ? const Color(0xFF4C1F24) : const Color(0xFFE0D4D4))
        : const Color(0xFFE0D4D4);

    return GestureDetector(
      onLongPress: onLongPress,
      onTap: selectionMode ? onTapSelect : onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            if (selectionMode)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? const Color(0xFF4C1F24) : Colors.white,
                  border: Border.all(color: const Color(0xFF4C1F24), width: 2),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            if (selectionMode) const SizedBox(width: 12),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFEAD7C7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.local_drink, color: Color(0xFF4C1F24), size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.productName.isNotEmpty ? data.productName : data.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2B000D),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'See Guide',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (!selectionMode)
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Color(0xFF4C1F24)),
                onSelected: (value) {
                  switch (value) {
                    case 'see':
                      onSeeGuide?.call();
                      break;
                    case 'assign':
                      onAssign?.call();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'see',
                    child: Row(
                      children: [
                        Icon(Icons.visibility_outlined, color: Color(0xFF4C1F24)),
                        SizedBox(width: 8),
                        Text('Ver guía'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'assign',
                    child: Row(
                      children: [
                        Icon(Icons.assignment_ind_outlined, color: Color(0xFF4C1F24)),
                        SizedBox(width: 8),
                        Text('Asignar'),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}