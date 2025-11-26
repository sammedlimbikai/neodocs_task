import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/range_data.dart';
import '../models/test_case.dart';

class TestDataProvider extends ChangeNotifier {
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
      const String baseUrl =
          'https://nd-assignment.azurewebsites.net/api/get-ranges';
      const String bearerToken =
          'eb3dae0a10614a7e719277e07e268b12aeb3af6d7a4655472608451b321f5a95';

      final uri = Uri.parse(baseUrl);

      if (!uri.hasScheme || (uri.scheme != 'http' && uri.scheme != 'https')) {
        throw const FormatException('Invalid URL scheme');
      }

      debugPrint('📡 API Request Details:');
      debugPrint('   URL: $uri');
      debugPrint('   Scheme: ${uri.scheme}');
      debugPrint('   Host: ${uri.host}');
      debugPrint('   Path: ${uri.path}');

      final response = await http
          .get(
            uri,
            headers: {
              'Authorization': 'Bearer $bearerToken',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception('Request timeout after 30 seconds');
            },
          );

      debugPrint('📥 Response received:');
      debugPrint('   Status Code: ${response.statusCode}');
      debugPrint('   Content Length: ${response.body.length} bytes');

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
          debugPrint('⚠️  Warning: No ranges found in response');
        }

        // Parse each range object
        _ranges = rangesList
            .map(
              (rangeObj) =>
                  RangeData.fromJson(rangeObj as Map<String, dynamic>),
            )
            .toList();

        _error = null;

        debugPrint('✅ Successfully loaded ${_ranges.length} ranges:');
        for (var i = 0; i < _ranges.length; i++) {
          debugPrint(
            '   ${i + 1}. ${_ranges[i].label}: ${_ranges[i].min}-${_ranges[i].max}',
          );
        }
      } else if (response.statusCode == 401) {
        _error = 'Authentication failed. Please check your bearer token.';
        debugPrint('❌ 401 Unauthorized: Invalid or expired token');
      } else if (response.statusCode == 404) {
        _error = 'API endpoint not found.';
        debugPrint('❌ 404 Not Found: Check the API URL');
      } else if (response.statusCode >= 500) {
        _error = 'Server error: ${response.statusCode}';
        debugPrint('❌ Server Error: ${response.statusCode}');
      } else {
        _error = 'Failed to load data: ${response.statusCode}';
        debugPrint('❌ HTTP Error: ${response.statusCode}');
      }
    } on FormatException catch (e) {
      _error = 'Invalid data format: ${e.message}';
      debugPrint('❌ Format Error: $e');
    } on http.ClientException catch (e) {
      _error = 'Network error: Unable to connect';
      debugPrint('❌ Client Error: $e');
    } on Exception catch (e) {
      _error = 'Error: ${e.toString()}';
      debugPrint('❌ Exception: $e');
    } catch (e) {
      _error = 'Unexpected error: ${e.toString()}';
      debugPrint('❌ Unexpected Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
