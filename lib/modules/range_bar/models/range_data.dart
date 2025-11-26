import 'package:flutter/material.dart';

class RangeData {
  final double min;
  final double max;
  final String label;
  final Color color;

  RangeData({
    required this.min,
    required this.max,
    required this.label,
    required this.color,
  });

  factory RangeData.fromJson(Map<String, dynamic> json) {
    return RangeData(
      min: (json['min'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
      label: json['label'] as String,
      color: _parseColor(json['color'] as String),
    );
  }

  static Color _parseColor(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
