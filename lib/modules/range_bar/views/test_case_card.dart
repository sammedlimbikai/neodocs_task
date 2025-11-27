import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neodocs_task/modules/range_bar/views/bar_widget.dart';

import '../models/test_case.dart';

class TestCaseCard extends StatefulWidget {
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
  State<TestCaseCard> createState() => _TestCaseCardState();
}

class _TestCaseCardState extends State<TestCaseCard> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toStringAsFixed(1));
  }

  @override
  void didUpdateWidget(TestCaseCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update if value changed externally (not from this text field)
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value.toStringAsFixed(1);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              widget.testCase.testName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Input Value',
                border: OutlineInputBorder(),
                hintText: 'Enter a number',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              onChanged: (text) {
                if (text.isEmpty) return;
                final parsedValue = double.tryParse(text);
                if (parsedValue != null) {
                  widget.onValueChanged(parsedValue);
                }
              },
            ),
            const SizedBox(height: 24),
            BarWidget(
              ranges: widget.testCase.ranges,
              value: widget.value,
              maxValue: widget.testCase.maxValue,
            ),
          ],
        ),
      ),
    );
  }
}
