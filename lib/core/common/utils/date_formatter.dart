import 'package:flutter/services.dart';

class DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
  ) {
    var text = newValue.text;

    // Remove all non-digits
    text = text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limit max length (MMDDYYYY → 8 digits)
    if (text.length > 8) {
      text = text.substring(0, 8);
    }

    // Insert slashes: MM/DD/YYYY
    String formatted = "";
    for (int i = 0; i < text.length; i++) {
      formatted += text[i];
      if (i == 1 || i == 3) {
        formatted += "/";
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}