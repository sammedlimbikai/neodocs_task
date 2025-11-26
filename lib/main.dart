import 'package:flutter/material.dart';
import 'package:neodocs_task/my_app.dart';

import 'core/custom_logger.dart';

void main() {
  CustomLogger.enableLogger();
  runApp(const MyApp());
}
