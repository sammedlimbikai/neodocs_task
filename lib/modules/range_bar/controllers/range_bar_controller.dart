import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:neodocs_task/commons/endpoints.dart';
import 'package:neodocs_task/core/custom_http.dart';

import '../models/range_data.dart';
import '../models/test_case.dart';

class TestDataProvider extends ChangeNotifier {
  final _log = Logger("TestDataProvider");
  List<RangeData> _ranges = [];
  bool _isLoading = false;
  String? _error;
  double _inputValue = 50;

  List<RangeData> get ranges => _ranges;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get inputValue => _inputValue;

  double get maxValue => _ranges.isEmpty ? 116 : _ranges.last.max;

  void updateInputValue(double value) {
    _inputValue = value;
    notifyListeners();
  }

  // Optional: if you still need TestCase wrapper
  TestCase get asTestCase => TestCase(testName: 'Health Test', ranges: _ranges);

  Future<void> fetchTestData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await CustomHttp.instance.get(
        Uri.parse(Endpoints.getRanges),
      );

      _log.fine('📥 Response received:');
      _log.fine('   Status Code: ${response.statusCode}');
      _log.fine('   Content Length: ${response.body.length} bytes');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        // Validate that response is a List
        if (decoded is! List) {
          throw FormatException(
            'Expected array response, got: ${decoded.runtimeType}',
          );
        }

        final rangesList = decoded;

        if (rangesList.isEmpty) {
          _log.warning('No ranges found in response');
        }

        // Parse each range object
        _ranges = rangesList
            .map(
              (rangeObj) =>
                  RangeData.fromJson(rangeObj as Map<String, dynamic>),
            )
            .toList();

        _error = null;

        _log.fine('✅ Successfully loaded ${_ranges.length} ranges:');
        for (var i = 0; i < _ranges.length; i++) {
          _log.fine(
            '   ${i + 1}. ${_ranges[i].label}: ${_ranges[i].min}-${_ranges[i].max}',
          );
        }
      } else if (response.statusCode == 401) {
        _error = 'Authentication failed. Please check your bearer token.';
        _log.severe('401 Unauthorized: Invalid or expired token');
      } else if (response.statusCode == 404) {
        _error = 'API endpoint not found.';
        _log.severe('404 Not Found: Check the API URL');
      } else if (response.statusCode >= 500) {
        _error = 'Server error: ${response.statusCode}';
        _log.severe('Server Error: ${response.statusCode}');
      } else {
        _error = 'Failed to load data: ${response.statusCode}';
        _log.severe('HTTP Error: ${response.statusCode}');
      }
    } on FormatException catch (e) {
      _error = 'Invalid data format: ${e.message}';
      _log.severe('Format Error: $e');
    } on http.ClientException catch (e) {
      _error = 'Network error: Unable to connect';
      _log.severe('Client Error: $e');
    } on Exception catch (e) {
      _error = 'Error: ${e.toString()}';
      _log.severe('Exception: $e');
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
      _log.severe('Unexpected Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
