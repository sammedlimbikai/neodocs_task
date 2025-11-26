import 'package:flutter/material.dart';
import 'package:neodocs_task/modules/range_bar/views/bar_widget.dart';

import '../models/test_case.dart';

class TestCaseCard extends StatelessWidget {
  final TestCase testCase;
  final double value;
  final ValueChanged<double> onValueChanged;

  const TestCaseCard({
    super.key,
    required this.testCase,
    required this.value,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              testCase.testName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Input Value',
                border: const OutlineInputBorder(),
                suffixText: value.toStringAsFixed(1),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (text) {
                final parsedValue = double.tryParse(text);
                if (parsedValue != null) {
                  onValueChanged(parsedValue);
                }
              },
              controller: TextEditingController(text: value.toStringAsFixed(1))
                ..selection = TextSelection.collapsed(
                  offset: value.toStringAsFixed(1).length,
                ),
            ),
            const SizedBox(height: 24),
            BarWidget(
              ranges: testCase.ranges,
              value: value,
              maxValue: testCase.maxValue,
            ),
          ],
        ),
      ),
    );
  }
}
