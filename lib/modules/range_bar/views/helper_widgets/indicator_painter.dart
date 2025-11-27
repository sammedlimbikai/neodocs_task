import 'package:flutter/material.dart';

class IndicatorPainter extends CustomPainter {
  final double value;

  IndicatorPainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    // Vertical line
    final linePaint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(0, 0), Offset(0, size.height), linePaint);

    // Triangle pointer at bottom
    final trianglePath = Path()
      ..moveTo(-8, size.height)
      ..lineTo(0, size.height + 10)
      ..lineTo(8, size.height)
      ..close();

    final trianglePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    canvas.drawPath(trianglePath, trianglePaint);

    // Value label at top with background
    final textSpan = TextSpan(
      text: value.toStringAsFixed(1),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Background for text
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(0, -textPainter.height / 2 - 8),
        width: textPainter.width + 12,
        height: textPainter.height + 6,
      ),
      const Radius.circular(4),
    );

    final bgPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    canvas.drawRRect(bgRect, bgPaint);

    // Paint text
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height - 8),
    );
  }

  @override
  bool shouldRepaint(IndicatorPainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
