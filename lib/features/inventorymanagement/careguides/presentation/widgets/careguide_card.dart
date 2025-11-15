import 'package:flutter/material.dart';

class CareGuideCardData {
  final String id;
  final String title;
  final String? subtitle;
  final String imageUrl;

  const CareGuideCardData({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.subtitle,
  });
}

class CareGuideCard extends StatelessWidget {
  final CareGuideCardData data;
  final VoidCallback? onTap;

  const CareGuideCard({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color background = const Color(0xFFFDF2E6);
    final Color accent = const Color(0xFF7A1D2A);

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                data.imageUrl,
                width: 56,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (context, _, __) => Container(
                  width: 56,
                  height: 72,
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.inventory_2,
                    color: accent,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    data.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4C2E27),
                        ),
                  ),
                  if (data.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      data.subtitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.brown.shade400,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'See Guide',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
