import 'package:flutter/material.dart';

class IndicatorPainter extends CustomPainter {
  final double value;

  IndicatorPainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Vertical line
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), paint);

    // Triangle at bottom
    final path = Path()
      ..moveTo(-6, size.height)
      ..lineTo(0, size.height + 8)
      ..lineTo(6, size.height)
      ..close();

    canvas.drawPath(path, paint..style = PaintingStyle.fill);

    // Value label at top
    final textPainter = TextPainter(
      text: TextSpan(
        text: value.toStringAsFixed(1),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height - 4),
    );
  }

  @override
  bool shouldRepaint(IndicatorPainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
