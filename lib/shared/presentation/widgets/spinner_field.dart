import 'package:flutter/material.dart';

/// A custom spinner field widget that allows users to select from a list of options.
class CustomSpinnerField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final List<String> options;

  const CustomSpinnerField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    final bool disabled = options.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 6),

        GestureDetector(
          onTap: disabled
              ? null
              : () async {
                  final selected = await showModalBottomSheet<String>(
                    context: context,
                    useSafeArea: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder: (sheetContext) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 12),
                            Text(
                              label,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(),
                            ...options.map(
                              (option) => ListTile(
                                title: Text(option),
                                onTap: () => Navigator.pop(sheetContext, option),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      );
                    },
                  );

                  if (selected != null) {
                    controller.text = selected;
                  }
                },

          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
              color: disabled ? Colors.grey.shade200 : Colors.white,
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.text.isNotEmpty ? controller.text : hint,
                  style: TextStyle(
                    fontSize: 16,
                    color: controller.text.isNotEmpty
                        ? Colors.black
                        : Colors.grey.shade500,
                  ),
                ),

                disabled
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }
}