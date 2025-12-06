import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? roleLabel;
  final bool enabled;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onDelete;
  final bool selectable;
  final bool selected;
  final VoidCallback? onLongPress;
  final VoidCallback? onTapSelect;

  const UserCard({
    super.key,
    this.title,
    this.subtitle,
    this.roleLabel,
    this.enabled = false,
    this.onToggle,
    this.onDelete,
    this.selectable = false,
    this.selected = false,
    this.onLongPress,
    this.onTapSelect,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = selectable
        ? (selected ? const Color(0xFFE0CACA) : const Color(0xFFE9DCDC))
        : Colors.white;
    final Color border = selectable
        ? (selected ? const Color(0xFF4C1F24) : const Color(0xFFE0D4D4))
        : const Color(0xFFE0D4D4);

    return GestureDetector(
      onLongPress: onLongPress,
      onTap: selectable ? onTapSelect : null,
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
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFE8D7D7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person, color: Color(0xFF4C1F24)),
            ),
            const SizedBox(width: 10),
            // Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF2B000D),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (roleLabel != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8D7D7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFE0D4D4)),
                          ),
                          child: Text(
                            roleLabel!,
                            style: const TextStyle(
                              color: Color(0xFF4C1F24),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      if (selectable) ...[
                        const SizedBox(width: 8),
                        Icon(
                          selected ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: selected ? const Color(0xFF4C1F24) : const Color(0xFFBFB5B5),
                        ),
                      ],
                    ],
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Color(0xFF6C6C6C), fontSize: 13),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}