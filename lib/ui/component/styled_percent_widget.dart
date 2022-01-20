import 'package:flutter/material.dart';

class StyledPercent extends StatelessWidget {
  final double awarnessPercent;
  final int fractionDigits;
  final Color? color;

  const StyledPercent({
    Key? key,
    required this.awarnessPercent,
    this.fractionDigits = 1,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFull = awarnessPercent.toInt() == 100;

    final clor = (color ?? Colors.grey[300])!;
    final clorBg = clor.withOpacity(.5);

    return Container(
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: isFull ? Colors.green[200] : clorBg,
      ),
      child: SizedBox(
        width: 50,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Row(
                  children: [
                    Expanded(
                      flex: awarnessPercent.toInt(),
                      child: Container(color: clor),
                    ),
                    Expanded(
                      flex: 100 - awarnessPercent.toInt(),
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  awarnessPercent.toStringAsFixed(fractionDigits) + ' %',
                  style: TextStyle(
                    fontSize: 12,
                    color: isFull ? Colors.white : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
