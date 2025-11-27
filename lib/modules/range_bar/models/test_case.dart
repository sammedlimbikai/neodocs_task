import 'package:neodocs_task/modules/range_bar/models/range_data.dart';

class TestCase {
  final String testName;
  final List<RangeData> ranges;

  TestCase({required this.testName, required this.ranges});

  factory TestCase.fromRangeList(List<dynamic> rangeList, String testName) {
    return TestCase(
      testName: testName,
      ranges: rangeList
          .map((r) => RangeData.fromJson(r as Map<String, dynamic>))
          .toList(),
    );
  }

  double get maxValue => ranges.isEmpty ? 100 : ranges.last.max;
}
