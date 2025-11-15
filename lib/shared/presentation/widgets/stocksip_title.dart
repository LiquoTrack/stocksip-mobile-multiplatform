import 'package:flutter/material.dart';

class StockSipLogo extends StatelessWidget {
  final double fontSize;

  const StockSipLogo({super.key, this.fontSize = 64});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Stock',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.red,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          'Sip',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}