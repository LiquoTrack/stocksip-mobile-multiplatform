import 'package:flutter/material.dart';

class ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final Function(String) onValueChange;
  final bool isEditMode;
  final bool enabled;

  const ProfileField({
    super.key,
    required this.label,
    required this.value,
    required this.onValueChange,
    required this.isEditMode,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4A1B2A),
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8.0),
        if (isEditMode)
          TextFormField(
            initialValue: value,
            onChanged: onValueChange,
            enabled: enabled,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Color(0xFFD1C4C4),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Color(0xFFD1C4C4),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Color(0xFFD1C4C4),
                ),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            style: const TextStyle(
              color: Color(0xFF4A1B2A),
              fontSize: 16.0,
            ),
          )
        else
          Container(
            width: double.infinity,
            height: 56.0,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFD1C4C4),
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              value.isEmpty ? 'Not set' : value,
              style: TextStyle(
                color: value.isEmpty ? Colors.grey : const Color(0xFF4A1B2A),
                fontSize: 16.0,
              ),
            ),
          ),
      ],
    );
  }
}
