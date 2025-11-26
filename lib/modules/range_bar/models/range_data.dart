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
    // Parse the "range" field (e.g., "0-20")
    final rangeStr = json['range'] as String;
    final parts = rangeStr.split('-');

    return RangeData(
      min: double.parse(parts[0]),
      max: double.parse(parts[1]),
      label: json['meaning'] as String,
      color: _parseColor(json['color'] as String),
    );
  }

  static Color _parseColor(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
