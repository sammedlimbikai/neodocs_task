import 'package:flutter/material.dart';

import '../models/range_data.dart';
import 'indicator_painter.dart';

class BarWidget extends StatelessWidget {
  final List<RangeData> ranges;
  final double value;
  final double maxValue;

  const BarWidget({
    super.key,
    required this.ranges,
    required this.value,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 80,
          child: Stack(
            children: [
              // Bar sections
              Row(
                children: ranges.map((range) {
                  final width = (range.max - range.min) / maxValue;
                  return Expanded(
                    flex: (width * 1000).round(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: range.color,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Center(
                        child: Text(
                          range.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              // Value indicator
              Positioned(
                left:
                    (value /
                            maxValue *
                            MediaQuery.of(context).size.width *
                            0.85)
                        .clamp(0.0, MediaQuery.of(context).size.width * 0.85),
                top: 0,
                bottom: 0,
                child: CustomPaint(painter: IndicatorPainter(value: value)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0', style: Theme.of(context).textTheme.bodySmall),
            Text(
              maxValue.toStringAsFixed(0),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}
