import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/test_case.dart';

// Add your models import here
// import '../models/test_case.dart';

class TestDataProvider extends ChangeNotifier {
  List<TestCase> _testCases = [];
  bool _isLoading = false;
  String? _error;
  final Map<int, double> _inputValues = {};

  List<TestCase> get testCases => _testCases;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double getInputValue(int index) {
    return _inputValues[index] ?? _getDefaultValue(index);
  }

  double _getDefaultValue(int index) {
    if (index >= _testCases.length) return 50;
    final ranges = _testCases[index].ranges;
    if (ranges.isEmpty) return 50;
    final midRange = ranges[ranges.length ~/ 2];
    return (midRange.min + midRange.max) / 2;
  }

  void updateInputValue(int index, double value) {
    _inputValues[index] = value;
    notifyListeners();
  }

  Future<void> fetchTestData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // API Configuration
      const String baseUrl =
          'https://nd-assignment.azurewebsites.net/api/get-ranges';
      const String bearerToken =
          'eb3dae0a10614a7e719277e07e268b12aeb3af6d7a4655472608451b321f5a95';

      // Validate and parse URI
      if (baseUrl.isEmpty) {
        throw const FormatException('Base URL is empty');
      }

      final uri = Uri.parse(baseUrl);

      // Verify URI is valid
      if (!uri.hasScheme) {
        throw const FormatException('URL must have a scheme (http/https)');
      }

      if (uri.scheme != 'http' && uri.scheme != 'https') {
        throw FormatException('Invalid URL scheme: ${uri.scheme}');
      }

      debugPrint('📡 API Request Details:');
      debugPrint('   URL: $uri');
      debugPrint('   Scheme: ${uri.scheme}');
      debugPrint('   Host: ${uri.host}');
      debugPrint('   Path: ${uri.path}');

      // Make HTTP request
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
        // Parse JSON response
        final data = json.decode(response.body) as Map<String, dynamic>;

        // Validate response structure
        if (!data.containsKey('testCases')) {
          throw const FormatException('Response missing "testCases" field');
        }

        final testCasesList = data['testCases'] as List;

        if (testCasesList.isEmpty) {
          debugPrint('⚠️  Warning: No test cases found in response');
        }

        _testCases = testCasesList
            .map((tc) => TestCase.fromJson(tc as Map<String, dynamic>))
            .toList();
        _error = null;

        debugPrint('✅ Successfully loaded ${_testCases.length} test cases:');
        for (var i = 0; i < _testCases.length; i++) {
          debugPrint(
            '   ${i + 1}. ${_testCases[i].testName} (${_testCases[i].ranges.length} ranges)',
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

// Helper function to validate URL before using
bool isValidUrl(String url) {
  try {
    final uri = Uri.parse(url);
    return uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  } catch (e) {
    return false;
  }
}

// Test your URL
void testUrl() {
  const testUrl = 'https://nd-assignment.azurewebsites.net/api/get-ranges';
  debugPrint('Testing URL: $testUrl');
  debugPrint('Valid: ${isValidUrl(testUrl)}');

  try {
    final uri = Uri.parse(testUrl);
    debugPrint('Scheme: ${uri.scheme}');
    debugPrint('Host: ${uri.host}');
    debugPrint('Path: ${uri.path}');
  } catch (e) {
    debugPrint('Error parsing URL: $e');
  }
}
