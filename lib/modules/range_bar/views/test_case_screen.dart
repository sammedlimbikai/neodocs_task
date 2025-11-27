import 'package:flutter/material.dart';

import '../controllers/range_bar_controller.dart';
import 'test_case_card.dart';

class TestCasesScreen extends StatefulWidget {
  const TestCasesScreen({super.key});

  @override
  State<TestCasesScreen> createState() => _TestCasesScreenState();
}

class _TestCasesScreenState extends State<TestCasesScreen> {
  final TestDataProvider _provider = TestDataProvider();

  @override
  void initState() {
    super.initState();
    _provider.fetchTestData();
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Bar Widget Assignment'),
        centerTitle: true,
        elevation: 2,
      ),
      body: ListenableBuilder(
        listenable: _provider,
        builder: (context, child) => _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_provider.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading test data...'),
          ],
        ),
      );
    }

    if (_provider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                _provider.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _provider.fetchTestData,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_provider.ranges.isEmpty) {
      return const Center(child: Text('No ranges available'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TestCaseCard(
          testCase: _provider.asTestCase,
          value: _provider.inputValue,
          onValueChanged: (value) {
            _provider.updateInputValue(value);
          },
          onReload: () {
            _provider.fetchTestData();
          },
        ),
      ],
    );
  }
}
