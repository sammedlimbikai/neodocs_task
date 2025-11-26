import 'package:neodocs_task/modules/range_bar/models/range_data.dart';

class TestCase {
  final String testName;
  final List<RangeData> ranges;

  TestCase({required this.testName, required this.ranges});

  factory TestCase.fromJson(Map<String, dynamic> json) {
    return TestCase(
      testName: json['testName'] as String,
      ranges: (json['ranges'] as List)
          .map((r) => RangeData.fromJson(r as Map<String, dynamic>))
          .toList(),
    );
  }

  double get maxValue => ranges.isEmpty ? 100 : ranges.last.max;
}
