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
  final VoidCallback? onAssign;
  final VoidCallback? onSeeGuide;

  const CareGuideCard({
    super.key,
    required this.data,
    this.onTap,
    this.onAssign,
    this.onSeeGuide,
  });

  @override
  Widget build(BuildContext context) {
    final Color background = const Color(0xFFFBF2E9);
    final Color accent = const Color(0xFF471725);
    final Color accentSecondary = const Color(0xFF9C2C3A);
    final Color iconBg = const Color(0xFFEAD7C7);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 340;
        final content = Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12.0),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.local_cafe, color: accent, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF6B6767),
                          ),
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: onSeeGuide ?? onTap,
                        icon: Icon(Icons.visibility_outlined, size: 18, color: accentSecondary),
                        label: Text(
                          'See Guide',
                          style: TextStyle(fontWeight: FontWeight.w700, color: accentSecondary),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          minimumSize: const Size(88, 44),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 96, minHeight: 48),
              child: ElevatedButton(
                onPressed: onAssign,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text('Assign', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            )
          ],
        );

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(18.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: isCompact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: content.children.sublist(0, content.children.length - 2),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: content.children.last,
                    ),
                  ],
                )
              : content,
        );
      },
    );
  }
}
