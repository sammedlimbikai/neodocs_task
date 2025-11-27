import 'package:flutter/material.dart';

import '../../models/range_data.dart';
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
        // Range labels above the bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: ranges.map((range) {
              final width = (range.max - range.min) / maxValue;
              return Expanded(
                flex: (width * 1000).round(),
                child: Center(
                  child: Text(
                    range.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        // Bar with indicator
        SizedBox(
          height: 50,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Row(
                      children: ranges.asMap().entries.map((entry) {
                        final index = entry.key;
                        final range = entry.value;
                        final width = (range.max - range.min) / maxValue;
                        final isLast = index == ranges.length - 1;

                        return Expanded(
                          flex: (width * 1000).round(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: range.color,
                              border: Border(
                                right: isLast
                                    ? BorderSide.none
                                    : const BorderSide(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  // Value indicator
                  Positioned(
                    left: (value / maxValue * constraints.maxWidth).clamp(
                      0.0,
                      constraints.maxWidth,
                    ),
                    top: 0,
                    bottom: 0,
                    child: CustomPaint(painter: IndicatorPainter(value: value)),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 20,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: _buildRangeMarkers(context, constraints.maxWidth),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _buildRangeMarkers(BuildContext context, double totalWidth) {
    final markers = <Widget>[];
    double currentPosition = 0;

    for (int i = 0; i < ranges.length; i++) {
      final range = ranges[i];
      final rangeWidth = (range.max - range.min) / maxValue * totalWidth;

      // Add start marker for first range
      if (i == 0) {
        markers.add(
          Positioned(
            left: 0,
            child: Text(
              range.min.toStringAsFixed(0),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 10,
                color: Colors.black54,
              ),
            ),
          ),
        );
      }

      // Add end marker for each range
      currentPosition += rangeWidth;
      final markerPosition = currentPosition.clamp(0.0, totalWidth - 20);

      markers.add(
        Positioned(
          left: markerPosition,
          child: Text(
            range.max.toStringAsFixed(0),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 10,
              color: Colors.black54,
            ),
          ),
        ),
      );
    }

    return markers;
  }
}
