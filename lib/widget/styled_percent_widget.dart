import 'package:flutter/material.dart';

class StyledPercent extends StatelessWidget {
  final double awarnessPercent;
  final int fractionDigits;

  const StyledPercent({
    Key? key,
    required this.awarnessPercent,
    this.fractionDigits = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFull = awarnessPercent.toInt() == 100;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: isFull ? Colors.green[200] : Colors.grey[300],
      ),
      padding: const EdgeInsets.all(2),
      child: Text(
        awarnessPercent.toStringAsFixed(fractionDigits) + ' %',
        style: TextStyle(
          fontSize: 12,
          color: isFull ? Colors.white : null,
        ),
      ),
    );
  }
}
