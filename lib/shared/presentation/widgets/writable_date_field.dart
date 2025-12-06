import 'package:flutter/material.dart';
import 'package:stocksip/core/common/utils/date_formatter.dart';

/// A writable date field widget that allows users to input dates in a specific format.
class WritableDateField extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final String hint;
  final Function(String)? onChanged;

  const WritableDateField({
    super.key,
    this.controller,
    this.onChanged,
    this.label = "Expiration Date",
    this.hint = "MM/DD/YYYY",
  });

  @override
  State<WritableDateField> createState() => _WritableDateFieldState();
}

class _WritableDateFieldState extends State<WritableDateField> {
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();

    _controller.addListener(() {
      final text = _controller.text;
      final error = _validateDate(text);

      if (error != _errorText) {
        setState(() {
          _errorText = error;
        });
      }

      widget.onChanged?.call(text);
    });
  }

  String? _validateDate(String text) {
    if (text.isEmpty) return null;
    if (text.length != 10) return "Invalid date format";

    final parts = text.split("/");
    if (parts.length != 3) return "Invalid format";

    final month = int.tryParse(parts[0]);
    final day = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (month == null || day == null || year == null) {
      return "Invalid date";
    }

    if (month < 1 || month > 12) return "Month must be 1–12";

    if (day < 1 || day > 31) return "Day must be 1–31";

    final maxDays = _daysInMonth(month, year);
    if (day > maxDays) return "Invalid day for this month";

    if (year < DateTime.now().year) return "Year must be ≥ current year";

    return null;
  }

  int _daysInMonth(int month, int year) {
    final nextMonth =
        (month == 12) ? DateTime(year + 1, 1, 1) : DateTime(year, month + 1, 1);
    return nextMonth.subtract(const Duration(days: 1)).day;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        DateFormatter(),
      ],
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        errorText: _errorText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _errorText != null ? Colors.red : const Color(0xFF2B000D),
            width: 2,
          ),
        ),
      ),
    );
  }
}